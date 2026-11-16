local function getClickedSuggestion(p2, callback, p3, p4, p5)
	if p2 == nil or p2.prefix ~= p3 then
		return nil
	end

	local v5 = callback(p2)

	if v5 == nil then
		return nil
	end

	local entry = v5.entries[p5]

	if entry == nil or entry.searchQuery ~= p4 then
		return nil
	end

	return { entries = v5.entries, entry = entry }
end

return getClickedSuggestion
