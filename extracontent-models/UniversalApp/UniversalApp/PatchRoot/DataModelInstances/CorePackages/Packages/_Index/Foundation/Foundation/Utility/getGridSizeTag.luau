local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local function getGridSizeTag(p1) -- line: 6
	if typeof(p1) == "number" then
		return `col-{ p1 }`
	end

	local t1 = {}

	for v5, v6 in p1 do
		if typeof(v6) == "number" then
			table.insert(t1, `{ v5 }-col-{ v6 }`)
		end
	end

	return table.concat(t1, " ")
end

return getGridSizeTag
