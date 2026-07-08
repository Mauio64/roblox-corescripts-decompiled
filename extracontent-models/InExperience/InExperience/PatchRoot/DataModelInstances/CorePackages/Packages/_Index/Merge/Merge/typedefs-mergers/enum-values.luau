local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local t1 = {}

require(ParentParent.GraphQL)

local mergeDirectives = require(script.Parent.directives).mergeDirectives

require(script.Parent["merge-typedefs_types"])

local compareNodes = require(ParentParent.Utils).compareNodes

function t1.mergeEnumValues(p1, p2, p3) -- line: 30
	-- upvalues: Boolean (copy), Array (copy), Map (copy), mergeDirectives (copy), compareNodes (copy)
	if Boolean.toJSBoolean(if typeof(p3) ~= "table" then nil else p3.consistentEnumMerge) then
		local t2 = {}

		if Boolean.toJSBoolean(p1) then
			t2 = Array.concat(t2, p1)
		end

		p1 = p2
		p2 = t2
	end

	local v13 = Map.new()

	if p1 then
		for _, v15 in p1 do
			v13:set(v15.name.value, v15)
		end
	end

	if p2 then
		for _, v17 in p2 do
			local value = v17.name.value

			if Boolean.toJSBoolean(v13:has(value)) then
				local v19 = v13:get(value)

				v19.description = Boolean.toJSBoolean(v17.description) and v17.description or v19.description
				v19.directives = mergeDirectives(v17.directives, v19.directives)
			else
				v13:set(value, v17)
			end
		end
	end

	local v20 = Array.concat({}, v13:values())

	if p3 and Boolean.toJSBoolean(p3.sort) then
		Array.sort(v20, compareNodes)
	end

	return v20
end

return t1
