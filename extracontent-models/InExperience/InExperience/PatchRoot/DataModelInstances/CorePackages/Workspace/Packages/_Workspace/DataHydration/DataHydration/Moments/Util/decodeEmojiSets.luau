local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.MomentsTypes)

local function decodeEmoji(p1) -- line: 11
	if type(p1) ~= "table" then
		return nil
	end

	if type(p1.id) ~= "string" or p1.id == "" then
		return nil
	end

	if type(p1.name) ~= "string" or p1.name == "" then
		return nil
	end

	return {
		id = p1.id,
		name = p1.name,
		assetSource = if type(p1.asset_source) ~= "string" then nil else p1.asset_source,
		unicode = if type(p1.unicode) ~= "string" then nil else p1.unicode
	}
end
local function decodeEmojiSet(p2) -- line: 30
	-- upvalues: decodeEmoji (copy)
	if type(p2) ~= "table" then
		return nil
	end

	if type(p2.emoji_set_id) ~= "string" or p2.emoji_set_id == "" then
		return nil
	end

	if type(p2.emoji_set_name) ~= "string" or p2.emoji_set_name == "" then
		return nil
	end

	local t1 = {}

	if type(p2.emoji_page) == "table" then
		for _, v8 in p2.emoji_page do
			local v9 = decodeEmoji(v8)

			if v9 ~= nil then
				table.insert(t1, v9)
			end
		end
	end

	return {
		emojiSetId = p2.emoji_set_id,
		emojiSetName = p2.emoji_set_name,
		emojiPage = t1,
		nextCursor = if type(p2.next_cursor) ~= "string" then nil else p2.next_cursor,
		previousCursor = if type(p2.previous_cursor) ~= "string" then nil else p2.previous_cursor
	}
end

return {
	decodeGetEmojiSetsResponse = function(p3) -- line: 60
		-- upvalues: decodeEmojiSet (copy)
		local t2 = {}

		if type(p3) == "table" and type(p3.emoji_sets) == "table" then
			for _, v13 in p3.emoji_sets do
				local v14 = decodeEmojiSet(v13)

				if v14 ~= nil then
					table.insert(t2, v14)
				end
			end
		end

		return {
			emojiSets = t2,
			nextCursor = if type(p3) ~= "table" or type(p3.next_cursor) ~= "string" then nil else p3.next_cursor,
			previousCursor = if type(p3) ~= "table" or type(p3.previous_cursor) ~= "string" then nil else p3.previous_cursor
		}
	end,
	flattenEmojis = function(p4) -- line: 82
		if p4 == nil then
			return {}
		end

		local t3 = {}

		for _, v18 in p4.emojiSets do
			for _, v20 in v18.emojiPage do
				table.insert(t3, v20)
			end
		end

		return t3
	end
}
