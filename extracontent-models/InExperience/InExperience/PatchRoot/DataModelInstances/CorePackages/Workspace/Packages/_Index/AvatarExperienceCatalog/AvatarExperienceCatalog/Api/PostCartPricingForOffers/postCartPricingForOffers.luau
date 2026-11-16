local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local HttpService = game:GetService("HttpService")

local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeCartPricingForOffersResponse = require(script.Parent.normalizeCartPricingForOffersResponse)
require(script.Parent.CartPricingForOffersTypes)
local constants = require(script.Parent.constants)

local function postCartPricingForOffers(callback, p)
	local v, v2 = callback(`{Url.APIS_URL}{constants.CART_PRICING_URL}`, "POST", {
		postBody = HttpService:JSONEncode(p)
	})
	return
		makeAXResponseHandler(v, normalizeCartPricingForOffersResponse, {
			modelMismatchCounter = constants.POST_CART_PRICING_FOR_OFFERS_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.POST_CART_PRICING_FOR_OFFERS_LATENCY_COUNTER_NAME
		}),
		v2
end

return postCartPricingForOffers
