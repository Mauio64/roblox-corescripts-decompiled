local function matchesQuery(p: string, ...): boolean
	for _, v in { ... } do
		if string.find(string.lower(v), p, 1, true) ~= nil then
			return true
		end
	end

	return false
end

return matchesQuery
