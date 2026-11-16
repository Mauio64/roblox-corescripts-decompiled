local textLabel = Instance.new("TextLabel")
textLabel.RichText = true
local function getContentText(text) -- 1 equivalent call inferred from this helper
	textLabel.Text = text
	return textLabel.ContentText
end

local function isWhitespaceOnly(text): boolean
	return string.find(getContentText(text), "%S") == nil -- inferred equivalent call
end

return isWhitespaceOnly
