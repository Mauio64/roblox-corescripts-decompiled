local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")
local Logger = require(TextChannelWindow.Logger)

local FFlagExpChatTextChannelWindowExpressionTrayEmoji = require(TextChannelWindow.Flags.FFlagExpChatTextChannelWindowExpressionTrayEmoji)
local sendTextToChannel = require(TextChannelWindow.sendTextToChannel)

local function sendEmojiExpression(p: string?, p2, flag: boolean)
	if not FFlagExpChatTextChannelWindowExpressionTrayEmoji or not flag or p == nil or p == "" then
		return false
	end

	if p2 ~= nil then
		return sendTextToChannel(p2, p)
	end

	Logger:warning("Emoji not sent: no target channel")
	return false
end

return sendEmojiExpression
