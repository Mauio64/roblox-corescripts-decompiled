local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local mergeDeep = require(script.Parent.mergeDeep)
local function mergeResolvers(list, p)
	if not list or Array.isArray(list) and #list == 0 then
		return {}
	end

	if not Array.isArray(list) then
		return list
	end

	if #list == 1 then
		return list[1] or {}
	end

	local v = {}

	for _, item in list do
		if Array.isArray(item) then
			item = mergeResolvers(item)
		end

		if type(item) == "table" and item then
			table.insert(v, item)
		end
	end

	local result = mergeDeep(v, true)

	if p and p.exclusions then
		for _, exclusion in p.exclusions do
			local v2, v3 = table.unpack(exclusion:split("."), 1, 2)

			if v3 and v3 ~= "*" then
				if Boolean.toJSBoolean(result[tostring(v2)]) then
					result[tostring(v2)][tostring(v3)] = nil
				end
			else
				result[tostring(v2)] = nil
			end
		end
	end

	return result
end

return mergeResolvers
