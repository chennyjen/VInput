# VInput
V(isually)I(mpaired)nput

## Alpha Release
As defined in our Alpha release project plan, below are the deliverables we have completed:
* Documentation of Brainstorming and Sprint Divergence ([Google Drive](https://drive.google.com/drive/u/1/folders/0Bx_oMYCmW6jGZlgxR2RQTWlnYTg))
* Initial Brainstormed Workflow ([Google Drive](https://drive.google.com/drive/u/1/folders/0Bx_oMYCmW6jGZlgxR2RQTWlnYTg))
* Characteristics of Individuals Involved in Testing (see "Target Users" in Usability Testing in [Google Drive](https://drive.google.com/drive/u/1/folders/0Bx_oMYCmW6jGZlgxR2RQTWlnYTg))
* Usability Testing Procedure and Results ([Google Drive](https://drive.google.com/drive/u/1/folders/0Bx_oMYCmW6jGZlgxR2RQTWlnYTg))
* Feature Discovery ([Google Drive](https://drive.google.com/drive/u/1/folders/0Bx_oMYCmW6jGZlgxR2RQTWlnYTg))
* "Hello World" full screen keyboard (GitHub)

## Beta Release
As defined in our Beta release project plan, below are the deliverables we have completed:
* Algorithm logic
 * The `Values` interface and subclasses primarily handle this logic
* Swiping/gesture setup
 * Gestures registered in `KeyboardViewController.swift` include: swipe left, swipe right, swipe up, swipe down, hold, two finger swipe right, three finger swipe right, double tap, two finger hold, two finger tap, and pinch
 * Gesture processing in `KeyboardViewController.swift` and primarily different mode files (i.e. `InputMode.swift`)
* Layout of keyboard
 * Different UIView elements make up the visual interface within `KeyboardViewController.swift`
* Controller development and input processing
 * `KeyboardViewController.swift` handles this in conjunction with different mode files (i.e. `InputMode.swift`)
* Voice prompting
 * Pervasive use throughout the project of AVFoundation's `AVSpeechSynthesizer`
* Keyboard activation
 * Initialization and setup upon triggered activation is found within `viewDidLoad()` of `KeyboardViewController.swift`
* "Happy path" testing: see TESTING.md

We also went beyond these specified items in our project plan in completing the following:
* **VoiceOver Integration:** UI setup to switch between VoiceOver and VInput gestures and speech announcements
* **Tutorial and Training Modes:** informative and interactive guide and steps to using VInput
* **Multiple Alphabets:** users can two finger swipe between lowercase, uppercase, basic emoji and numeric alphabets
* **Fault Tolerance:** resiliency and correction against crashes, errors, faults by reloading in memory the last word where the user left off (allowing the user to continue where they left off)
* **Ensuring Correct Input:** correctly places the input cursor at the rightmost location in the text field to prevent accidental deletion and correct appending of additional characters
* **CoreData Implementation:** as a user types right now, the words they type are stored on-device for later use in developing prediction features
* **Code Quality:** we spent significant time in the design of our code such that it is readable, maintainable, and extendable (i.e. inheritance in different input modes and alphabet values)
