require(script.Parent.Parent.Types)
local PlainTextContentModel = require(script.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PresetContentModel = require(script.Parent.Parent.ContentKinds.Preset.PresetContentModel)
local EmojiContentModel = require(script.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)

local function contentFromDraft(p)
	local v = PlainTextContentModel.fromDraft(p)

	if v ~= nil then
		return v
	end

	local v2 = PresetContentModel.fromDraft(p)

	if v2 ~= nil then
		return v2
	end

	local v3 = EmojiContentModel.fromDraft(p)
	return if v3 ~= nil then v3 else nil
end

local function projectMessageEnvelope(data)
	local payload = data.payload

	if payload.kind == "message" then
		local message = payload.message
		return {
			id = data.stableId,
			sourceMessageId = message.id,
			sentAtUnixMilliseconds = message.sentAtUnixMilliseconds,
			author = message.author,
			contents = message.contents,
			repliesTo = message.repliesTo,
			deliveryState = nil
		}
	end

	local payload2 = data.payload
	local contents = {}

	for _, content in payload2.draft.contents do
		local v = PlainTextContentModel.fromDraft(content)

		if v == nil then
			v = PresetContentModel.fromDraft(content)

			if v == nil then
				v = EmojiContentModel.fromDraft(content)

				if v == nil then
					v = nil
				end
			end
		end

		if v ~= nil then
			table.insert(contents, v)
		end
	end

	return {
		id = data.stableId,
		sourceMessageId = nil,
		sentAtUnixMilliseconds = data.delivery.attemptedAtUnixMilliseconds,
		author = payload2.author,
		contents = contents,
		repliesTo = nil,
		deliveryState = data.delivery.state
	}
end

return projectMessageEnvelope
