local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")
local normalizeMarketplaceOffersBannerResponse = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/normalizeMarketplaceOffersBannerResponse")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/constants")

return {
	getMarketplaceOffersBanner = function(p2, callback, p3)
		local v5

		if p3 == "cart" then
			v5 = constants.OFFERS_FOR_USER_FEATURE_KEY_CART
		else
			v5 = constants.OFFERS_FOR_USER_FEATURE_KEY_FEED
		end

		local queryString = url:makeQueryString({ userId = p2, featureKey = v5 })

		local v6, v7 = callback(`{url.APIS_URL}{module3.OFFERS_V1_RELATIVE_PATH}?{queryString}`, "GET")
		return
			makeAXResponseHandler(v6, normalizeMarketplaceOffersBannerResponse, {
				modelMismatchCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_MODEL_MISMATCH_COUNTER_NAME,
				latencyCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_LATENCY_COUNTER_NAME
			}),
			v7
	end
}
