local function populateDictionaryFromIds(p1, p2) -- line: 5
	-- upvalues: populateDictionaryFromIds (copy)
	local t1 = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t1[k] = populateDictionaryFromIds(v, p2)
		else
			t1[k] = p2[v]
		end
	end

	return t1
end

return populateDictionaryFromIds
