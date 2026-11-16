local InlineRichText = script:FindFirstAncestor("InlineRichText")

require(InlineRichText.Types)

return function(p, _)
	return {
		{ text = p.text, engineTags = {} }
	}
end
