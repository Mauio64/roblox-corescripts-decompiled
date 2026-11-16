local HttpService = game:GetService("HttpService")

local function getAuthorizedVideoUri(p: string, p2: string?)
	if p2 == nil or p2 == "" then
		return p
	end

	return `{p}&accessContext={HttpService:UrlEncode(p2)}`
end

return getAuthorizedVideoUri
