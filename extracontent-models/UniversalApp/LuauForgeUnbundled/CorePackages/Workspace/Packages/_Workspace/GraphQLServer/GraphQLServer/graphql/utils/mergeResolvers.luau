local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local array = LuauPolyfill.Array
local boolean = LuauPolyfill.Boolean

local mergeDeep = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/utils/mergeDeep")
local function mergeResolvers(list, p2)
	if not list or array.isArray(list) and #list == 0 then
		return {}
	end

	if not array.isArray(list) then
		return list
	end

	if #list == 1 then
		return list[1] or {}
	end

	local v5 = {}

	for k, item in list do
		if array.isArray(item) then
			item = mergeResolvers(item)
		end

		if type(item) == "table" and item then
			table.insert(v5, item)
		end
	end

	local result = mergeDeep(v5, true)

	if p2 and p2.exclusions then
		for k, exclusion in p2.exclusions do
			local v6, v7 = table.unpack(exclusion:split("."), 1, 2)

			if v7 and v7 ~= "*" then
				if boolean.toJSBoolean(result[tostring(v6)]) then
					result[tostring(v6)][tostring(v7)] = nil
				end
			else
				result[tostring(v6)] = nil
			end
		end
	end

	return result
end

return mergeResolvers
