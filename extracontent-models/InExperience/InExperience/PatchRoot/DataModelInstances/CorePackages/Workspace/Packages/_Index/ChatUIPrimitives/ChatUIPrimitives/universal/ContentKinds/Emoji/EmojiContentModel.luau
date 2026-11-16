require(script.Parent.Parent.Parent.Types)
require(script.Parent.EmojiTypes)

local EmojiContentModel = {}

function EmojiContentModel.detailFromEmoji(emojiId: string, unicode: string?, name: string?)
	local fallbackText

	if not (unicode == nil or unicode == "") then
		fallbackText = unicode
	end

	return { fallbackText = fallbackText, emojiId = emojiId, unicode = unicode, name = name }
end

function EmojiContentModel.fromEmoji(p: string, p2: string?, p3: string?)
	return {
		emoji = EmojiContentModel.detailFromEmoji(p, p2, p3)
	}
end

function EmojiContentModel.draftFromEmoji(emojiId: string, unicode: string)
	return {
		emoji = { emojiId = emojiId, unicode = unicode }
	}
end

function EmojiContentModel.getDisplayText(data)
	if data.unicode ~= nil and data.unicode ~= "" then
		return data.unicode
	end

	if data.fallbackText == nil or data.fallbackText == "" then
		return data.name or ""
	end

	return data.fallbackText
end

function EmojiContentModel.getDetail(p)
	return p.emoji
end

function EmojiContentModel.getDraft(p)
	return p.emoji
end

function EmojiContentModel.fromDraft(p)
	local draft = EmojiContentModel.getDraft(p)

	if draft == nil then
		return nil
	end

	return EmojiContentModel.fromEmoji(draft.emojiId, draft.unicode, nil)
end

return EmojiContentModel
