return function(p1) -- line: 1
	local t1 = {}

	for i = 1, p1.n do
		if type(p1[i]) == "string" then
			table.insert(t1, "\"" .. p1[i] .. "\"")
		else
			table.insert(t1, (tostring(p1[i])))
		end
	end

	return "{" .. table.concat(t1, ", ") .. "}"
end
