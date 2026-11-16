local function toThrow(callback, value: string?, flag: boolean?)
	local success, result = pcall(callback)

	if success then
		return { pass = false, message = "Expected function to throw" }
	end

	if typeof(value) ~= "string" then
		return { pass = true, message = "Expected function not to throw" }
	end

	local v = nil

	if typeof(result) == "string" then
		v = result
	elseif typeof(result) == "table" and typeof(result.message) == "string" then
		v = result.message
	end

	if v == nil then
		return {
			pass = false,
			message = string.format(
				"Matcher Error:\nExpected function to throw a string or an Error object, but it threw an error of type '%s'.\nYou may wish to use `pcall` instead and run custom expectations on the returned error",
				(typeof(result))
			)
		}
	end

	if v:find(value, 1, not flag) == nil then
		return {
			pass = false,
			message = string.format("Expected function to throw with\n'%s'\nbut threw\n'%s'\ninstead", value, v)
		}
	end

	return {
		pass = true,
		message = string.format("Expected function not to throw with '%s'", value)
	}
end

return toThrow
