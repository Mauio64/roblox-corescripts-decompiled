local HttpService = game:GetService("HttpService")

require(script.Parent.Types)
local PlainTextContentModel = require(script.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PresetContentModel = require(script.Parent.ContentKinds.Preset.PresetContentModel)
local EmojiContentModel = require(script.Parent.ContentKinds.Emoji.EmojiContentModel)

local function idFrom(p) -- 3 equivalent calls inferred from this helper
	return p and p.id or HttpService:GenerateGUID(false)
end

local MessageModel = {
	fromPlainText = function(p: string, p2)
		local sentAtUnixMilliseconds = p2 and p2.sentAtUnixMilliseconds or DateTime.now().UnixTimestampMillis
		local v = {
			id = idFrom(p2), -- inferred equivalent call
			sentAtUnixMilliseconds = sentAtUnixMilliseconds,
			author = 0,
			contents = 0
		}
		local author

		if p2 then
			author = p2.author
		end

		v.author = author
		v.contents = { PlainTextContentModel.fromText(p) }
		return v
	end,
	fromPreset = function(p: string, p2: string, data)
		local sentAtUnixMilliseconds = data and data.sentAtUnixMilliseconds or DateTime.now().UnixTimestampMillis
		local presetVersion

		if data then
			presetVersion = data.presetVersion
		end

		local v = {
			id = idFrom(data), -- inferred equivalent call
			sentAtUnixMilliseconds = sentAtUnixMilliseconds,
			author = 0,
			contents = 0
		}
		local author

		if data then
			author = data.author
		end

		v.author = author
		v.contents = { PresetContentModel.fromPreset(p, p2, presetVersion) }
		return v
	end,
	fromEmoji = function(p: string, p2: string?, data)
		local sentAtUnixMilliseconds = data and data.sentAtUnixMilliseconds or DateTime.now().UnixTimestampMillis
		local v = {
			id = idFrom(data), -- inferred equivalent call
			sentAtUnixMilliseconds = sentAtUnixMilliseconds,
			author = 0,
			contents = 0
		}
		local author

		if data then
			author = data.author
		end

		v.author = author

		local fromEmoji = EmojiContentModel.fromEmoji
		local v2

		if data then
			v2 = data.name
		end

		v.contents = { fromEmoji(p, p2, v2) }
		return v
	end
}

local function previewText(p)
	local content = p.contents[1]

	if content == nil then
		return ""
	end

	local detail = PlainTextContentModel.getDetail(content)

	if detail ~= nil then
		return detail.fallbackText
	end

	local detail2 = PresetContentModel.getDetail(content)

	if detail2 ~= nil then
		return detail2.fallbackText
	end

	local detail3 = EmojiContentModel.getDetail(content)

	if detail3 == nil then
		return ""
	end

	return EmojiContentModel.getDisplayText(detail3)
end

function MessageModel.replyReference(p, label: string?)
	return {
		id = p.id,
		preview = { author = p.author, fallbackText = previewText(p) },
		label = label
	}
end

return MessageModel
