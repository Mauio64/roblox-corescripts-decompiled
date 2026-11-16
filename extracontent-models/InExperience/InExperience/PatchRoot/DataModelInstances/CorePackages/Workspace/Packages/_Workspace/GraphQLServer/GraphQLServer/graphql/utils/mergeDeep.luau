local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local function isObject(list): boolean -- 2 equivalent calls inferred from this helper
	return typeof(list) == "table" and not (Array.isArray(list) and #list > 0)
end

local function mergeDeep(list, flag: boolean?)
	local v = list[1] or {}
	local result = {}

	for _, item in list do
		if not (isObject(v) and isObject(item)) then -- inferred equivalent call
			continue
		end

		for k, v2 in item do
			if type(v2) == "table" then
				if result[k] == nil then
					Object.assign(result, { [k] = v2 })
				else
					result[k] = mergeDeep({ result[k], v2 }, flag)
				end
			else
				Object.assign(result, { [k] = v2 })
			end
		end
	end

	return result
end

return mergeDeep
