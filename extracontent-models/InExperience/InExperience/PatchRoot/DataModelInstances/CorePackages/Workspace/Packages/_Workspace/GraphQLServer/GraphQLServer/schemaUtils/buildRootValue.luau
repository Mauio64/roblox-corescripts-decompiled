local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local function buildRootValue(p)
	local query = p.Query or {}
	local mutation = p.Mutation or {}
	return (Object.assign({}, query, mutation))
end

return buildRootValue
