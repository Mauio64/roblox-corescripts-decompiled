local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local String = LuauPolyfill.String
local t1 = {}
local mergeDeep = require(ParentParent.Utils).mergeDeep

local function mergeResolvers(p1, t2: {[any]: any}?) -- line: 59
	-- upvalues: Boolean (copy), Array (copy), mergeResolvers (copy), mergeDeep (copy), String (copy)
	if not Boolean.toJSBoolean(p1) or Array.isArray(p1) and #p1 == 0 then
		return {}
	end

	if not Boolean.toJSBoolean(Array.isArray(p1)) then
		return p1
	end

	if #p1 == 1 then
		if Boolean.toJSBoolean(p1[1]) then
			return p1[1]
		end

		return {}
	end

	local t3 = {}

	for _, v13 in p1 do
		local v14 = v13

		if Boolean.toJSBoolean(Array.isArray(v14)) then
			v14 = mergeResolvers(v14)
		end

		if Boolean.toJSBoolean(typeof(v14) == "table" and v14) then
			table.insert(t3, v14)
		end
	end

	local v15 = mergeDeep(t3, true)

	if Boolean.toJSBoolean(if typeof(t2) ~= "table" then nil else t2.exclusions) then
		for _, v17 in t2.exclusions do
			local v18, v19 = table.unpack(String.split(v17, "."), 1, 2)

			if not Boolean.toJSBoolean(v19) or v19 == "*" then
				v15[v18] = nil
			elseif Boolean.toJSBoolean(v15[v18]) then
				v15[v18][v19] = nil
			end
		end
	end

	return v15
end

t1.mergeResolvers = mergeResolvers

return t1
