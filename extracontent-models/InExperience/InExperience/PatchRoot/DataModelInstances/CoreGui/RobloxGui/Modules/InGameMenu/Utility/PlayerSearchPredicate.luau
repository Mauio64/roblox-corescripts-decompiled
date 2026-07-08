local function PlayerSearchPredicate(p1, p2, p3) -- line: 3
	if p1 == nil or p1 == "" then
		return true
	end

	if p3 then
		local v5 = utf8.nfdnormalize(p3)
		local v6 = utf8.nfdnormalize(p1)

		if string.find(v5:lower(), v6:lower(), 1, true) ~= nil then
			return true
		end
	end

	return string.find(p2:lower(), p1:lower(), 1, true) ~= nil
end

return PlayerSearchPredicate
