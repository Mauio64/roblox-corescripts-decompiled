require(script.Parent.Types)
local PlainTextContentModel = require(script.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PlainTextTypes = require(script.Parent.ContentKinds.PlainText.PlainTextTypes)
local PresetContentModel = require(script.Parent.ContentKinds.Preset.PresetContentModel)
local PresetTypes = require(script.Parent.ContentKinds.Preset.PresetTypes)
local EmojiTypes = require(script.Parent.ContentKinds.Emoji.EmojiTypes)
local EmojiContentModel = require(script.Parent.ContentKinds.Emoji.EmojiContentModel)

local MessageDraftModel = {}

function MessageDraftModel.fromPlainText(p: string)
	return {
		contents = { PlainTextContentModel.draftFromText(p) }
	}
end

function MessageDraftModel.fromPreset(p: string, p2: string)
	return {
		contents = { PresetContentModel.draftFromPreset(p, p2) }
	}
end

local function singleContentItem(p) -- 3 equivalent calls inferred from this helper
	if typeof(p) ~= "table" then
		return nil
	end

	local contents = p.contents

	if typeof(contents) ~= "table" or #contents ~= 1 then
		return nil
	end

	local content = contents[1]
	return if typeof(content) == "table" then content else nil
end

local function onlyField(items, p: string)
	local item = items[p]

	if item == nil then
		return nil
	end

	for k in items do
		if k ~= p then
			return nil
		end
	end

	return item
end

local function isValidPlainTextPayload(plainText): boolean -- 1 equivalent call inferred from this helper
	return PlainTextTypes.isValidDraft(plainText) == true
end

local function isValidPresetPayload(preset): boolean -- 1 equivalent call inferred from this helper
	return PresetTypes.isValidDraft(preset) == true
end

local function isValidEmojiPayload(emoji): boolean -- 1 equivalent call inferred from this helper
	return EmojiTypes.isValidDraft(emoji) == true
end

function MessageDraftModel.toPlainText(p)
	local content = singleContentItem(p) -- inferred equivalent call

	if content == nil then
		return nil
	end

	local plainText = content.plainText

	if plainText == nil then
		plainText = nil
	else
		for k in content do
			if k ~= "plainText" then
				plainText = nil
				break
			end
		end
	end

	if isValidPlainTextPayload(plainText) then -- inferred equivalent call
		return plainText.text
	end

	return nil
end

function MessageDraftModel.toPreset(p)
	local content = singleContentItem(p) -- inferred equivalent call

	if content == nil then
		return nil
	end

	local preset = content.preset

	if preset == nil then
		preset = nil
	else
		for k in content do
			if k ~= "preset" then
				preset = nil
				break
			end
		end
	end

	if isValidPresetPayload(preset) then -- inferred equivalent call
		return preset
	end

	return nil
end

function MessageDraftModel.fromEmoji(p: string, p2: string)
	return {
		contents = { EmojiContentModel.draftFromEmoji(p, p2) }
	}
end

function MessageDraftModel.toEmoji(p)
	local content = singleContentItem(p) -- inferred equivalent call

	if content == nil then
		return nil
	end

	local emoji = content.emoji

	if emoji == nil then
		emoji = nil
	else
		for k in content do
			if k ~= "emoji" then
				emoji = nil
				break
			end
		end
	end

	if isValidEmojiPayload(emoji) then -- inferred equivalent call
		return emoji
	end

	return nil
end

return MessageDraftModel
