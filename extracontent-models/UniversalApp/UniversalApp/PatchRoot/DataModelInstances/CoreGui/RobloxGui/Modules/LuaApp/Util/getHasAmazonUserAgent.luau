local HttpService = game:GetService("HttpService")

return function() -- line: 3
	-- upvalues: HttpService (copy)
	return string.find(HttpService:GetUserAgent(), "AmazonAppStore") ~= nil
end
