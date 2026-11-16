local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)
local FormattingTag = {}

function FormattingTag.new(tagName: string)
	local formattingTag = CommonMark.Node.CustomNode.new("FormattingTag")
	formattingTag.tagName = tagName
	return formattingTag
end

function FormattingTag.text(literal: string)
	local formattingTagText = CommonMark.Node.CustomNode.new("FormattingTagText")
	formattingTagText.literal = literal
	return formattingTagText
end

FormattingTag.TAGS = table.freeze({
	["<b>"] = table.freeze({ name = "b", closing = false }),
	["</b>"] = table.freeze({ name = "b", closing = true }),
	["<i>"] = table.freeze({ name = "i", closing = false }),
	["</i>"] = table.freeze({ name = "i", closing = true }),
	["<u>"] = table.freeze({ name = "u", closing = false }),
	["</u>"] = table.freeze({ name = "u", closing = true }),
	["<s>"] = table.freeze({ name = "s", closing = false }),
	["</s>"] = table.freeze({ name = "s", closing = true })
})
return FormattingTag
