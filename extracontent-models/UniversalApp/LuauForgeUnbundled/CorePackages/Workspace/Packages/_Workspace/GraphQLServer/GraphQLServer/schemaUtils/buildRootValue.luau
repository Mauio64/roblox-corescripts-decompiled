local object = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Object

local function buildRootValue(p2)
	local query = p2.Query or {}
	local mutation = p2.Mutation or {}
	return (object.assign({}, query, mutation))
end

return buildRootValue
