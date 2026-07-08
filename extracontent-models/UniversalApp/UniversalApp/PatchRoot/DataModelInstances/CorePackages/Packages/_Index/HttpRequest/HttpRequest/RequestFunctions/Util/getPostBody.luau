local HttpService = game:GetService("HttpService")

return function(p1, p2) -- line: 3
	-- upvalues: HttpService (copy)
	if p2 == "POST" or p2 == "PATCH" then
		if type(p1) == "table" then
			return HttpService:JSONEncode(p1)
		end

		if type(p1) == "string" then
			return p1
		end

		error("Expected postBody to be a string or table")
	end

	return nil
end
