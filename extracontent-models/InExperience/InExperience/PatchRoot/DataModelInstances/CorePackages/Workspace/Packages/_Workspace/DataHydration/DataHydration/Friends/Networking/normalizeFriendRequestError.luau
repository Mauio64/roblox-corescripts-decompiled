local HttpService = game:GetService("HttpService")

return function(p1) -- line: 14
	-- upvalues: HttpService (copy)
	local v3 = if type(p1) ~= "table" then nil else p1.StatusCode
	local code = nil
	local v5 = if type(p1) ~= "table" then nil else p1.Body

	if type(v5) == "string" then
		local ok, result = pcall(HttpService.JSONDecode, HttpService, v5)

		if ok and type(result) == "table" then
			local errors = result.errors

			if type(errors) == "table" and errors[1] then
				code = errors[1].code
			end
		end
	end

	return {
		statusCode = v3,
		firstErrorCode = code
	}
end
