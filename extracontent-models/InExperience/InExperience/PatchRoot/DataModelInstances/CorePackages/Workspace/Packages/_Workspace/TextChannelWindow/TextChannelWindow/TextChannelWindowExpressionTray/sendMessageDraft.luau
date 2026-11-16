local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")
local parent = TextChannelWindow.Parent
local MessageDraftModel = require(parent.ChatUIPrimitives.MessageDraftModel)
require(parent.ChatUIPrimitives.MessageComposer)
local Logger = require(TextChannelWindow.Logger)
local sendEmojiExpression = require(script.Parent.sendEmojiExpression)
local sendPresetExpression = require(script.Parent.sendPresetExpression)

local function sendMessageDraft(p, p2, flag: boolean, callback)
	local preset = MessageDraftModel.toPreset(p)

	if preset ~= nil then
		sendPresetExpression(preset.presetId, p2)
		return
	end

	local emoji = MessageDraftModel.toEmoji(p)

	if emoji ~= nil then
		sendEmojiExpression(emoji.unicode, p2, flag)
		return
	end

	local plainText = MessageDraftModel.toPlainText(p)

	if plainText == nil then
		Logger:warning("Draft not sent: unsupported content kind")
	else
		callback(plainText)
	end
end

return sendMessageDraft
