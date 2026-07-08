require(script.Parent.types)

local function parseApiError(p1) -- line: 6
	if typeof(p1) ~= "table" then
		return nil
	end

	local code = p1.code
	local message = p1.message

	if typeof(code) ~= "number" or typeof(message) ~= "string" then
		return nil
	end

	return {
		code = code,
		message = message,
		details = p1.details
	}
end

return parseApiError
