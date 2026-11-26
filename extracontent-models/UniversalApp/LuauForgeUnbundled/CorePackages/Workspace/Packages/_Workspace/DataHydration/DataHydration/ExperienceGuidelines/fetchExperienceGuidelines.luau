local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/ExperienceGuidelinesStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return {
	fetchDetailedGuidelines = function(p2, options)
		local v5 = options or {}
		local baseUrl = v5.baseUrl or urlBase.APIS
		return asPromise((fetch({
			network = v5.network,
			method = "POST",
			url = baseUrl .. "/experience-guidelines-service/v1beta1/detailed-guidelines",
			body = { universeId = p2 },
			analyticsKey = "experience-guidelines.get",
			decode = function(p3)
				return p3
			end
		})))
	end
}
