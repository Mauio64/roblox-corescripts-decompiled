local InlineRichText = script:FindFirstAncestor("InlineRichText")

require(InlineRichText.Types)

return function(p1, _) -- line: 5
	return {{
		text = p1.text,
		engineTags = {}
	}}
end
