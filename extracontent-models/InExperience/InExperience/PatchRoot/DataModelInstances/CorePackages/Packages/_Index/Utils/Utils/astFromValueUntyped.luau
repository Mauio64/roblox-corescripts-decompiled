local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local t1 = {}
local Kind = require(ParentParent.GraphQL).Kind
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object
local LuauRegExp = require(ParentParent.LuauRegExp)
local u11 = nil

local function isFinite(p1) -- line: 31
	-- upvalues: Number (copy)
	local ok, result = pcall(function() -- line: 32
		-- upvalues: p1 (copy), Number (copy)
		local num = tonumber(p1)

		if Number.isNaN(num) or num == 1e999 or num == -1e999 then
			return false
		end

		return true
	end)

	if not ok then
		return false
	end

	return result
end
local function astFromValueUntyped(p2) -- line: 61
	-- upvalues: Object (copy), Kind (copy), Boolean (copy), Array (copy), astFromValueUntyped (copy), Number (copy), u11 (ref), Error (copy)
	if p2 == Object.None then
		return {
			kind = Kind.NULL
		}
	end

	if p2 == nil then
		return nil
	end

	if Boolean.toJSBoolean(Array.isArray(p2)) then
		local t2 = {}

		for _, v20 in p2 do
			local v21 = astFromValueUntyped(v20)

			if v21 ~= nil then
				table.insert(t2, v21)
			end
		end

		return {
			kind = Kind.LIST,
			values = t2
		}
	end

	if typeof(p2) == "table" then
		local t3 = {}

		for v23 in p2 do
			local v24 = p2[tostring(v23)]
			local v25 = astFromValueUntyped(v24)

			if Boolean.toJSBoolean(v25) then
				table.insert(t3, {
					kind = Kind.OBJECT_FIELD,
					name = {
						kind = Kind.NAME,
						value = v23
					},
					value = v25
				})
			end
		end

		return {
			kind = Kind.OBJECT,
			fields = t3
		}
	end

	if typeof(p2) == "boolean" then
		return {
			kind = Kind.BOOLEAN,
			value = p2
		}
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v27 = false

	if typeof(p2) == "number" then
		local ok, result = pcall(function() -- line: 32
			-- upvalues: p2 (copy), Number (copy)
			local num = tonumber(p2)

			if Number.isNaN(num) or num == 1e999 or num == -1e999 then
				return false
			end

			return true
		end)

		v27 = if ok then result else false
	end

	if toJSBoolean(v27) then
		local str = tostring(p2)

		if Boolean.toJSBoolean(u11:test(str)) then
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

	if typeof(p2) == "string" then
		return {
			kind = Kind.STRING,
			value = p2
		}
	end

	error(Error.new(("Cannot convert value to AST: %s."):format((tostring(p2)))))
end

t1.astFromValueUntyped = astFromValueUntyped
u11 = LuauRegExp("^-?(?:0|[1-9][0-9]*)$")

return t1
