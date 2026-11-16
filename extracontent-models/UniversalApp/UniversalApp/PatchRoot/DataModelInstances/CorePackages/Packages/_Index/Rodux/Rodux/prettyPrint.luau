local function prettyPrint(item, count)
	local v = count or 0
	local v2 = {}

	if typeof(item) == "table" then
		table.insert(v2, "{\n")

		for k, item2 in pairs(item) do
			table.insert(v2, ("    "):rep(v + 1))
			table.insert(v2, (tostring(k)))
			table.insert(v2, " = ")

			table.insert(v2, prettyPrint(item2, v + 1))
			table.insert(v2, "\n")
		end

		table.insert(v2, ("    "):rep(v))
		table.insert(v2, "}")
	elseif typeof(item) == "string" then
		table.insert(v2, string.format("%q", item))
		table.insert(v2, " (string)")
	else
		table.insert(v2, (tostring(item)))
		table.insert(v2, " (")
		table.insert(v2, (typeof(item)))
		table.insert(v2, ")")
	end

	return table.concat(v2, "")
end

return prettyPrint
