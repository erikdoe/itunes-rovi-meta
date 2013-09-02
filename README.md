# itunes-rovi-meta

Improve iTunes audio metadata with information from AllMusic (rovi).

As is the script **overwrites** the Genre field with the first genre from AllMusic and it **overwrites** the Comment field with a list of the styles from AllMusic. The relevant logic is in the loop at the bottom of the main script. I think it's quite readable but if you don't know Ruby you probably shouldn't play with this.


## Usage

Copy `config.yml.example` to `config.yml` and add your rovi API key and shared secret.

Run `itunes-rovi-meta.rb -h` to get a list of the command-line options. 

Unless you specify the `-d` flag the script will **modify your iTunes tracks**. You do this on your own. Make a backup first. Don't ask me.

The script will work on the tracks currently selected in iTunes. If no track is selected it will run over **all tracks** in your library.

## Installation

You need a few gems. I should really package this up.

* rb-appscript
* unicode
* json


## Limitations

* Ignores any track that is marked as in a compilation.
* Ignores all podcasts.
* Ignores non-file tracks, i.e. shared and cloud tracks.
* Once a result is cached it's never retrieved again.
* Only searches by album title. Only searches once. If the title is popular, e.g. "17", "III", the script may not find the album even though it is in the AllMusic database.


## Background Info

* [http://cl.ly/C3kK]()
* [http://www.gogogad.de/2011/12/22/howto-id3-tags-durch-itunes-match-und-ruby-script-ersetzen.html]()
* [http://developer.rovicorp.com/docs]()



