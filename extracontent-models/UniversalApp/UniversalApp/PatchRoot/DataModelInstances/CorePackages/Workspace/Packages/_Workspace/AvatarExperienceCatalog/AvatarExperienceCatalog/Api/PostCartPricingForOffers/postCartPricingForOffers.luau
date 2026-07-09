local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local HttpService = game:GetService("HttpService")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeCartPricingForOffersResponse = require(script.Parent.normalizeCartPricingForOffersResponse)

require(script.Parent.CartPricingForOffersTypes)

local constants = require(script.Parent.constants)

local function postCartPricingForOffers(p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 31
	-- upvalues: Url (copy), constants (copy), HttpService (copy), makeAXResponseHandler (copy), normalizeCartPricingForOffersResponse (copy)
	local v11, v12 = p1(`{ Url.APIS_URL }{ constants.CART_PRICING_URL }`, "POST", {
		postBody = HttpService:JSONEncode(t1)
	})

	return makeAXResponseHandler(v11, normalizeCartPricingForOffersResponse, {
		modelMismatchCounter = constants.POST_CART_PRICING_FOR_OFFERS_MODEL_MISMATCH_COUNTER_NAME,
		latencyCounter = constants.POST_CART_PRICING_FOR_OFFERS_LATENCY_COUNTER_NAME
	}), v12
end

return postCartPricingForOffers
