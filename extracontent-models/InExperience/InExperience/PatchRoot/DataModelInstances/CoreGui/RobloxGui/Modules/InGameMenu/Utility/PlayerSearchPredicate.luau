local function PlayerSearchPredicate(value, value2, p): boolean
	if value == nil or value == "" then
		return true
	end

	if p then
		local v = utf8.nfdnormalize(p)
		local v2 = utf8.nfdnormalize(value)

		if string.find(v:lower(), v2:lower(), 1, true) ~= nil then
			return true
		end
	end

	return string.find(value2:lower(), value:lower(), 1, true) ~= nil
end

return PlayerSearchPredicate
