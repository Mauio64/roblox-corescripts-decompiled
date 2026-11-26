local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local object = LuauPolyfill.Object
local array = LuauPolyfill.Array

local function isObject(list)
	local v5 = typeof(list) == "table" and not (array.isArray(list) and #list > 0)
	return v5
end

local function mergeDeep(list, p2)
	local v5 = list[1] or {}
	local result = {}

	for k, item in list do
		local v6 = typeof(v5) == "table" and not (array.isArray(v5) and #v5 > 0)

		if not v6 then
			continue
		end

		local v7 = typeof(item) == "table" and not (array.isArray(item) and #item > 0)

		if not v7 then
			continue
		end

		for k2, v8 in item do
			if type(v8) == "table" then
				if result[k2] == nil then
					object.assign(result, { [k2] = v8 })
				else
					result[k2] = mergeDeep({ result[k2], v8 }, p2)
				end
			else
				object.assign(result, { [k2] = v8 })
			end
		end
	end

	return result
end

return mergeDeep
