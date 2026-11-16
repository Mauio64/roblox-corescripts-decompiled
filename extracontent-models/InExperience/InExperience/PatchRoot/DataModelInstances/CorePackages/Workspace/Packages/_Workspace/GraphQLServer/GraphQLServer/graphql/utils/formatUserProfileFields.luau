local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local parent = GraphQLServer.Parent
local GraphqlToolsUtils = require(parent.GraphqlToolsUtils)
local LuauPolyfill = require(parent.LuauPolyfill)
local collectSubFields = GraphqlToolsUtils.collectSubFields
local UserProfileNestedFields = require(GraphQLServer.graphql.enums.UserProfileNestedFields)

return function(data, p)
	local v = p or collectSubFields
	local v2 = v(data.schema, data.fragments, data.variableValues, data.returnType, data.fieldNodes)

	local result = {}

	for _, v3 in v2 do
		local v4 = v3[1]

		if UserProfileNestedFields[v4] then
			local v5 = v(data.schema, data.fragments, data.variableValues, data.returnType, v2[v4])

			for _, v6 in v5 do
				local formatted = `{v4}.{v6[1]}`

				if formatted == nil or formatted == "id" or LuauPolyfill.String.endsWith(formatted, "__typename") then
					continue
				end

				table.insert(result, formatted)
			end
		elseif v4 ~= nil and v4 ~= "id" and not LuauPolyfill.String.endsWith(v4, "__typename") then
			table.insert(result, v4)
		end
	end

	return result
end
