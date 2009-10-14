Bananajour.require_gem 'dnssd'

require 'thread'
require 'timeout'

Thread.abort_on_exception = true

# Generic bonjour browser
#
# Example use:
#
#   browser = BonjourBrowser.new("_git._tcp,_bananajour")
#   loop do
#     sleep(1)
#     pp browser.replies.map {|r| r.name}
#   end
#
# Probably gem-worthy
class Bananajour::Bonjour::Browser
  def initialize(service)
    @service = service
    @mutex = Mutex.new
    @replies = []
    watch!
  end
  def replies
    @mutex.synchronize do
      @replies.clone
    end
  end
  private
    def watch!
      DNSSD.browse(@service) do |br|
        begin
          Timeout.timeout(5) do
            DNSSD.resolve(br) do |rr|
              begin
                @mutex.synchronize do
                  rr_exists = Proc.new {|existing_rr| existing_rr.target == rr.target && existing_rr.fullname == rr.fullname}
                  if (DNSSD::Flags::Add & br.flags.to_i) != 0
                    @replies << rr unless @replies.any?(&rr_exists)
                  else
                    @replies.delete_if(&rr_exists)
                  end
                end
              rescue DNSSD::UnknownError
                $stderr.puts "unknown error occurred in dnssd: #{$!.message}"
              ensure
                rr.service.stop unless rr.service.stopped?
              end
            end
          end
        rescue DNSSD::UnknownError
          $stderr.puts "unknown error occurred in dnssd: #{$!.message}"
        rescue Timeout::Error
          # Do nothing
        end
      end
    end
end
