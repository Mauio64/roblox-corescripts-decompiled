local parent = script.Parent.Parent
require(parent.LuauPolyfill)

local GraphQL = require(parent.GraphQL)

local GraphQLError = GraphQL.GraphQLError

local versionInfo = GraphQL.versionInfo

require(script.Parent.types)

local function createGraphQLError(message: string, data)
	if versionInfo.major >= 17 then
		return GraphQLError.new(message, data)
	end

	local new = GraphQLError.new
	local nodes

	if typeof(data) == "table" then
		nodes = data.nodes
	end

	local source

	if typeof(data) == "table" then
		source = data.source
	end

	local positions

	if typeof(data) == "table" then
		positions = data.positions
	end

	local path

	if typeof(data) == "table" then
		path = data.path
	end

	local originalError

	if typeof(data) == "table" then
		originalError = data.originalError
	end

	local v

	if typeof(data) == "table" then
		v = data.extensions
	end

	return new(message, nodes, source, positions, path, originalError, v)
end

return {
	["createGraphQLError"] = createGraphQLError,
	relocatedError = function(originalError, path)
		local message = originalError.message
		local v = {
			nodes = originalError.nodes,
			source = originalError.source,
			positions = originalError.positions,
			path = 0,
			originalError = 0,
			extensions = 0
		}

		if path == nil then
			path = originalError.path
		end

		v.path = path

		v.originalError = originalError
		v.extensions = originalError.extensions
		return createGraphQLError(message, v)
	end
}
