local Parent = script:FindFirstAncestor("BuildExperience").Parent
local HttpService = game:GetService("HttpService")
local HttpClient = require(Parent.HttpClient)
local UrlBase = require(Parent.UrlBuilder).UrlBase
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise
local v7 = UrlBase.APIS .. "/sharelinks/v1/get-or-create-link"

local function decodeShareLink(t1: {[any]: any}) -- line: 38
	if type(t1) == "table" and type(t1.shortUrl) == "string" then
		return t1.shortUrl
	end

	return nil
end
local function createPrivateShareLink(n1: number) -- line: 45
	-- upvalues: fetch (copy), v7 (copy), HttpService (copy), decodeShareLink (copy), asPromise (copy)
	local v12 = fetch({
		method = "POST",
		analyticsKey = "build-experience.create-private-share-link",
		url = v7,
		body = {
			linkType = "ExperienceDetails",
			data = HttpService:JSONEncode({
				universeId = tostring(n1)
			})
		},
		decode = decodeShareLink
	})

	return asPromise(v12)
end

return createPrivateShareLink
