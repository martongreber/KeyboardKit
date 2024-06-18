# AI Support

This article describes the KeyboardKit AI support capabilities.

@Metadata {

    @PageImage(
        purpose: card,
        source: "Page",
        alt: "Page icon"
    )

    @PageColor(blue)
}

Apple's native keyboard APIs lack many features that are often needed by AI-based keyboards.

For instance, AI-based keyboards may need to read the entire document to perform tasks like spellchecking and proofreading, and also let users type within the keyboard to type prompts or intents.

Keyboard extensions have little native support for this. The text document proxy will not return all the text within the document, and may cancel at any time. You also can't type in text fields within the keyboard, since text is always sent to the main app.

👑 [KeyboardKit Pro][Pro] unlocks these capabilities to make it possible to read the full document and type in a text field within the keyboard.



## 👑 KeyboardKit Pro

### Full Document Reader

[KeyboardKit Pro][Pro] unlocks ways to read **all** text from a text field, using the ``UIKit/UITextDocumentProxy/fullDocumentContext(config:)`` proxy extensions that will read the full document content instead of just returning the text closest to the input cursor.

By reading the full text, you can pass in more information to your AI model or ChatGPT-powered functionality, and make your AI-based features a lot more capable.

Read more in the <doc:Proxy-Article> article.


### Text Input Support

[KeyboardKit Pro][Pro] unlocks ways to let you type within a keyboard extension, by routing text input from the main app to text fields within the keyboard extension.

KeyboardKit Pro has a ``KeyboardTextField`` that handles text routing automatically, by registering and unregistering itself as the ``KeyboardInputViewController/textDocumentProxy`` when it gets and loses focus. There is also a multi-line ``KeyboardTextView``.

This lets you provide AI-based features that require user input in your keyboard, such as generating custom images with DALL·E, asking questions to an AI like ChatGPT, etc.

Read more in the <doc:Text-Input-Article> article.



[Pro]: https://github.com/KeyboardKit/KeyboardKitPro
