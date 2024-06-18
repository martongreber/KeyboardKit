//
//  KeyboardAction+StandardHandlerTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2019-05-06.
//  Copyright © 2019-2024 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS)
import MockingKit
import XCTest

@testable import KeyboardKit

final class KeyboardAction_StandardHandlerTests: XCTestCase {
    
    typealias Gesture = Gestures.KeyboardGesture

    private var handler: TestClass!
    var controller: MockKeyboardInputViewController!
    var spaceDragHandler: MockSpaceDragGestureHandler!
    var textDocumentProxy: MockTextDocumentProxy!

    var audioEngine: MockAudioFeedbackEngine!
    var hapticEngine: MockHapticFeedbackEngine!
    
    var registeredEmojis: [Emoji] = []
    

    override func setUp() {
        registeredEmojis = []
        
        controller = MockKeyboardInputViewController()
        spaceDragHandler = MockSpaceDragGestureHandler(action: { _ in })
        textDocumentProxy = MockTextDocumentProxy()
        textDocumentProxy.documentContextBeforeInput = ""

        controller.state.keyboardContext.locale = KeyboardLocale.swedish.locale
        controller.state.keyboardContext.originalTextDocumentProxy = textDocumentProxy
        controller.services.spaceDragGestureHandler = spaceDragHandler
        
        handler = TestClass(
            controller: controller,
            keyboardContext: controller.state.keyboardContext,
            keyboardBehavior: controller.services.keyboardBehavior,
            autocompleteContext: controller.state.autocompleteContext,
            feedbackContext: controller.state.feedbackContext,
            spaceDragGestureHandler: controller.services.spaceDragGestureHandler
        )
        
        handler.emojiRegistrationAction = { [weak self] in
            self?.registeredEmojis.append($0)
        }
        
        audioEngine = MockAudioFeedbackEngine()
        hapticEngine = MockHapticFeedbackEngine()
        Feedback.AudioEngine.shared = audioEngine
        Feedback.HapticEngine.shared = hapticEngine
    }


    func testCanHandleGestureOnActionThatIsNotNil() {
        XCTAssertTrue(handler.canHandle(.press, on: .backspace))
        XCTAssertFalse(handler.canHandle(.doubleTap, on: .backspace))
    }
    
    func testHandlingGestureOnActionTriggersManyOperations() {
        handler.handle(.release, on: .character("a"))
        XCTAssertTrue(handler.hasCalled(\.tryRemoveAutocompleteInsertedSpaceRef))
        XCTAssertTrue(handler.hasCalled(\.tryApplyAutocorrectSuggestionRef))
        XCTAssertTrue(handler.hasCalled(\.tryReinsertAutocompleteRemovedSpaceRef))
        XCTAssertTrue(handler.hasCalled(\.tryEndSentenceRef))
        XCTAssertTrue(handler.hasCalled(\.tryChangeKeyboardTypeRef))
        XCTAssertTrue(controller.hasCalled(\.performAutocompleteRef))
        XCTAssertEqual(registeredEmojis, [])
    }
    
    func testHandlingGestureOnEmojiTriggersEmojiRegistration() {
        handler.handle(.release, on: .emoji(.init("👍")))
        handler.handle(.release, on: .emoji(.init("🤩")))
        XCTAssertTrue(handler.hasCalled(\.tryRemoveAutocompleteInsertedSpaceRef))
        XCTAssertTrue(handler.hasCalled(\.tryApplyAutocorrectSuggestionRef))
        XCTAssertTrue(handler.hasCalled(\.tryReinsertAutocompleteRemovedSpaceRef))
        XCTAssertTrue(handler.hasCalled(\.tryEndSentenceRef))
        XCTAssertTrue(handler.hasCalled(\.tryChangeKeyboardTypeRef))
        XCTAssertTrue(controller.hasCalled(\.performAutocompleteRef))
        XCTAssertEqual(registeredEmojis.map { $0.char }, ["👍", "🤩"])
    }
    

    func testHandlingDragGestureOnActionDoesNotDoAnythingOnNonSpaceActions() {
        let actions = KeyboardAction.testActions.filter { $0 != .space }
        actions.forEach {
            handler.handleDrag(on: $0, from: .zero, to: .zero)
        }
        XCTAssertFalse(spaceDragHandler.hasCalled(\.handleDragGestureRef))
    }


    func testActionForGestureOnActionIsNotForAllActionsWithStandardAction() {
        KeyboardAction.testActions.forEach { action in
            Gesture.allCases.forEach { gesture in
                let result = handler.action(for: gesture, on: action)
                let resultIsNil = result == nil
                let standardActionIsNil = action.standardAction(for: gesture) == nil
                XCTAssertEqual(resultIsNil, standardActionIsNil)
            }
        }
    }

