local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")
local normalizeCartPricingForOffersResponse = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/PostCartPricingForOffers/normalizeCartPricingForOffersResponse")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/PostCartPricingForOffers/CartPricingForOffersTypes")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/PostCartPricingForOffers/constants")

local function postCartPricingForOffers(callback, p2)
	local v5, v6 = callback(`{url.APIS_URL}{module3.CART_PRICING_URL}`, "POST", {
		postBody = HttpService:JSONEncode(p2)
	})
	return
		makeAXResponseHandler(v5, normalizeCartPricingForOffersResponse, {
			modelMismatchCounter = constants.POST_CART_PRICING_FOR_OFFERS_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.POST_CART_PRICING_FOR_OFFERS_LATENCY_COUNTER_NAME
		}),
		v6
end

return postCartPricingForOffers
