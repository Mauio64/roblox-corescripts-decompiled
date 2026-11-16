local parent = script.Parent.Parent
require(parent.jsutils.ObjMap)

local keyMap = require(parent.jsutils.keyMap)
local keyMap2 = keyMap.keyMap
local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

require(parent.language.ast)

local kinds = require(parent.language.kinds)
local kind = kinds.Kind

local definition = require(parent.type.definition)

local isLeafType = definition.isLeafType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType

local null = require(parent.luaUtils.null)

local isMissingVariable
local function valueFromAST(data, object, p)
	if not data then
		return
	end

	if data.kind == kind.VARIABLE then
		local value = data.name.value

		if p == nil or p[value] == nil then
			return
		end

		local v = p[value]

		if v == null and isNonNullType(object) then
			return
		end

		return v
	elseif isNonNullType(object) then
		if data.kind == kind.NULL then
			return
		end

		return valueFromAST(data, object.ofType, p)
	else
		if data.kind == kind.NULL then
			return null
		end

		if isListType(object) then
			local ofType = object.ofType

			if data.kind == kind.LIST then
				local result = {}

				for _, value in ipairs(data.values) do
					if isMissingVariable(value, p) then
						if isNonNullType(ofType) then
							return
						end

						table.insert(result, null)
					else
						local v = valueFromAST(value, ofType, p)

						if v == nil then
							return
						end

						table.insert(result, v)
					end
				end

				return result
			else
				local v = valueFromAST(data, ofType, p)

				if v == nil then
					return
				end

				return { v }
			end
		elseif isInputObjectType(object) then
			if data.kind ~= kind.OBJECT then
				return
			end

			local v = keyMap2(data.fields, function(p2)
				return p2.name.value
			end)
			local result = {}

			for _, v2 in ipairs(object:getFields():values()) do
				local v3 = v[v2.name]

				if v3 and not isMissingVariable(v3.value, p) then
					local v4 = valueFromAST(v3.value, v2.type, p)

					if v4 == nil then
						return
					end

					result[v2.name] = v4
				elseif v2.defaultValue == nil then
					if isNonNullType(v2.type) then
						return
					end
				else
					result[v2.name] = v2.defaultValue
				end
			end

			return result
		else
			if not isLeafType(object) then
				invariant2(false, "Unexpected input type: " .. inspect2(object))
				return
			end

			local v = nil

			if not pcall(function()
				v = object:parseLiteral(data, p)
			end) then
				return
			end

			if v == nil then
				return
			end

			return v
		end
	end
end

isMissingVariable = function(value, p): boolean
	return value.kind == kind.VARIABLE and (p == nil or p[value.name.value] == nil)
end

return { valueFromAST = valueFromAST }
