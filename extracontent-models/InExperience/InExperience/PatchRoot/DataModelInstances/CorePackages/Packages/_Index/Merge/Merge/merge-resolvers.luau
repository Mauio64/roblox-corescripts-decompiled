local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local String = LuauPolyfill.String

local Utils = require(parent.Utils)

local mergeDeep = Utils.mergeDeep
local function mergeResolvers(list, p)
	if not Boolean.toJSBoolean(list) or Array.isArray(list) and #list == 0 then
		return {}
	end

	if not Boolean.toJSBoolean(Array.isArray(list)) then
		return list
	end

	if #list == 1 then
		if Boolean.toJSBoolean(list[1]) then
			return list[1]
		end

		return {}
	else
		local v = {}

		for _, item in list do
			if Boolean.toJSBoolean(Array.isArray(item)) then
				item = mergeResolvers(item)
			end

			local toJSBoolean = Boolean.toJSBoolean
			local v2 = typeof(item) == "table" and item

			if toJSBoolean(v2) then
				table.insert(v, item)
			end
		end

		local result = mergeDeep(v, true)

		local toJSBoolean = Boolean.toJSBoolean
		local v2

		if typeof(p) == "table" then
			v2 = p.exclusions
		end

		if not toJSBoolean(v2) then
			return result
		end

		for _, exclusion in p.exclusions do
			local v3, v4 = table.unpack(String.split(exclusion, "."), 1, 2)

			if Boolean.toJSBoolean(v4) and v4 ~= "*" then
				if Boolean.toJSBoolean(result[v3]) then
					result[v3][v4] = nil
				end
			else
				result[v3] = nil
			end
		end

		return result
	end
end

return { mergeResolvers = mergeResolvers }
