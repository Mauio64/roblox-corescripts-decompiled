local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local UrlBase = require(Parent.UrlBuilder).UrlBase

require(script.Parent.ExperienceGuidelinesStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return {
	fetchDetailedGuidelines = function(n1: number, t1: {[any]: any}?) -- line: 22
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v8 = t1 or {}
		local v9 = v8.baseUrl or UrlBase.APIS
		local v10 = fetch({
			method = "POST",
			analyticsKey = "experience-guidelines.get",
			network = v8.network,
			url = v9 .. "/experience-guidelines-service/v1beta1/detailed-guidelines",
			body = {
				universeId = n1
			},
			decode = function(p1) -- line: 34
				return p1
			end
		})

		return asPromise(v10)
	end
}
