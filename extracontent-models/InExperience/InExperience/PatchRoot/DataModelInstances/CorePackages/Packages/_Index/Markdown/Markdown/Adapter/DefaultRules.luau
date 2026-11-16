local parent = script:FindFirstAncestor("Markdown").Parent
require(script.Parent.AdapterTypes)
require(parent.CommonMark)
local Rules = require(script.Parent.Rules)

local function literalOf(p)
	return p.literal or ""
end

local function softLineBreak(_): string
	return "\n"
end

return {
	register = function(object)
		object:block("Paragraph", { as = "PARAGRAPH" })
		object:block("Heading", {
			as = "HEADING",
			attributes = function(p)
				return { depth = p.level }
			end
		})

		object:block("ThematicBreak", Rules.divider())
		object:block("FencedCodeBlock", Rules.codeBlock())
		object:block("IndentedCodeBlock", Rules.codeBlock())
		object:block("HtmlBlock", Rules.htmlBlock())
		local list = Rules.list()
		object:block("BulletList", list)
		object:block("OrderedList", list)
		object:block("BlockQuote", Rules.quote())
		object:block("LinkReferenceDefinition", "drop")

		object:inline("Text", { text = literalOf })
		object:inline("HtmlInline", { text = literalOf })
		object:inline("SoftLineBreak", { text = softLineBreak })
		object:inline("HardLineBreak", Rules.hardLineBreak())
		object:inline("Code", Rules.code())
		object:inline("Link", Rules.link())
		object:inline("Image", Rules.image())
		object:inline("Emphasis", { style = "ITALIC" })
		object:inline("StrongEmphasis", { style = "BOLD_2" })
		object:inline("Strikethrough", { style = "STRIKE" })
	end
}
