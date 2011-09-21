module UISamples

  class SyntaxHighlightedTextArea < BaseAction
    description "Syntax-highlighted text area powered by CodeMirror"
  end
end

Jenkins::Plugin.instance.register_extension(UISamples::SyntaxHighlightedTextArea.new)
