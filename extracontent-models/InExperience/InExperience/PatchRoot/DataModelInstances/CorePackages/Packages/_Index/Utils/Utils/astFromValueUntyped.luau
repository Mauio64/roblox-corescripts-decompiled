local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local GraphQL = require(parent.GraphQL)
local Kind = GraphQL.Kind

local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object

local LuauRegExp = require(parent.LuauRegExp)

local v = nil

local function isFinite(p)
	local success, result = pcall(function(): boolean
		local v2 = tonumber(p)

		return not Number.isNaN(v2) and v2 ~= 1e999 and v2 ~= -1e999
	end)
	return if success then result else false
end

local function astFromValueUntyped(item)
	if item == Object.None then
		return { kind = Kind.NULL }
	end

	if item == nil then
		return nil
	end

	if Boolean.toJSBoolean(Array.isArray(item)) then
		local values = {}

		for _, item2 in item do
			local v2 = astFromValueUntyped(item2)

			if v2 ~= nil then
				table.insert(values, v2)
			end
		end

		return { kind = Kind.LIST, values = values }
	elseif typeof(item) == "table" then
		local fields = {}

		for k in item do
			local v2 = astFromValueUntyped(item[tostring(k)])

			if Boolean.toJSBoolean(v2) then
				table.insert(fields, {
					kind = Kind.OBJECT_FIELD,
					name = { kind = Kind.NAME, value = k },
					value = v2
				})
			end
		end

		return { kind = Kind.OBJECT, fields = fields }
	else
		if typeof(item) == "boolean" then
			return { kind = Kind.BOOLEAN, value = item }
		end

		local toJSBoolean = Boolean.toJSBoolean
		local result

		if typeof(item) == "number" then
			local success
			success, result = pcall(function(): boolean
				local v2 = tonumber(item)

				return not Number.isNaN(v2) and v2 ~= 1e999 and v2 ~= -1e999
			end)

			if not success then
				result = false
			end
		else
			result = false
		end

		if toJSBoolean(result) then
			local v2 = tostring(item)

			if Boolean.toJSBoolean(v:test(v2)) then
				return { kind = Kind.INT, value = v2 }
			end

			return { kind = Kind.FLOAT, value = v2 }
		end

		if typeof(item) == "string" then
			return { kind = Kind.STRING, value = item }
		end

		error(Error.new(("Cannot convert value to AST: %s."):format((tostring(item)))))
	end
end

v = LuauRegExp("^-?(?:0|[1-9][0-9]*)$")
return { astFromValueUntyped = astFromValueUntyped }
