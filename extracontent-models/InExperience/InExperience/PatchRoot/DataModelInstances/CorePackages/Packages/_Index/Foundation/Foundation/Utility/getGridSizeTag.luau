local Foundation = script:FindFirstAncestor("Foundation")
require(Foundation.Components.Types)

local function getGridSizeTag(value)
	if typeof(value) == "number" then
		return `col-{value}`
	end

	local v = {}

	for k, v2 in value do
		if typeof(v2) == "number" then
			table.insert(v, `{k}-col-{v2}`)
		end
	end

	return table.concat(v, " ")
end

return getGridSizeTag
