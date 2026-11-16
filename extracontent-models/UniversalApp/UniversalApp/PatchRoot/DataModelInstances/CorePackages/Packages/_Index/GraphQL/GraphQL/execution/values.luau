local parent = script.Parent.Parent

local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)

local Array = LuauPolyfill.Array

local null = require(parent.luaUtils.null)
local isNillish = require(parent.luaUtils.isNillish)
local isNillish2 = isNillish.isNillish

require(parent.jsutils.ObjMap)

local keyMap = require(parent.jsutils.keyMap)
local keyMap2 = keyMap.keyMap
local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local printPathArray = require(parent.jsutils.printPathArray)
local printPathArray2 = printPathArray.printPathArray

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local language = parent.language
require(language.ast)

local kinds = require(language.kinds)
local kind = kinds.Kind
local printer = require(language.printer)
local Print = printer.print

local kind2 = parent.type
require(kind2.schema)

require(kind2.definition)

require(kind2.directives)

local definition = require(parent.type.definition)
local isInputType = definition.isInputType
local isNonNullType = definition.isNonNullType

local typeFromAST = require(parent.utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST
local valueFromAST = require(parent.utilities.valueFromAST)
local valueFromAST2 = valueFromAST.valueFromAST
local coerceInputValue = require(parent.utilities.coerceInputValue)
local coerceInputValue2 = coerceInputValue.coerceInputValue

local coerceVariableValues

local hasOwnProperty

local function fn(p, p2, p3, p4)
	local errors = {}
	local maxErrors

	if p4 == nil then
		maxErrors = nil
	else
		maxErrors = p4.maxErrors
	end

	local success, result = pcall(coerceVariableValues, p, p2, p3, function(p5)
		if maxErrors ~= nil and maxErrors <= #errors then
			error(graphQLError.new("Too many errors processing variables, error limit reached. Execution aborted."))
		end

		table.insert(errors, p5)
	end)

	if not success then
		table.insert(errors, result)
	end

	if #errors == 0 then
		return { coerced = result }
	end

	return { errors = errors }
end

coerceVariableValues = function(p, list, p2, callback)
	local result = {}

	for _, item in ipairs(list) do
		local value = item.variable.name.value
		local v = typeFromAST2(p, item.type)

		if isInputType(v) then
			if hasOwnProperty(p2, value) then
				local v2 = p2[value]

				if v2 == null and isNonNullType(v) then
					local v3 = inspect2(v)
					callback(graphQLError.new(
						("Variable \"$%s\" of non-null type \"%s\" must not be null."):format(value, v3),
						item
					))
				else
					result[value] = coerceInputValue2(v2, v, function(list2, p3, p4)
						local v3 = ("Variable \"$%s\" got invalid value "):format(value) .. inspect2(p3)

						if #list2 > 0 then
							v3 ..= (" at \"%s%s\""):format(value, printPathArray2(list2))
						end

						callback(graphQLError.new(v3 .. "; " .. p4.message, item, nil, nil, nil, p4.originalError))
					end)
				end
			elseif item.defaultValue then
				result[value] = valueFromAST2(item.defaultValue, v)
			elseif isNonNullType(v) then
				local v2 = inspect2(v)
				callback(graphQLError.new(
					("Variable \"$%s\" of required type \"%s\" was not provided."):format(value, v2),
					item
				))
			end
		else
			local Print2 = Print(item.type)
			callback(graphQLError.new(
				("Variable \"$%s\" expected value of type \"%s\" which cannot be used as an input type."):format(
					value,
					Print2
				),
				item.type
			))
		end
	end

	return result
end

local function getArgumentValues(p, p2, p3)
	local v = keyMap2(not p2.arguments and {} or p2.arguments, function(p4)
		return p4.name.value
	end)
	local argumentValues = {}

	for _, arg in ipairs(p.args) do
		local name = arg.name
		local kind3 = arg.type

		local v2 = v[name]

		if v2 then
			local value = v2.value
			local v3 = value.kind == kind.NULL

			if value.kind == kind.VARIABLE then
				local value2 = value.name.value

				if p3 == nil or not hasOwnProperty(p3, value2) then
					if arg.defaultValue == nil then
						if isNonNullType(kind3) then
							error(graphQLError.new(
								("Argument \"%s\" of required type \"%s\" "):format(name, inspect2(kind3)) .. ("was provided the variable \"$%s\" which was not provided a runtime value."):format(value2),
								value
							))
						end
					else
						argumentValues[name] = arg.defaultValue
					end

					continue
				end

				v3 = isNillish2(p3[value2])
			end

			if v3 and isNonNullType(kind3) then
				error(graphQLError.new(
					("Argument \"%s\" of non-null type \"%s\" "):format(name, inspect2(kind3)) .. "must not be null.",
					value
				))
			end

			local v4 = valueFromAST2(value, kind3, p3)

			if v4 == nil then
				error(graphQLError.new(("Argument \"%s\" has invalid value %s."):format(name, Print(value)), value))
			end

			argumentValues[name] = v4
		elseif arg.defaultValue == nil then
			if isNonNullType(kind3) then
				error(graphQLError.new(
					("Argument \"%s\" of required type \"%s\" "):format(name, inspect2(kind3)) .. "was not provided.",
					p2
				))
			end
		else
			argumentValues[name] = arg.defaultValue
		end
	end

	return argumentValues
end

local function fn2(p, p2, p3)
	local v

	if p2.directives then
		v = Array.find(p2.directives, function(p4): boolean
			return p4.name.value == p.name
		end)
	end

	if v then
		return getArgumentValues(p, v, p3)
	end

	return nil
end

hasOwnProperty = function(p, value: string): boolean
	return p[value] ~= nil
end

return { getVariableValues = fn, getArgumentValues = getArgumentValues, getDirectiveValues = fn2 }
