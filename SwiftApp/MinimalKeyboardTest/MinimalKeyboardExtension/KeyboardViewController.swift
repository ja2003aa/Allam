import UIKit

class KeyboardViewController: UIInputViewController {
    
    // Define Arabic letters by rows as per the layout in the screenshot
    let arabicRows = [
        ["ض", "ص", "ث", "ق", "ف", "غ", "ع", "ه", "خ", "ح"],
        ["ج", "ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م"],
        ["ك", "ط", "ذ", "د", "ز", "ر", "و", "ء", "ظ", "ة"]
    ]
    
    // Extra functional keys in the last row
    let extraKeys = [ "مسافة", "عدد", "ابدأ الإنشاء"]
    
    // Preview area for generated poem and "Paste" button
    let previewTextView = UITextView()
    let pasteButton = UIButton(type: .system)
    
    // Dropdown view for line count selection
    let dropdownView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPreviewArea()
        setupKeyboardLayout()
        setupDropdownView()
        NSLog("Keyboard loaded")
        testPrintFunction()
    
        
    }

    
    // Setup preview area at the top for generated text
    func setupPreviewArea() {
        previewTextView.backgroundColor = .lightGray
        previewTextView.textColor = .black
        previewTextView.font = UIFont.systemFont(ofSize: 18)
        previewTextView.textAlignment = .right
        previewTextView.isEditable = false
        previewTextView.layer.cornerRadius = 5
        previewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        pasteButton.setTitle("Paste", for: .normal)
        pasteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        pasteButton.setTitleColor(.white, for: .normal)
        pasteButton.backgroundColor = .blue
        pasteButton.layer.cornerRadius = 5
        pasteButton.translatesAutoresizingMaskIntoConstraints = false
        pasteButton.addTarget(self, action: #selector(pasteText), for: .touchUpInside)
        
        let previewStack = UIStackView(arrangedSubviews: [previewTextView, pasteButton])
        previewStack.axis = .horizontal
        previewStack.spacing = 10
        previewStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(previewStack)

        NSLayoutConstraint.activate([
            previewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            previewStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            previewStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            previewTextView.heightAnchor.constraint(equalToConstant: 60),
            pasteButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // Setup main keyboard layout
    func setupKeyboardLayout() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        for (index, rowLetters) in arabicRows.enumerated() {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8
            
            for letter in rowLetters {
                let letterButton = createButton(withTitle: letter)
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(letterButton)
            }
            
            if index == 2 {
                let backButton = createButton(withTitle: "⌫", isFunctional: true)
                backButton.addTarget(self, action: #selector(backspaceTapped), for: .touchUpInside)
                rowStackView.addArrangedSubview(backButton)
            }
            
            mainStackView.addArrangedSubview(rowStackView)
        }
        
        let bottomRowStackView = UIStackView()
        bottomRowStackView.axis = .horizontal
        bottomRowStackView.alignment = .fill
        bottomRowStackView.distribution = .fillProportionally
        bottomRowStackView.spacing = 8
        
        for keyTitle in extraKeys {
            let extraKeyButton = createButton(withTitle: keyTitle, isFunctional: true)
            if keyTitle == "عدد" {
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showDropdown(_:)))
                extraKeyButton.addGestureRecognizer(longPressGesture)
            }
            extraKeyButton.addTarget(self, action: #selector(extraKeyTapped(_:)), for: .touchUpInside)
            bottomRowStackView.addArrangedSubview(extraKeyButton)
        }
        
        mainStackView.addArrangedSubview(bottomRowStackView)
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: previewTextView.bottomAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    // Setup dropdown for "عدد" key
    func setupDropdownView() {
        dropdownView.axis = .horizontal
        dropdownView.alignment = .center
        dropdownView.distribution = .fillEqually
        dropdownView.spacing = 5
        dropdownView.isHidden = true
        dropdownView.backgroundColor = .gray
        dropdownView.layer.cornerRadius = 5
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 1...7 {
            let item = UIButton(type: .system)
            item.setTitle("\(i)", for: .normal)
            item.setTitleColor(.white, for: .normal)
            item.addTarget(self, action: #selector(selectLineCount(_:)), for: .touchUpInside)
            dropdownView.addArrangedSubview(item)
        }
        
        view.addSubview(dropdownView)
        
        NSLayoutConstraint.activate([
            dropdownView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dropdownView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            dropdownView.widthAnchor.constraint(equalToConstant: 300),
            dropdownView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Show dropdown when long-pressed
    @objc func showDropdown(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            dropdownView.isHidden = false
        }
    }
    
    // Handle selection of line count
    @objc func selectLineCount(_ sender: UIButton) {
        guard let count = sender.title(for: .normal) else { return }
        let selectedText = "عدد الابيات \(count)"
        textDocumentProxy.insertText(selectedText) // Insert into main text input field
        dropdownView.isHidden = true
    }
    
    // "Paste" button functionality to move generated poem from preview to main input
    @objc func pasteText() {
        if let previewText = previewTextView.text {
            textDocumentProxy.setMarkedText(previewText, selectedRange: NSRange(location: 0, length: 0)) // Replace main input with the poem
            previewTextView.text = "" // Clear preview area after pasting
        }
    }
    
    // Hide dropdown when tapping outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dropdownView.isHidden = true
    }

    // Helper function to create buttons styled like the screenshot, with popping effect
    func createButton(withTitle title: String, isFunctional: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpOutside)
        
        if isFunctional {
            button.backgroundColor = .gray
        }
        
        return button
    }
    
    // Action for letter buttons
    @objc func letterTapped(_ sender: UIButton) {
        if let letter = sender.title(for: .normal) {
            textDocumentProxy.insertText(letter)
        }
    }
    
    // Action for backspace button
    @objc func backspaceTapped() {
        textDocumentProxy.deleteBackward()
    }
    
    // Action for functional keys
    @objc func extraKeyTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        switch title {
        case "مسافة":
            textDocumentProxy.insertText(" ")
        case "ابدأ الإنشاء":
            previewTextView.text = "Generating poetic text..."
            
            // Fetch the poem with a test prompt or actual text input from the user
            if let userPrompt = textDocumentProxy.documentContextBeforeInput, !userPrompt.isEmpty {
                        // Format the prompt for the backend
                        let formattedPrompt = "اكتب شعر موزون مقفي عن \"\(userPrompt)\""
                        
                        // Send the formatted prompt to the backend
                        fetchPoem(prompt: formattedPrompt) { poem in
                            DispatchQueue.main.async {
                                self.previewTextView.text = poem ?? "Failed to generate poem"
                            }
                        }
                    } else {
                        previewTextView.text = "Please enter a keyword and line count, e.g., 'اشتياق للام عدد الابيات 5'"
                    }
                    
           
        case "استخدام الصورة":
            previewTextView.text = "Image-based generation activated."
        default:
            break
        }
    }
    


    // Popping effect on button tap
    @objc func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    // Revert popping effect on button release
    @objc func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    func displayDebugMessage(_ message: String) {
        DispatchQueue.main.async {
            self.previewTextView.text = message
        }
    }
    func fetchPoem(prompt: String, completion: @escaping (String?) -> Void) {
        self.displayDebugMessage("Starting fetchPoem...")  // Explicitly use 'self' here
        let url = URL(string: "http://192.168.8.127:8080/generate_poem")!
        let json: [String: Any] = ["prompt": prompt]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        self.displayDebugMessage("Sending request to backend...")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }  // Capture self weakly to avoid retain cycles
            
            if let error = error {
                self.displayDebugMessage("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                self.displayDebugMessage("Received response from backend")
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let poem = jsonResponse["poem"] as? String {
                        self.displayDebugMessage("Poem received: \(poem)")
                        completion(poem)
                    } else {
                        self.displayDebugMessage("Parsing error or missing 'poem' key in response.")
                        completion(nil)
                    }
                } catch {
                    self.displayDebugMessage("JSON parse error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    func testPrintFunction() {
        print("Hello, this is a test print statement!")
    }
    

}
