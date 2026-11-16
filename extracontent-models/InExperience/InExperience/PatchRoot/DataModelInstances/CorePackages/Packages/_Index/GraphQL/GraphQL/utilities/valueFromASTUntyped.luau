local parent = script.Parent.Parent
local parent2 = parent.Parent
local jsutils = parent.jsutils
local language = parent.language

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local coerceToTable = LuauPolyfill.coerceToTable

local null = require(parent.luaUtils.null)

require(jsutils.ObjMap)

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant
local keyValMap = require(jsutils.keyValMap)
local keyValMap2 = keyValMap.keyValMap

local kinds = require(language.kinds)
local kind = kinds.Kind
require(language.ast)
local function valueFromASTUntyped(data, p)
	if data.kind == kind.NULL then
		return null
	end

	if data.kind == kind.INT then
		return (tonumber(data.value, 10))
	end

	if data.kind == kind.FLOAT then
		return (tonumber(data.value))
	end

	if data.kind == kind.STRING or data.kind == kind.ENUM or data.kind == kind.BOOLEAN then
		return data.value
	end

	if data.kind == kind.LIST then
		return Array.map(data.values, function(p2)
			return valueFromASTUntyped(p2, p)
		end)
	end

	if data.kind == kind.OBJECT then
		return coerceToTable(keyValMap2(data.fields, function(p2)
			return p2.name.value
		end, function(p2)
			return valueFromASTUntyped(p2.value, p)
		end))
	end

	if data.kind == kind.VARIABLE then
		return p and p[data.name.value]
	end

	invariant2(false, "Unexpected value node: " .. inspect2(data))

	error("Unexpected value node: " .. inspect2(data))
end

return { valueFromASTUntyped = valueFromASTUntyped }
