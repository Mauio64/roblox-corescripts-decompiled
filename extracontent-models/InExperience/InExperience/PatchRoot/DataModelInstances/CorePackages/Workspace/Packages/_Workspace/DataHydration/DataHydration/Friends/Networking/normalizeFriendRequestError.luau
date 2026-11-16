local HttpService = game:GetService("HttpService")

return function(p)
	local statusCode

	if type(p) == "table" then
		statusCode = p.StatusCode
	end

	local code = nil
	local body

	if type(p) == "table" then
		body = p.Body
	end

	if type(body) == "string" then
		local success, result = pcall(HttpService.JSONDecode, HttpService, body)

		if success and type(result) == "table" then
			local errors = result.errors

			if type(errors) == "table" and errors[1] then
				code = errors[1].code
			end
		end
	end

	return { statusCode = statusCode, firstErrorCode = code }
end
