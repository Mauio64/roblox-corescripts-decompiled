local function asTable(p2)
	if type(p2) == "table" then
		return p2
	end

	return nil
end

local function decodeEmoji(p2)
	if type(p2) ~= "table" then
		p2 = nil
	end

	if p2 == nil then
		return nil
	end

	local id = p2.id

	if type(id) ~= "string" or id == "" then
		return nil
	end

	local name = p2.name

	if type(name) == "string" and name ~= "" then
		return { id = id, name = name }
	end

	return nil
end

local function decodeEmojiSets(p2)
	local result = {}

	if type(p2) ~= "table" then
		p2 = nil
	end

	local emoji_sets

	if p2 ~= nil then
		emoji_sets = p2.emoji_sets

		if type(emoji_sets) ~= "table" then
			emoji_sets = nil
		end
	end

	if emoji_sets == nil then
		return result
	end

	for k, emoji_set in emoji_sets do
		if type(emoji_set) ~= "table" then
			emoji_set = nil
		end

		local emoji_page

		if emoji_set ~= nil then
			emoji_page = emoji_set.emoji_page

			if type(emoji_page) ~= "table" then
				emoji_page = nil
			end
		end

		if emoji_page == nil then
			continue
		end

		for k2, v5 in emoji_page do
			local v6 = decodeEmoji(v5)

			if v6 ~= nil then
				table.insert(result, v6)
			end
		end
	end

	return result
end

return decodeEmojiSets
