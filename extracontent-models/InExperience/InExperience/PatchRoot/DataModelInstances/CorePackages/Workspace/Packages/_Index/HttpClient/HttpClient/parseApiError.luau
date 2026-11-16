require(script.Parent.types)

local function parseApiError(data)
	if typeof(data) ~= "table" then
		return nil
	end

	local code = data.code
	local message = data.message

	if typeof(code) == "number" and typeof(message) == "string" then
		return { code = code, message = message, details = data.details }
	end

	return nil
end

return parseApiError
