local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map

local EnumValues = {}

require(parent.GraphQL)

local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives

require(script.Parent["merge-typedefs_types"])

local Utils = require(parent.Utils)
local compareNodes = Utils.compareNodes

function EnumValues.mergeEnumValues(items, items2, p)
	local toJSBoolean = Boolean.toJSBoolean
	local v

	if typeof(p) == "table" then
		v = p.consistentEnumMerge
	end

	if toJSBoolean(v) then
		local joined = {}

		if Boolean.toJSBoolean(items) then
			joined = Array.concat(joined, items)
		end

		items = items2
		items2 = joined
	end

	local v2 = Map.new()

	if items then
		for _, item in items do
			v2:set(item.name.value, item)
		end
	end

	if items2 then
		for _, item in items2 do
			local value = item.name.value

			if Boolean.toJSBoolean(v2:has(value)) then
				local v3 = v2:get(value)
				v3.description = Boolean.toJSBoolean(item.description) and item.description or v3.description
				v3.directives = mergeDirectives(item.directives, v3.directives)
			else
				v2:set(value, item)
			end
		end
	end

	local joined = Array.concat({}, v2:values())

	if p and Boolean.toJSBoolean(p.sort) then
		Array.sort(joined, compareNodes)
	end

	return joined
end
return EnumValues
