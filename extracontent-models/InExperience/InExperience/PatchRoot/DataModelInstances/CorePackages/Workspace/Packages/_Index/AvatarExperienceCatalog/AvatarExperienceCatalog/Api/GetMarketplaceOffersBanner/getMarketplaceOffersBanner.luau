local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeMarketplaceOffersBannerResponse = require(script.Parent.normalizeMarketplaceOffersBannerResponse)
require(script.Parent.MarketplaceOffersBannerTypes)
local constants = require(script.Parent.constants)

return {
	getMarketplaceOffersBanner = function(userId: string, callback, p: string?)
		local featureKey

		if p == "cart" then
			featureKey = constants.OFFERS_FOR_USER_FEATURE_KEY_CART
		else
			featureKey = constants.OFFERS_FOR_USER_FEATURE_KEY_FEED
		end

		local queryString = Url:makeQueryString({ userId = userId, featureKey = featureKey })

		local v, v2 = callback(`{Url.APIS_URL}{constants.OFFERS_V1_RELATIVE_PATH}?{queryString}`, "GET")
		return
			makeAXResponseHandler(v, normalizeMarketplaceOffersBannerResponse, {
				modelMismatchCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_LATENCY_COUNTER_NAME
			}),
			v2
	end
}
