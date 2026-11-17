local function asTable(p) -- 5 equivalent calls inferred from this helper
	return if type(p) == "table" then p else nil
end

local function decodeEmoji(p)
	p = asTable(p) -- inferred equivalent call

	if p == nil then
		return nil
	end

	local id = p.id

	if type(id) ~= "string" or id == "" then
		return nil
	end

	local name = p.name

	if type(name) == "string" and name ~= "" then
		return { id = id, name = name }
	end

	return nil
end

local function decodeEmojiSets(p)
	local result = {}
	p = asTable(p) -- inferred equivalent call
	local emoji_sets

	if p ~= nil then
		emoji_sets = p.emoji_sets
		emoji_sets = asTable(emoji_sets) -- inferred equivalent call
	end

	if emoji_sets == nil then
		return result
	end

	for _, emoji_set in emoji_sets do
		emoji_set = asTable(emoji_set) -- inferred equivalent call
		local emoji_page

		if emoji_set ~= nil then
			emoji_page = emoji_set.emoji_page
			emoji_page = asTable(emoji_page) -- inferred equivalent call
		end

		if emoji_page == nil then
			continue
		end

		for _, v in emoji_page do
			local v2 = decodeEmoji(v)

			if v2 ~= nil then
				table.insert(result, v2)
			end
		end
	end

	return result
end

return decodeEmojiSets
