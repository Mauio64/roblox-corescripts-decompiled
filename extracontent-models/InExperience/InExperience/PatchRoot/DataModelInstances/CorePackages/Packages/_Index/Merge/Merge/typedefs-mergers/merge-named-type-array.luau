local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local t1 = {}

require(ParentParent.GraphQL)
require(script.Parent["merge-typedefs_types"])

local compareNodes = require(ParentParent.Utils).compareNodes

local function alreadyExists(p1, p2) -- line: 25
	-- upvalues: Boolean (copy), Array (copy)
	return not not Boolean.toJSBoolean(Array.find(p1, function(p3) -- line: 26
		-- upvalues: p2 (copy)
		return p3.name.value == p2.name.value
	end))
end

function t1.mergeNamedTypeArray(p4, p5, p6) -- line: 30
	-- upvalues: Array (copy), Boolean (copy), compareNodes (copy)
	local v13 = if p4 == nil then {} else p4
	local v14 = if p5 == nil then {} else p5
	local v15 = if p6 == nil then {} else p6
	local v16 = Array.concat({}, v14, Array.filter(v13, function(p7) -- line: 44
		-- upvalues: Boolean (copy), v14 (copy), Array (copy)
		local toJSBoolean = Boolean.toJSBoolean
		local v20 = v14

		return not toJSBoolean(not not Boolean.toJSBoolean(Array.find(v20, function(p8) -- line: 26
			-- upvalues: p7 (copy)
			return p8.name.value == p7.name.value
		end)))
	end))

	if v15 and Boolean.toJSBoolean(v15.sort) then
		Array.sort(v16, compareNodes)
	end

	return v16
end

return t1
