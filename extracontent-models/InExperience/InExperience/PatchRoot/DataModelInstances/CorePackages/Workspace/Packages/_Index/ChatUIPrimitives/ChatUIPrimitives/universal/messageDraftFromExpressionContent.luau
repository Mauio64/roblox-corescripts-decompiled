require(script:FindFirstAncestor("ChatUIPrimitives").UniversalMessage.Types)
local MessageDraftModel = require(script.Parent.MessageDraftModel)
require(script.Parent.Types)

local function fallbackPlainText(data) -- 1 equivalent call inferred from this helper
	if data.altText == nil then
		if data.kind == "plain-text" and data.text ~= "" then
			return data.text
		end

		return nil
	else
		return if data.altText ~= "" then data.altText else nil
	end
end

local function messageDraftFromExpressionContent(data)
	if data.kind == "preset" then
		local presetId = data.presetId
		local text = data.text

		if presetId == "" or text == nil or text == "" then
			return nil
		end

		return MessageDraftModel.fromPreset(presetId, text)
	else
		if data.kind == "emoji" then
			local unicode = data.unicode

			if data.emojiId ~= "" and unicode ~= nil and unicode ~= "" then
				return MessageDraftModel.fromEmoji(data.emojiId, unicode)
			end
		end

		local v = fallbackPlainText(data) -- inferred equivalent call

		if v == nil then
			return nil
		end

		return MessageDraftModel.fromPlainText(v)
	end
end

return messageDraftFromExpressionContent
