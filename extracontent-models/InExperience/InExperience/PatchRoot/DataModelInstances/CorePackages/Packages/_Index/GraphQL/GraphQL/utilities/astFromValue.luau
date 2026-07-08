local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local luaUtils = ParentParent.luaUtils
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local RegExp = require(ParentParentParent.RegExp)
local inspect = require(ParentParent.jsutils.inspect).inspect
local invariant = require(ParentParent.jsutils.invariant).invariant
local isObjectLike = require(ParentParent.jsutils.isObjectLike).isObjectLike
local isIteratableObject = require(ParentParent.jsutils.isIteratableObject).isIteratableObject

require(ParentParent.language.ast)

local Kind = require(ParentParent.language.kinds).Kind
local GraphQLID = require(ParentParent.type.scalars).GraphQLID
local definition = require(ParentParent.type.definition)
local isLeafType = definition.isLeafType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish
local u24 = nil

local function astFromValue(p1, p2) -- line: 70
	-- upvalues: isNonNullType (copy), astFromValue (copy), null (copy), Kind (copy), isListType (copy), isIteratableObject (copy), isNotNillish (copy), isInputObjectType (copy), isObjectLike (copy), isLeafType (copy), isNillish2 (copy), Number (copy), u24 (ref), isEnumType (copy), GraphQLID (copy), Error (copy), inspect (copy), invariant (copy)
	if isNonNullType(p2) then
		local v28 = astFromValue(p1, p2.ofType)

		if (v28 ~= nil and (v28 ~= null and v28.kind)) == Kind.NULL then
			return null
		end

		return v28
	end

	if p1 == null then
		return {
			kind = Kind.NULL
		}
	end

	if p1 == nil then
		return null
	end

	if isListType(p2) then
		local ofType = p2.ofType

		if isIteratableObject(p1) then
			local t1 = {}

			for _, v in pairs(p1) do
				local v33 = astFromValue(v, ofType)

				if isNotNillish(v33) then
					table.insert(t1, v33)
				end
			end

			return {
				kind = Kind.LIST,
				values = t1
			}
		end

		return astFromValue(p1, ofType)
	end

	if isInputObjectType(p2) then
		if not isObjectLike(p1) then
			return null
		end

		local t2 = {}

		for _, v in ipairs(p2:getFields():values()) do
			local v37 = astFromValue(p1[v.name], v.type)

			if isNotNillish(v37) then
				table.insert(t2, {
					kind = Kind.OBJECT_FIELD,
					name = {
						kind = Kind.NAME,
						value = v.name
					},
					value = v37
				})
			end
		end

		return {
			kind = Kind.OBJECT,
			fields = t2
		}
	end

	if isLeafType(p2) then
		local v38 = p2:serialize(p1)

		if isNillish2(v38) then
			return null
		end

		if typeof(v38) == "boolean" then
			return {
				kind = Kind.BOOLEAN,
				value = v38
			}
		end

		if typeof(v38) == "number" and Number.isFinite(v38) then
			local str = tostring(v38)

			if u24:test(str) then
				return {
					kind = Kind.INT,
					value = str
				}
			end

			return {
				kind = Kind.FLOAT,
				value = str
			}
		end

		if typeof(v38) == "string" then
			if isEnumType(p2) then
				return {
					kind = Kind.ENUM,
					value = v38
				}
			end

			if p2 == GraphQLID and u24:test(v38) then
				return {
					kind = Kind.INT,
					value = v38
				}
			end

			return {
				kind = Kind.STRING,
				value = v38
			}
		end

		error(Error.new(("Cannot convert value to AST: %s."):format(inspect(v38))))
	end

	invariant(false, "Unexpected input type: " .. inspect(p2))
end

u24 = RegExp("^-?(?:0|[1-9][0-9]*)$")

return {
	astFromValue = astFromValue,
	NULL = null
}
