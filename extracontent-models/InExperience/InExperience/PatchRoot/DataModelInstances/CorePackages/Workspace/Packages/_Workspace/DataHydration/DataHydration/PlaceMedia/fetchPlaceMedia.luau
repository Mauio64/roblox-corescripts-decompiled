local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local UrlBase = require(Parent.UrlBuilder).UrlBase

require(script.Parent.PlaceMediaStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function mediaUrl(s1: string, n1: number) -- line: 17
	return ("%s/v1/places/%d/media"):format(s1, n1)
end

return {
	fetchMedia = function(n2: number, t1: {[any]: any}?) -- line: 23
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v11 = t1 or {}
		local v12 = v11.baseUrl or UrlBase.new("develop")
		local v13 = fetch({
			method = "GET",
			analyticsKey = "place-media.get",
			legacy = true,
			network = v11.network,
			url = ("%s/v1/places/%d/media"):format(v12, n2),
			decode = function(p1) -- line: 32
				return p1
			end
		})

		return asPromise(v13)
	end
}
