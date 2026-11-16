local function matchesQuery(p2, ...): boolean
	for k, v5 in { ... } do
		if string.find(string.lower(v5), p2, 1, true) ~= nil then
			return true
		end
	end

	return false
end

return matchesQuery
