local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local jsutils = ParentParent.jsutils
local language = ParentParent.language
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local coerceToTable = LuauPolyfill.coerceToTable
local null = require(ParentParent.luaUtils.null)

require(jsutils.ObjMap)

local inspect = require(jsutils.inspect).inspect
local invariant = require(jsutils.invariant).invariant
local keyValMap = require(jsutils.keyValMap).keyValMap
local Kind = require(language.kinds).Kind

require(language.ast)

local function valueFromASTUntyped(p1, p2) -- line: 48
	-- upvalues: Kind (copy), null (copy), Array (copy), valueFromASTUntyped (copy), coerceToTable (copy), keyValMap (copy), invariant (copy), inspect (copy)
	if p1.kind == Kind.NULL then
		return null
	end

	if p1.kind == Kind.INT then
		return (tonumber(p1.value, 10))
	end

	if p1.kind == Kind.FLOAT then
		return (tonumber(p1.value))
	end

	if p1.kind == Kind.STRING or p1.kind == Kind.ENUM or p1.kind == Kind.BOOLEAN then
		return p1.value
	end

	if p1.kind == Kind.LIST then
		return Array.map(p1.values, function(p3) -- line: 66
			-- upvalues: valueFromASTUntyped (copy), p2 (copy)
			return valueFromASTUntyped(p3, p2)
		end)
	end

	if p1.kind == Kind.OBJECT then
		return coerceToTable(keyValMap(p1.fields, function(p4) -- line: 71
			return p4.name.value
		end, function(p5) -- line: 73
			-- upvalues: valueFromASTUntyped (copy), p2 (copy)
			return valueFromASTUntyped(p5.value, p2)
		end))
	end

	if p1.kind == Kind.VARIABLE then
		return p2 and p2[p1.name.value]
	end

	invariant(false, "Unexpected value node: " .. inspect(p1))
	error("Unexpected value node: " .. inspect(p1))
end

return {
	valueFromASTUntyped = valueFromASTUntyped
}
