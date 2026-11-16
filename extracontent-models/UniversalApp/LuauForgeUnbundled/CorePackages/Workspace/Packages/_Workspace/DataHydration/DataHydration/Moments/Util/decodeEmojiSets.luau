require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")

local function decodeEmoji(data)
	if type(data) ~= "table" or (type(data.id) ~= "string" or data.id == "") then
		return nil
	end

	if type(data.name) ~= "string" or data.name == "" then
		return nil
	end

	local v5 = { id = data.id, name = data.name, assetSource = 0, unicode = 0 }
	local v6 = if type(data.asset_source) == "string" then data.asset_source else nil
	v5.assetSource = v6
	local v7 = if type(data.unicode) == "string" then data.unicode else nil
	v5.unicode = v7
	return v5
end

local function decodeEmojiSet(emoji_set)
	if
		type(emoji_set) ~= "table"
		or (type(emoji_set.emoji_set_id) ~= "string" or emoji_set.emoji_set_id == "")
	then
		return nil
	end

	if type(emoji_set.emoji_set_name) ~= "string" or emoji_set.emoji_set_name == "" then
		return nil
	end

	local v5 = {}

	if type(emoji_set.emoji_page) == "table" then
		for k, v6 in emoji_set.emoji_page do
			local v7 = decodeEmoji(v6)

			if v7 ~= nil then
				table.insert(v5, v7)
			end
		end
	end

	local v6 = {
		emojiSetId = emoji_set.emoji_set_id,
		emojiSetName = emoji_set.emoji_set_name,
		emojiPage = v5,
		nextCursor = 0,
		previousCursor = 0
	}

	local v7 = if type(emoji_set.next_cursor) == "string" then emoji_set.next_cursor else nil
	v6.nextCursor = v7
	local v8 = if type(emoji_set.previous_cursor) == "string" then emoji_set.previous_cursor else nil
	v6.previousCursor = v8
	return v6
end

return {
	decodeGetEmojiSetsResponse = function(data)
		local v5 = {}

		if type(data) == "table" and type(data.emoji_sets) == "table" then
			for k, emoji_set in data.emoji_sets do
				local v6 = decodeEmojiSet(emoji_set)

				if v6 ~= nil then
					table.insert(v5, v6)
				end
			end
		end

		local v7 = if type(data) == "table" and type(data.next_cursor) == "string" then data.next_cursor else nil

		local v8 = if type(data) == "table" and type(data.previous_cursor) == "string" then data.previous_cursor else nil
		return { emojiSets = v5, nextCursor = v7, previousCursor = v8 }
	end,
	flattenEmojis = function(p2)
		if p2 == nil then
			return {}
		end

		local result = {}

		for k, emojiSet in p2.emojiSets do
			for k2, v5 in emojiSet.emojiPage do
				table.insert(result, v5)
			end
		end

		return result
	end
}