    func testReplacementActionIsOnlyDefinedForReleaseOnCharWithProxyReplacement() {
        var result = handler.replacementAction(for: .press, on: .character("”"))
        XCTAssertNil(result)
        result = handler.replacementAction(for: .release, on: .backspace)
        XCTAssertNil(result)
        result = handler.replacementAction(for: .release, on: .character("A"))
        XCTAssertNil(result)
        controller.state.keyboardContext.locale = KeyboardLocale.swedish.locale
        result = handler.replacementAction(for: .release, on: .character("‘"))
        XCTAssertNotNil(result)
        controller.state.keyboardContext.locale = KeyboardLocale.english.locale
        result = handler.replacementAction(for: .release, on: .character("‘"))
        XCTAssertNil(result)
    }

    func testShouldTriggerHapticFeedbackInSomeCases() {
        var result = handler.shouldTriggerHapticFeedback(for: .press, on: .control)
        XCTAssertFalse(result)
        result = handler.shouldTriggerHapticFeedback(for: .press, on: .character(""))
        XCTAssertTrue(result)
        result = handler.shouldTriggerHapticFeedback(for: .release, on: .character(""))
        XCTAssertFalse(result)
        result = handler.shouldTriggerHapticFeedback(for: .longPress, on: .space)
        XCTAssertTrue(result)
    }
    
    func testTriggerFeedbackForGestureOnActionCallsInjectedHandler() {
        handler.triggerFeedback(for: .press, on: .character(""))
        let audioCalls = audioEngine.calls(to: \.triggerRef)
        let hapticCalls = hapticEngine.calls(to: \.triggerRef)
        XCTAssertEqual(audioCalls.count, 1)
        XCTAssertEqual(hapticCalls.count, 1)
    }
    
    func validateAudioFeedback(
        for gesture: Gesture,
        on action: KeyboardAction,
        expected: Feedback.Audio?
    ) {
        let result = handler.audioFeedback(for: gesture, on: action)
        XCTAssertEqual(result, expected)
    }
    
    func testAudioFeedbackForGestureOnActionReturnsCorrectValue() {
        let config = handler.feedbackContext.audioConfiguration
        validateAudioFeedback(for: .longPress, on: .space, expected: nil)
        validateAudioFeedback(for: .press, on: .backspace, expected: config.delete)
        validateAudioFeedback(for: .press, on: .character("a"), expected: config.input)
        validateAudioFeedback(for: .press, on: .shift(currentCasing: .auto), expected: config.system)
    }
    
    func validateHapticFeedback(
        for gesture: Gesture,
        on action: KeyboardAction,
        expected: Feedback.Haptic?
    ) {
        let result = handler.hapticFeedback(for: gesture, on: action)
        XCTAssertEqual(result, expected)
    }
    
    func testHapticFeedbackForGestureOnActionReturnsCorrectValue() {
        let config = handler.feedbackContext.hapticConfiguration
        let char = KeyboardAction.character("a")
        validateHapticFeedback(for: .longPress, on: .space, expected: config.longPressOnSpace)
        validateHapticFeedback(for: .doubleTap, on: char, expected: config.doubleTap)
        validateHapticFeedback(for: .longPress, on: char, expected: config.longPress)
        validateHapticFeedback(for: .press, on: char, expected: config.press)
        validateHapticFeedback(for: .release, on: char, expected: config.release)
        validateHapticFeedback(for: .repeatPress, on: char, expected: config.repeat)
        
    }

    func testTryApplyCorrectSuggestionOnlyProceedsForReleaseOnSomeActionsWhenSuggestionsExist() {
        let ref = textDocumentProxy.deleteBackwardRef
        let autocompleteSuggestions = [Autocomplete.Suggestion(text: "", isAutocorrect: true, isUnknown: false)]

        textDocumentProxy.documentContextBeforeInput = "abc"
        handler.autocompleteContext.suggestions = autocompleteSuggestions

        handler.tryApplyAutocorrectSuggestion(before: .press, on: .space)
        XCTAssertFalse(textDocumentProxy.hasCalled(ref))

        handler.tryApplyAutocorrectSuggestion(before: .release, on: .backspace)
        XCTAssertFalse(textDocumentProxy.hasCalled(ref))

        handler.autocompleteContext.suggestions = []
        handler.tryApplyAutocorrectSuggestion(before: .release, on: .space)
        XCTAssertFalse(textDocumentProxy.hasCalled(ref))

        handler.autocompleteContext.suggestions = autocompleteSuggestions
        handler.tryApplyAutocorrectSuggestion(before: .release, on: .space)
        XCTAssertTrue(textDocumentProxy.hasCalled(ref))
    }

