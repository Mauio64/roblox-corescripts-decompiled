local parent = script:FindFirstAncestor("BuildExperience").Parent

local HttpService = game:GetService("HttpService")

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local url = UrlBase.APIS .. "/sharelinks/v1/get-or-create-link"

local function decodeShareLink(p)
	if type(p) == "table" and type(p.shortUrl) == "string" then
		return p.shortUrl
	end

	return nil
end

local function createExperienceShareLink(p: number, retry: boolean?)
	return asPromise((fetch({
		method = "POST",
		url = url,
		body = {
			linkType = "ExperienceDetails",
			data = HttpService:JSONEncode({ universeId = tostring(p) })
		},
		analyticsKey = "build-experience.create-private-share-link",
		decode = decodeShareLink,
		retry = retry
	})))
end

return createExperienceShareLink
