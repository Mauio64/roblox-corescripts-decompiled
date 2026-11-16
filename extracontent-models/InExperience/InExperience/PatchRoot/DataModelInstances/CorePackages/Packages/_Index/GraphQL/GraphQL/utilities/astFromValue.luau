local parent = script.Parent.Parent
local parent2 = parent.Parent
local luaUtils = parent.luaUtils
local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local RegExp = require(parent2.RegExp)

local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local isObjectLike = require(parent.jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike
local isIteratableObject = require(parent.jsutils.isIteratableObject)
local isIteratableObject2 = isIteratableObject.isIteratableObject

require(parent.language.ast)

local kinds = require(parent.language.kinds)
local kind = kinds.Kind

local scalars = require(parent.type.scalars)
local graphQLID = scalars.GraphQLID
local definition = require(parent.type.definition)
local isLeafType = definition.isLeafType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType

local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

local v = nil
local function astFromValue(items, object)
	if isNonNullType(object) then
		local v2 = astFromValue(items, object.ofType)

		local v3 = not (v2 == nil or v2 == null) and v2.kind
		return if v3 == kind.NULL then null else v2
	end

	if items == null then
		return { kind = kind.NULL }
	end

	if items == nil then
		return null
	end

	if isListType(object) then
		local ofType = object.ofType

		if not isIteratableObject2(items) then
			return astFromValue(items, ofType)
		end

		local values = {}

		for _, item in pairs(items) do
			local v2 = astFromValue(item, ofType)

			if isNotNillish(v2) then
				table.insert(values, v2)
			end
		end

		return { kind = kind.LIST, values = values }
	elseif isInputObjectType(object) then
		if not isObjectLike2(items) then
			return null
		end

		local fields = {}

		for _, v2 in ipairs(object:getFields():values()) do
			local v3 = astFromValue(items[v2.name], v2.type)

			if isNotNillish(v3) then
				table.insert(fields, {
					kind = kind.OBJECT_FIELD,
					name = { kind = kind.NAME, value = v2.name },
					value = v3
				})
			end
		end

		return { kind = kind.OBJECT, fields = fields }
	else
		if isLeafType(object) then
			local serialized = object:serialize(items)

			if isNillish2(serialized) then
				return null
			end

			if typeof(serialized) == "boolean" then
				return { kind = kind.BOOLEAN, value = serialized }
			end

			if typeof(serialized) == "number" and Number.isFinite(serialized) then
				local v2 = tostring(serialized)

				if v:test(v2) then
					return { kind = kind.INT, value = v2 }
				end

				return { kind = kind.FLOAT, value = v2 }
			elseif typeof(serialized) == "string" then
				if isEnumType(object) then
					return { kind = kind.ENUM, value = serialized }
				end

				if object == graphQLID and v:test(serialized) then
					return { kind = kind.INT, value = serialized }
				end

				return { kind = kind.STRING, value = serialized }
			else
				error(Error.new(("Cannot convert value to AST: %s."):format(inspect2(serialized))))
			end
		end

		invariant2(false, "Unexpected input type: " .. inspect2(object))
	end
end

v = RegExp("^-?(?:0|[1-9][0-9]*)$")

return { astFromValue = astFromValue, NULL = null }
