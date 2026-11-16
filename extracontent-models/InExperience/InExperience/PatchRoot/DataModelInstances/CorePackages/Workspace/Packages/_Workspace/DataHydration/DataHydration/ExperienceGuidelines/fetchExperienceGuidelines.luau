local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.ExperienceGuidelinesStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return {
	fetchDetailedGuidelines = function(universeId: number, options)
		local v = options or {}
		local baseUrl = v.baseUrl or UrlBase.APIS
		return asPromise((fetch({
			network = v.network,
			method = "POST",
			url = baseUrl .. "/experience-guidelines-service/v1beta1/detailed-guidelines",
			body = { universeId = universeId },
			analyticsKey = "experience-guidelines.get",
			decode = function(p)
				return p
			end
		})))
	end
}
