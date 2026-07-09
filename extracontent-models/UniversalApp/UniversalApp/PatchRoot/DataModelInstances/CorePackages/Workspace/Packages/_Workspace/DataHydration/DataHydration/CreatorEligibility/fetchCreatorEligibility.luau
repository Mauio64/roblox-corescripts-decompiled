local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local UrlBase = require(Parent.UrlBuilder).UrlBase

require(script.Parent.CreatorEligibilityStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return {
	fetchEligibility = function(n1: number, t1: {[any]: any}?) -- line: 20
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v8 = t1 or {}
		local v9 = v8.baseUrl or UrlBase.APIS
		local v10 = fetch({
			method = "GET",
			analyticsKey = "creator-eligibility.get",
			network = v8.network,
			url = ("%s/core-content/v1/creator-eligibility/%d"):format(v9, n1),
			decode = function(p1) -- line: 31
				return p1
			end
		})

		return asPromise(v10)
	end,
	isFlagPresent = function(p2, p3) -- line: 38
		return table.find(p2.creatorEligibility, p3) ~= nil
	end
}
