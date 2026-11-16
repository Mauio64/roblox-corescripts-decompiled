local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.PlaceMediaStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function mediaUrl(baseUrl: string, p: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/places/%d/media"):format(baseUrl, p)
end

return {
	fetchMedia = function(p: number, options)
		local v = options or {}
		local baseUrl = v.baseUrl or UrlBase.new("develop")
		return asPromise((fetch({
			network = v.network,
			method = "GET",
			url = mediaUrl(baseUrl, p), -- inferred equivalent call
			analyticsKey = "place-media.get",
			legacy = true,
			decode = function(p2)
				return p2
			end
		})))
	end
}
