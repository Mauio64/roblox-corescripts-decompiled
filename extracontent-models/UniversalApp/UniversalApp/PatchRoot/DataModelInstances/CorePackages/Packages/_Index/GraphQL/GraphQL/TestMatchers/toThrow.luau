local function toThrow(p1: ((...any) -> ...any), s1: string?, b1: boolean?) -- line: 16
	local ok, result = pcall(p1)

	if not ok then
		if typeof(s1) == "string" then
			local v7 = nil

			if typeof(result) == "string" then
				v7 = result
			elseif typeof(result) == "table" and typeof(result.message) == "string" then
				v7 = result.message
			end

			if v7 == nil then
				return {
					pass = false,
					message = string.format("Matcher Error:\nExpected function to throw a string or an Error object, but it threw an error of type '%s'.\nYou may wish to use `pcall` instead and run custom expectations on the returned error", (typeof(result)))
				}
			end

			if v7:find(s1, 1, not b1) ~= nil then
				return {
					pass = true,
					message = string.format("Expected function not to throw with '%s'", s1)
				}
			end

			return {
				pass = false,
				message = string.format("Expected function to throw with\n'%s'\nbut threw\n'%s'\ninstead", s1, v7)
			}
		end

		return {
			pass = true,
			message = "Expected function not to throw"
		}
	end

	return {
		pass = false,
		message = "Expected function to throw"
	}
end

return toThrow