    func testTryingToEndSentenceAfterGestureOnActionIsOnlyCalledIfBehaviorSaysYes() {
        textDocumentProxy.documentContextBeforeInput = ""
        handler.tryEndSentence(after: .release, on: .character("a"))
        XCTAssertFalse(textDocumentProxy.hasCalled(\.deleteBackwardRef))
        XCTAssertFalse(textDocumentProxy.hasCalled(\.insertTextRef))

        textDocumentProxy.documentContextBeforeInput = "foo  "
        handler.tryEndSentence(after: .release, on: .space)
        XCTAssertTrue(textDocumentProxy.hasCalled(\.deleteBackwardRef, numberOfTimes: 2))
        XCTAssertTrue(textDocumentProxy.hasCalled(\.insertTextRef, numberOfTimes: 1))
    }

    func testTryToHandleReplacementActionBeforeGestureOnActionReturnsTrueForReleaseOnValidCharAction() {
        var result = handler.tryHandleReplacementAction(before: .release, on: .character("A"))
        XCTAssertFalse(result)
        result = handler.tryHandleReplacementAction(before: .doubleTap, on: .character("A"))
        XCTAssertFalse(result)
        controller.state.keyboardContext.locale = KeyboardLocale.swedish.locale
        result = handler.tryHandleReplacementAction(before: .release, on: .character("‘"))
        XCTAssertTrue(result)
        controller.state.keyboardContext.locale = KeyboardLocale.english.locale
        result = handler.tryHandleReplacementAction(before: .release, on: .character("‘"))
        XCTAssertFalse(result)
    }

    func testTryToReinsertAutocompleteRemovedSpaceAfterGestureOnActionProceedsForReleaseOnSomeActions() {
        textDocumentProxy.documentContextBeforeInput = "hi"
        textDocumentProxy.documentContextAfterInput = "you"
        textDocumentProxy.tryInsertSpaceAfterAutocomplete()
        textDocumentProxy.documentContextBeforeInput = "hi "
        textDocumentProxy.tryRemoveAutocompleteInsertedSpace()
        textDocumentProxy.resetCalls()

        handler.tryReinsertAutocompleteRemovedSpace(after: .press, on: .character(","))
        XCTAssertFalse(textDocumentProxy.hasCalled(\.insertTextRef))
        handler.tryReinsertAutocompleteRemovedSpace(after: .release, on: .character("A"))
        XCTAssertFalse(textDocumentProxy.hasCalled(\.insertTextRef))
        handler.tryReinsertAutocompleteRemovedSpace(after: .release, on: .character(","))
        XCTAssertTrue(textDocumentProxy.hasCalled(\.insertTextRef))

        textDocumentProxy.resetCalls()
    }
}

private class TestClass: KeyboardAction.StandardHandler, Mockable {

    var mock = Mock()

    lazy var handleGestureOnActionRef = MockReference(handle as (Gesture, KeyboardAction) -> Void)
    lazy var tryApplyAutocorrectSuggestionRef = MockReference(tryApplyAutocorrectSuggestion)
    lazy var tryChangeKeyboardTypeRef = MockReference(tryChangeKeyboardType)
    lazy var tryEndSentenceRef = MockReference(tryEndSentence)
    lazy var tryReinsertAutocompleteRemovedSpaceRef = MockReference(tryReinsertAutocompleteRemovedSpace)
    lazy var tryRemoveAutocompleteInsertedSpaceRef = MockReference(tryRemoveAutocompleteInsertedSpace)

    override func handle(_ gesture: Gesture, on action: KeyboardAction) {
        super.handle(gesture, on: action)
        call(handleGestureOnActionRef, args: (gesture, action))
    }

    override func tryApplyAutocorrectSuggestion(before gesture: Gesture, on action: KeyboardAction) {
        super.tryApplyAutocorrectSuggestion(before: gesture, on: action)
        call(tryApplyAutocorrectSuggestionRef, args: (gesture, action))
    }
    
    override func tryChangeKeyboardType(after gesture: Gesture, on action: KeyboardAction) {
        super.tryChangeKeyboardType(after: gesture, on: action)
        call(tryChangeKeyboardTypeRef, args: (gesture, action))
    }

    override func tryEndSentence(after gesture: Gesture, on action: KeyboardAction) {
        super.tryEndSentence(after: gesture, on: action)
        call(tryEndSentenceRef, args: (gesture, action))
    }

    override func tryReinsertAutocompleteRemovedSpace(after gesture: Gesture, on action: KeyboardAction) {
        super.tryReinsertAutocompleteRemovedSpace(after: gesture, on: action)
        call(tryReinsertAutocompleteRemovedSpaceRef, args: (gesture, action))
    }

    override func tryRemoveAutocompleteInsertedSpace(before gesture: Gesture, on action: KeyboardAction) {
        super.tryRemoveAutocompleteInsertedSpace(before: gesture, on: action)
        call(tryRemoveAutocompleteInsertedSpaceRef, args: (gesture, action))
    }
}
#endif
