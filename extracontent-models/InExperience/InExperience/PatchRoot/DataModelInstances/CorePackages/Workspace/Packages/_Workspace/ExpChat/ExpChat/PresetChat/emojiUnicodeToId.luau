local function emojiUnicodeToId(p: string)
	local v = {}

	for _, v2 in utf8.codes(p) do
		table.insert(v, string.format("%x", v2))
	end

	return table.concat(v, "-")
end

return emojiUnicodeToId
