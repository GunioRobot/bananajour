Bananajour - Local git publication and collaboration
====================================================

Local git repository hosting with a sexy web interface and Bonjour discovery. It's like a bunch of adhoc, local, network-aware githubs!

Unlike Gitjour, the repositories you're serving are not your working git repositories, they're served from `~/.bananajour/repositories`. You can push to your bananajour repositories from your working copies just like you do with github.


![Screenshot of local view of Bananajour 2.1.3](http://cloud.github.com/downloads/toolmantim/bananajour/screenshot.png)

Installation and usage
----------------------

You'll need at least [git version 1.6](http://git-scm.com/). Run `git --version` if you're unsure.

Install it from [gemcutter](http://gemcutter.org/) via gems:

    gem install bananajour

(you might need to do a `gem sources -a http://gemcutter.org` beforehand!)

Start it up:

    bananajour
    
Go into an existing project and add it to bananajour:

    cd ~/code/myproj
    bananajour add

Publish your codez:

    git push banana master

Fire up [http://localhost:9331/](http://localhost:9331/) to check it out.

If somebody starts sharing a Bananajour repository with the same name on the
network it'll automatically show up in the network thanks to the wonder that is Bonjour.

For a list of all the commands:

    bananajour help

Linux support
-------------

To install the dnssd gem on linux you'll need [avahi](http://avahi.org/). For Ubunutu peeps this means:

    sudo apt-get install libavahi-compat-libdnssd-dev

On Linux, if you kill bananajour with kill -9 it doesn't get a chance to unregister the Bonjour services, and when it is restarted it will die with DNSSD::AlreadyRegisteredError.  Although not ideal, you can work around this my restarting avahi-daemon first.

Using with Ginatra
------------------

Rumour has it [ginatra](http://github.com/lenary/ginatra) can be used to provide richer gitweb-like browsing of your bananajour repositories. Symlink ginatra's `repos` directory to `~/.bananajour/repositories` to serve up your bananajour repositories.

Official repository and support
-------------------------------

The official repo and support issues/tickets live at [github.com/toolmantim/bananajour](http://github.com/toolmantim/bananajour).

Feature and support discussions live at [groups.google.com/group/bananajour](http://groups.google.com/group/bananajour).

Developing
----------

If you want to hack on the sinatra app then do so from a local clone but run your actual bananjour from the gem version. Running the sinatra app directly won't broadcast it onto the network and it'll run on a different port:

    ruby sinatra/app.rb -s thin

If you want code reloading use [shotgun](http://github.com/rtomayko/shotgun) instead:

    shotgun sinatra/app.rb -s thin

If you then want to run your working copy as your public bananajour rebuild and install it as a gem:

    sudo rake gem:install

Contributors
------------

* [Carla Hackett](http://carlahackettdesign.com/) (logo)
* [Nathan de Vries](http://github.com/atnan)
* [Lachlan Hardy](http://github.com/lachlanhardy)
* [Josh Bassett](http://github.com/nullobject)
* [Myles Byrne](http://github.com/quackingduck)
* [Ben Hoskings](http://github.com/benhoskings)
* [Brett Goulder](http://github.com/brettgo1)
* [Tony Issakov](https://github.com/tissak)
* [Mark Bennett](http://github.com/MarkBennett)
* [Travis Swicegood](http://github.com/tswicegood)
* [Nate Haas](http://github.com/natehaas)
* [James Sadler](http://github.com/freshtonic)

License
-------

All directories and files are MIT Licensed.

Warning to all those who still believe secrecy will save their revenue stream
-----------------------------------------------------------------------------
Bananas were meant to be shared. There are no secret bananas.