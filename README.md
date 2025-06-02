# dqxtools_send_to_chat

Sends text from outside of DQX into your DQX chat window. Helpful when you don't know how to type Japanese, but need to send Japanese text to progress a quest or communicate with someone. This exists because there is no copy/paste support into the DQX client.

https://user-images.githubusercontent.com/17505625/149629499-177e6f91-97c9-4389-98f9-314ed9b4ef64.mp4

## installation

Check out the help site [here](https://dqx-translation-project.github.io/sendtochat.html).

## versioning / releasing

The app version is pinned to the top of `send_to_chat.ahk` (`scriptVer`). Each launch checks against the latest release's tag in this repository. If a new release is being generated, make sure to update `send_to_chat.ahk` to use the new tag before tagging and creating the release. Otherwise, the application will think the app is out of date and will prompt the user to keep updating it.
