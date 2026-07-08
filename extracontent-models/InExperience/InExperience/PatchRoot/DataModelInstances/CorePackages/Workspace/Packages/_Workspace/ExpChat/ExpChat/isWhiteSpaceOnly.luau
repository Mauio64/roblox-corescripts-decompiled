local TextLabel = Instance.new("TextLabel")

TextLabel.RichText = true

local function getContentText(p1) -- line: 5
	-- upvalues: TextLabel (copy)
	TextLabel.Text = p1

	return TextLabel.ContentText
end
local function isWhitespaceOnly(p2) -- line: 10
	-- upvalues: TextLabel (copy)
	TextLabel.Text = p2

	local ContentText = TextLabel.ContentText

	return string.find(ContentText, "%S") == nil
end

return isWhitespaceOnly
