local HttpService = game:GetService("HttpService")

local function getAuthorizedVideoUri(p2, p3)
	if p3 == nil or p3 == "" then
		return p2
	end

	return `{p2}&accessContext={HttpService:UrlEncode(p3)}`
end

return getAuthorizedVideoUri
