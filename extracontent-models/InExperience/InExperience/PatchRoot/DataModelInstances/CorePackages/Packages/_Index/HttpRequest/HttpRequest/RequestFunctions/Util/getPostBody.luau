local HttpService = game:GetService("HttpService")

return function(value, p)
	if p ~= "POST" and p ~= "PATCH" then
		return nil
	end

	if type(value) == "table" then
		return HttpService:JSONEncode(value)
	end

	if type(value) == "string" then
		return value
	end

	error("Expected postBody to be a string or table")

	return nil
end
