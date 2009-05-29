Bananajour - Local git publication and collaboration
====================================================

Local git repository hosting with a sexy web interface and Bonjour discovery. It's like a bunch of adhoc, local, network-aware githubs!

Unlike Gitjour, the repositories you're serving are not your working git repositories. You can publish projects from any directory and each will be shown in the same hot web interface.

Bananajour is the baby of [Tim Lucas](http://toolmantim.com/) with much railscamp hackage by [Nathan de Vries](http://github.com/atnan) and [Lachlan Hardy](http://github.com/lachlanhardy); and smaller railscamp additions by [Myles Byrne](http://github.com/quackingduck), [Ben Hoskings](http://github.com/benhoskings), [Brett Goulder](http://github.com/brettgo1), [Tony Issakov](https://github.com/tissak), [Josh Bassett](http://github.com/nullobject) and [Mark Bennett](http://github.com/MarkBennett). The rad logo was by [Carla Hackett](http://carlahackettdesign.com/).

Installation and usage
----------------------

You'll need at least [git version 1.6](http://git-scm.com/). Run `git --version` if you're unsure.

Install it:

    gem install bananajour

Start it up:

    bananajour
    
Initialize a new Bananajour repository:

    cd ~/code/myproj
    bananajour init

Publish your codez:

    git push banana master

Fire up [http://localhost:9331/](http://localhost:9331/) to check it out.

If somebody starts sharing a Bananajour repository with the same name on the
network, it'll automatically show up in the network thanks to the wonder that is Bonjour.

Official repository and support
-------------------------------

[http://github.com/toolmantim/bananajour](http://github.com/toolmantim/bananajour) is where Bananajour lives along with all of its support issues.

Developing
----------

If you want to hack on the sinatra app alongside a running bananjour just load the sinatra app directly (it won't broadcast itself onto the network):

    ruby sinatra/app.rb -s thin

If you want code reloading use [shotgun](http://github.com/rtomayko/shotgun) instead:

    shotgun sinatra/app.rb -s thin

License
-------

All directories and files are MIT Licensed.

Warning to all those who still believe secrecy will save their revenue stream
-----------------------------------------------------------------------------
Bananas were meant to be shared. There are no secret bananas.
