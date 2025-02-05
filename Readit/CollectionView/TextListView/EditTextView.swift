            VStack {
                Text("Edit Text")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $editingTextContent)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Button(action: {
                    if !editingTextContent.isEmpty {
                        viewModel.editText(withId: textItem?.id ?? " ", newText: editingTextContent)
                        editingTextContent = ""
                        showEditTextSheet = false
                    }
                }) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(editingTextContent.isEmpty)
                
                Spacer()
            }
