local function prettyPrint(p1, p2) -- line: 3
	-- upvalues: prettyPrint (copy)
	local v4 = p2 or 0
	local t1 = {}

	if typeof(p1) == "table" then
		table.insert(t1, "{\n")

		for k, v in pairs(p1) do
			table.insert(t1, ("    "):rep(v4 + 1))
			table.insert(t1, (tostring(k)))
			table.insert(t1, " = ")
			table.insert(t1, prettyPrint(v, v4 + 1))
			table.insert(t1, "\n")
		end

		table.insert(t1, ("    "):rep(v4))
		table.insert(t1, "}")
	elseif typeof(p1) == "string" then
		table.insert(t1, string.format("%q", p1))
		table.insert(t1, " (string)")
	else
		table.insert(t1, (tostring(p1)))
		table.insert(t1, " (")
		table.insert(t1, (typeof(p1)))
		table.insert(t1, ")")
	end

	return table.concat(t1, "")
end

return prettyPrint
