local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeMarketplaceOffersBannerResponse = require(script.Parent.normalizeMarketplaceOffersBannerResponse)

require(script.Parent.MarketplaceOffersBannerTypes)

local constants = require(script.Parent.constants)

return {
	getMarketplaceOffersBanner = function(s1: string, p1: ((...any) -> ...any), s2: string?) -- line: 20
		-- upvalues: constants (copy), Url (copy), makeAXResponseHandler (copy), normalizeMarketplaceOffersBannerResponse (copy)
		local v10 = if s2 ~= "cart" then constants.OFFERS_FOR_USER_FEATURE_KEY_FEED else constants.OFFERS_FOR_USER_FEATURE_KEY_CART
		local v11 = Url:makeQueryString({
			userId = s1,
			featureKey = v10
		})
		local v12, v13 = p1(`{ Url.APIS_URL }{ constants.OFFERS_V1_RELATIVE_PATH }?{ v11 }`, "GET")

		return makeAXResponseHandler(v12, normalizeMarketplaceOffersBannerResponse, {
			modelMismatchCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_LATENCY_COUNTER_NAME
		}), v13
	end
}
