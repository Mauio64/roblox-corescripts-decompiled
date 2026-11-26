local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBase

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local v5 = urlBase.APIS .. "/sharelinks/v1/get-or-create-link"

local function decodeShareLink(p2)
	if type(p2) == "table" and type(p2.shortUrl) == "string" then
		return p2.shortUrl
	end

	return nil
end

local function createExperienceShareLink(p2, p3)
	return asPromise((fetch({
		method = "POST",
		url = v5,
		body = {
			linkType = "ExperienceDetails",
			data = HttpService:JSONEncode({ universeId = tostring(p2) })
		},
		analyticsKey = "build-experience.create-private-share-link",
		decode = decodeShareLink,
		retry = p3
	})))
end

return createExperienceShareLink
