local function populateListFromIds(p1, p2) -- line: 5
	-- upvalues: populateListFromIds (copy)
	local t1 = {}

	for _, v in ipairs(p1) do
		if type(v) == "table" then
			table.insert(t1, populateListFromIds(v, p2))
		else
			table.insert(t1, p2[v])
		end
	end

	return t1
end

return populateListFromIds
