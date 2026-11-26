local HttpService = game:GetService("HttpService")

return function(): boolean
	return string.find(HttpService:GetUserAgent(), "AmazonAppStore") ~= nil
end
