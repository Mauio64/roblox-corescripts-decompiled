local GraphqlToolsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphqlToolsUtils")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local collectSubFields = GraphqlToolsUtils.collectSubFields
local UserProfileNestedFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/enums/UserProfileNestedFields")

return function(data, p2)
	local v5 = p2 or collectSubFields
	local v6 = v5(data.schema, data.fragments, data.variableValues, data.returnType, data.fieldNodes)

	local result = {}

	for k, v7 in v6 do
		local v8 = v7[1]

		if UserProfileNestedFields[v8] then
			local v9 = v5(data.schema, data.fragments, data.variableValues, data.returnType, v6[v8])

			for k2, v10 in v9 do
				local formatted = `{v8}.{v10[1]}`

				if
					formatted == nil
					or formatted == "id"
					or LuauPolyfill.String.endsWith(formatted, "__typename")
				then
					continue
				end

				table.insert(result, formatted)
			end
		elseif v8 ~= nil and v8 ~= "id" and not LuauPolyfill.String.endsWith(v8, "__typename") then
			table.insert(result, v8)
		end
	end

	return result
end
