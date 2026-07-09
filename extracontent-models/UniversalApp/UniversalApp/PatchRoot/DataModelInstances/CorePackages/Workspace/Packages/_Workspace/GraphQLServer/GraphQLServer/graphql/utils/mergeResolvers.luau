local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local mergeDeep = require(script.Parent.mergeDeep)

local function mergeResolvers(p1, t1: {[any]: any}?) -- line: 14
	-- upvalues: Array (copy), mergeResolvers (copy), mergeDeep (copy), Boolean (copy)
	if not p1 or Array.isArray(p1) and #p1 == 0 then
		return {}
	end

	if not Array.isArray(p1) then
		return p1
	end

	if #p1 == 1 then
		return p1[1] or {}
	end

	local t2 = {}

	for _, v11 in p1 do
		local v12 = v11

		if Array.isArray(v12) then
			v12 = mergeResolvers(v12)
		end

		if type(v12) == "table" and v12 then
			table.insert(t2, v12)
		end
	end

	local v13 = mergeDeep(t2, true)

	if t1 and t1.exclusions then
		for _, v15 in t1.exclusions do
			local v16, v17 = table.unpack(v15:split("."), 1, 2)

			if not v17 or v17 == "*" then
				v13[tostring(v16)] = nil
			elseif Boolean.toJSBoolean(v13[tostring(v16)]) then
				v13[tostring(v16)][tostring(v17)] = nil
			end
		end
	end

	return v13
end

return mergeResolvers
