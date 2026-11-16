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

local function astFromValueUntyped(value)
	if value == Object.None then
		return { kind = Kind.NULL }
	end

	if value == nil then
		return nil
	end

	if Boolean.toJSBoolean(Array.isArray(value)) then
		local values = {}

		for _, item in value do
			local v2 = astFromValueUntyped(item)

			if v2 ~= nil then
				table.insert(values, v2)
			end
		end

		return { kind = Kind.LIST, values = values }
	elseif typeof(value) == "table" then
		local fields = {}

		for k in value do
			local v2 = astFromValueUntyped(value[tostring(k)])

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
		if typeof(value) == "boolean" then
			return { kind = Kind.BOOLEAN, value = value }
		end

		local toJSBoolean = Boolean.toJSBoolean
		local result

		if typeof(value) == "number" then
			local success
			success, result = pcall(function(): boolean
				local v2 = tonumber(value)

				return not Number.isNaN(v2) and v2 ~= 1e999 and v2 ~= -1e999
			end)

			if not success then
				result = false
			end
		else
			result = false
		end

		if toJSBoolean(result) then
			local v2 = tostring(value)

			if Boolean.toJSBoolean(v:test(v2)) then
				return { kind = Kind.INT, value = v2 }
			end

			return { kind = Kind.FLOAT, value = v2 }
		end

		if typeof(value) == "string" then
			return { kind = Kind.STRING, value = value }
		end

		error(Error.new(("Cannot convert value to AST: %s."):format((tostring(value)))))
	end
end

v = LuauRegExp("^-?(?:0|[1-9][0-9]*)$")
return { astFromValueUntyped = astFromValueUntyped }
