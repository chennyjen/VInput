# VInput Testing
We discovered over the course of our project that the existing iOS testing environment is notably limited for 3rd party custom keyboards, and particularly for a more unconventional keyboard like ours. Therefore, we were not able to develop automated testing using these libraries as we originally hoped to. Instead, we devised a set of standard tests we could perform with major changes to test functionality.

## Test 1: Basic Insertion
**Procedure:** Open the keyboard and swipe up.

**Expected Behavior:** The character ‘m’ should be inserted into the textbox and the corresponding announcement for this event is made.

## Test 2: Bounds of the Alphabet are Constrained
**Procedure:** Swipe all the way until ‘a’ and then keep swiping left.

**Expected Behavior:** The user should be left with ‘a’ as their only option.

## Test 3: Reset Selected Letter
**Procedure:** Open the keyboard, swipe right, then swipe down.

**Expected Behavior:** The current character should change from ‘m’ initially, to ’s’, and then reset back to ‘m’.

## Test 4: Backspace Selected Letter
**Procedure:** Open the keyboard, swipe up, then swipe down.

**Expected Behavior:** The character ‘m’ should be inserted and then removed such that the text box is blank.

## Test 5: Insert a Space
**Procedure:** Open the keyboard, swipe up, double tap, then swipe up.

**Expected Behavior:** There should be two 'm's separated by a space in the text field.

## Test 6: Repeat Current Character
**Procedure:** After opening the keyboard, double tap once.

**Expected Behavior:** "Left or right of m" should be announced again.

## Test 7: Repeat Previous Word
**Procedure:** Type the word "dog", and then hold with two fingers briefly anywhere on the screen.

**Expected Behavior:** The word “dog” should be read aloud.

## Test 8: Uppercase the Current Letter
**Procedure:** Open the keyboard and hold one finger briefly and then release.

**Expected Behavior:** The letter 'm' should change from lowercase to uppercase

## Test 9: Alphabet Toggle
**Procedure:** With the keyboard open, swipe right with two fingers.

**Expected Behavior:** The alphabet should change to either the emoji or number alphabets.

## Test 10: Voice Over Toggle
**Procedure:** Turn VO on, open the keyboard, and swipe right with three fingers.

**Expected Behavior:** The “Next Keyboard” button should be selected; double tapping on the screen will change to the next keyboard.

## Test 11: Close the Keyboard
**Procedure:** Open the keyboard and then pinch gesture anywhere on the screen.

**Expected Behavior:** The keyboard should slide down and dismiss.
