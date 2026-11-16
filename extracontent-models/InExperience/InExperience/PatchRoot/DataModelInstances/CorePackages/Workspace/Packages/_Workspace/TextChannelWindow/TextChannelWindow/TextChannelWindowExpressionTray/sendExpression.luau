local sendEmojiExpression = require(script.Parent.sendEmojiExpression)
local sendPresetExpression = require(script.Parent.sendPresetExpression)

local function sendExpression(data, p, flag: boolean)
	if data.kind == "preset" then
		return sendPresetExpression(data.presetId, p)
	end

	if data.kind == "emoji" then
		return sendEmojiExpression(data.unicode, p, flag)
	end

	return false
end

return sendExpression
