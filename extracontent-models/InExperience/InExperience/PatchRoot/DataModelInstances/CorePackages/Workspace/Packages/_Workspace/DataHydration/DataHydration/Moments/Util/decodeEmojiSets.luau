local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)

local function decodeEmoji(data)
	if type(data) ~= "table" or (type(data.id) ~= "string" or data.id == "") then
		return nil
	end

	if type(data.name) ~= "string" or data.name == "" then
		return nil
	end

	local v = { id = data.id, name = data.name, assetSource = 0, unicode = 0 }
	local assetSource

	if type(data.asset_source) == "string" then
		assetSource = data.asset_source
	end

	v.assetSource = assetSource
	local unicode

	if type(data.unicode) == "string" then
		unicode = data.unicode
	end

	v.unicode = unicode
	return v
end

local function decodeEmojiSet(emoji_set)
	if type(emoji_set) ~= "table" or (type(emoji_set.emoji_set_id) ~= "string" or emoji_set.emoji_set_id == "") then
		return nil
	end

	if type(emoji_set.emoji_set_name) ~= "string" or emoji_set.emoji_set_name == "" then
		return nil
	end

	local emojiPage = {}

	if type(emoji_set.emoji_page) == "table" then
		for _, v in emoji_set.emoji_page do
			local v2 = decodeEmoji(v)

			if v2 ~= nil then
				table.insert(emojiPage, v2)
			end
		end
	end

	local v = {
		emojiSetId = emoji_set.emoji_set_id,
		emojiSetName = emoji_set.emoji_set_name,
		emojiPage = emojiPage,
		nextCursor = 0,
		previousCursor = 0
	}
	local nextCursor

	if type(emoji_set.next_cursor) == "string" then
		nextCursor = emoji_set.next_cursor
	end

	v.nextCursor = nextCursor
	local previousCursor

	if type(emoji_set.previous_cursor) == "string" then
		previousCursor = emoji_set.previous_cursor
	end

	v.previousCursor = previousCursor
	return v
end

local DecodeEmojiSets = {}

function DecodeEmojiSets.decodeGetEmojiSetsResponse(data)
	local emojiSets = {}

	if type(data) == "table" and type(data.emoji_sets) == "table" then
		for _, emoji_set in data.emoji_sets do
			local v = decodeEmojiSet(emoji_set)

			if v ~= nil then
				table.insert(emojiSets, v)
			end
		end
	end

	local nextCursor

	if type(data) == "table" and type(data.next_cursor) == "string" then
		nextCursor = data.next_cursor
	end

	local previousCursor

	if type(data) == "table" and type(data.previous_cursor) == "string" then
		previousCursor = data.previous_cursor
	end

	return { emojiSets = emojiSets, nextCursor = nextCursor, previousCursor = previousCursor }
end

function DecodeEmojiSets.flattenEmojis(p)
	if p == nil then
		return {}
	end

	local result = {}

	for _, emojiSet in p.emojiSets do
		for _, v in emojiSet.emojiPage do
			table.insert(result, v)
		end
	end

	return result
end

return DecodeEmojiSets
