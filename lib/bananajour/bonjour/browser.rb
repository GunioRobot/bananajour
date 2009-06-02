Bananajour.require_gem 'dnssd'

require 'thread'
require 'timeout'

Thread.abort_on_exception = true

# Generic bonjour browser
#
# Example use:
# 
#   browser = BonjourBrowser.new("_bananajour._git._tcp")
#   loop do
#     sleep(1)
#     pp browser.replies.map {|r| r.name}
#   end
#
# Probably gem-worthy
class Bananajour::Bonjour::Browser
  attr_reader :replies
  def initialize(service)
    @service = service
    @mutex = Mutex.new
    @replies = []
    watch!
  end
  private
    def watch!
      DNSSD.browse(@service) do |br|
        begin
          Timeout.timeout(10) do
            DNSSD.resolve(br.name, br.type, br.domain) do |rr|
              begin
                @mutex.synchronize do
                  rr_exists = Proc.new {|existing_rr| existing_rr.target == rr.target && existing_rr.fullname == rr.fullname}
                  if (DNSSD::Flags::Add & br.flags.to_i) != 0
                    @replies << rr unless @replies.any?(&rr_exists)
                  else
                    @replies.delete_if(&rr_exists)
                  end
                end
              ensure
                rr.service.stop
              end
            end
          end
        rescue Timeout::Error
          # Do nothing
        end
      end
    end
end
