local Parent = script:FindFirstAncestor("AppChat").Parent
local Http = require(Parent.Http)
local HttpClient = require(Parent.HttpClient)

require(Parent.ShareLinksNetworking)

local v4 = Http.Url.APIS_URL .. "deeplinks/v2/resolve"

local function decodeResolvedShareLink(p1) -- line: 14
	if type(p1) ~= "table" or (type(p1.linkType) ~= "string" or type(p1.targetId) ~= "string" or type(p1.customData) ~= "string" or type(p1.status) ~= "string") then
		error("Malformed deeplinks/v2/resolve response")
	end

	return p1
end
local function fetchResolvedShareLink(s1: string, p2) -- line: 28
	-- upvalues: HttpClient (copy), v4 (copy), decodeResolvedShareLink (copy)
	return HttpClient.fetch({
		method = "POST",
		analyticsKey = "app-chat.resolve-share-link-v2",
		url = v4,
		body = {
			linkId = s1
		},
		network = p2,
		decode = decodeResolvedShareLink
	})
end

return fetchResolvedShareLink
