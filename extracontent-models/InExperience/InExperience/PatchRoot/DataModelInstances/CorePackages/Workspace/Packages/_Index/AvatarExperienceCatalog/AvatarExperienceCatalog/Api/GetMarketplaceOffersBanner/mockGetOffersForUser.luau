local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
require(parent.LuauPolyfill)
local Promise = require(parent.Promise)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
local normalizeMarketplaceOffersBannerResponse = require(script.Parent.normalizeMarketplaceOffersBannerResponse)
require(script.Parent.MarketplaceOffersBannerTypes)
local constants = require(script.Parent.constants)

local responseBody = {
	offers = {
		{
			icon = "Star",
			localizedText = "[Mock] <b>First offer</b> from getOffersForUser",
			offerId = "mock-offer-1",
			modal = {
				modalHeroIcon = "TagSparkle",
				modalTitle = "You unlocked 10% off!",
				offerBodyLinkText = "Up to <b>\\u{E002}20 off</b> your next avatar item purchase. Valid through <font color=\"#335FFF\">Dec 25</font>. Apply at checkout. One time use.",
				termsModalTitle = "Terms and conditions",
				termsBody = "<b>These Special Offer Terms</b> supplement the Roblox Terms of Use and Marketplace rules. Discounts are subject to availability, account standing, and regional restrictions."
			}
		},
		{
			icon = "TagSparkle",
			localizedText = "[Mock] Second offer from getOffersForUser",
			offerId = "mock-offer-2"
		},
		"not-a-table-row",
		{
			modal = {
				modalTitle = "Orphan modal",
				offerBodyLinkText = "This row has no icon/text/offerId so it gets dropped."
			}
		},
		{
			icon = "Star",
			localizedText = "[Mock] Fifth offer (bad modal swallowed)",
			offerId = "mock-offer-5",
			modal = { offerBodyLinkText = "Missing modalTitle so this modal is dropped silently." }
		}
	}
}

return {
	mockGetOffersForUser = function()
		local flag = false

		return makeAXResponseHandler(Promise.new(function(callback)
			task.delay(2, function()
				if flag then
					callback(nil)
				else
					callback({ responseBody = responseBody })
				end
			end)
		end), normalizeMarketplaceOffersBannerResponse, {
			modelMismatchCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_MARKETPLACE_OFFERS_BANNER_LATENCY_COUNTER_NAME
		}), function()
			flag = true
		end
	end
}
