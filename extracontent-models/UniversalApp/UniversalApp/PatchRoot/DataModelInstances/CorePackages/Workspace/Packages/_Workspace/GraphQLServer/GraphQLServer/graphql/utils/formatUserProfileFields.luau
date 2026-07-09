local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local GraphQLServerParent = GraphQLServer.Parent
local GraphqlToolsUtils = require(GraphQLServerParent.GraphqlToolsUtils)
local LuauPolyfill = require(GraphQLServerParent.LuauPolyfill)
local collectSubFields = GraphqlToolsUtils.collectSubFields
local UserProfileNestedFields = require(GraphQLServer.graphql.enums.UserProfileNestedFields)

return function(p1, p2) -- line: 8
	-- upvalues: collectSubFields (copy), LuauPolyfill (copy), UserProfileNestedFields (copy)
	local v9 = p2 or collectSubFields
	local v10 = v9(p1.schema, p1.fragments, p1.variableValues, p1.returnType, p1.fieldNodes)
	local t1 = {}

	for _, v13 in v10 do
		local v14 = v13[1]

		if UserProfileNestedFields[v14] then
			for _, v16 in (v9(p1.schema, p1.fragments, p1.variableValues, p1.returnType, v10[v14])) do
				local v17 = `{ v14 }.{ v16[1] }`

				if v17 ~= nil and (v17 ~= "id" and not LuauPolyfill.String.endsWith(v17, "__typename")) then
					table.insert(t1, v17)
				end
			end
		elseif v14 ~= nil and (v14 ~= "id" and not LuauPolyfill.String.endsWith(v14, "__typename")) then
			table.insert(t1, v14)
		end
	end

	return t1
end
