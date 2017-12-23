# Useless Uses of Kill -9

`kill -9` is a nuclear warhead used in place of a flashlight.  It will technically accomplish your goal,
but why does there have to be so much death?

* **Reasons to NEVER Use Kill -9**
  * Does not shut down socket connections
  * Will not clean temp files
  * Does not inform child processes it has been killed
  * Will not reset terminal characteristics

* **What you should do instead**
  * Send `kill -15`
  * Wait a few seconds
  * Send `kill -2`
  * Send `kill -1`
  * If still broken, remove the binary as it is not functional

