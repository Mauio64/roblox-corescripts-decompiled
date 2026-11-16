return function(p)
	local v = {}

	for i = 1, p.n do
		if type(p[i]) == "string" then
			table.insert(v, "\"" .. p[i] .. "\"")
		else
			table.insert(v, (tostring(p[i])))
		end
	end

	return "{" .. table.concat(v, ", ") .. "}"
end
