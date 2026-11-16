local HttpService = game:GetService("HttpService")

return function(p2)
	local statusCode = if type(p2) == "table" then p2.StatusCode else nil
	local code = nil
	local body = if type(p2) == "table" then p2.Body else nil

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
