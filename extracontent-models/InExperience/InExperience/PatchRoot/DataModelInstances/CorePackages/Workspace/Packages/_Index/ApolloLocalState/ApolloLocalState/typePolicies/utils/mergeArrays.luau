local parent = script:FindFirstAncestor("ApolloLocalState").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local function mergeArrays(_, options, options2)
	local v = options or {}
	local selected = options2 or {}

	if #selected == 0 then
		return v
	end

	if #v == 0 then
		return selected
	end

	return Array.concat(table.clone(v), selected)
end

return mergeArrays
