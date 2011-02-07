**What's this?**

Work in progress on a swf-to-swf and swf-to-server communication system that facilitates async passing of messages.

**Huh?**

Kinda like email. Participants can send messages which are then new / pending / read / deleted.

**Using the flash SOL? Why?**

2 reasons:

*Case 1:* 
Users of an e-learning AIR app have the capacity to keep notes within the application. 

It would be inefficient to be constantly sending updates to the remote server. 

Instead, the SolMailBox keeps the notes locally at a short interval - 1 second, and a remote-connecting service grabs them periodically (1 minute) and sends them to the server. Saving locally ensures that if the user quits the programme between 1 minute remote-saves their notes are saved locally and can be uploaded next time.

*Case 2:* 
Converting some data to the in-application model from the remote representation is processor intensive. The fetching and digesting of the remote data can now be handed off to a second swf, which then writes the data in the ready-to-use for in the SOL. The using swf can then just pick the data up and run with it.

**Is that really viable?**

Maybe. Case 1 is certainly viable, Case 2 is experimental.

**Ok - how does it work?**

More to follow...