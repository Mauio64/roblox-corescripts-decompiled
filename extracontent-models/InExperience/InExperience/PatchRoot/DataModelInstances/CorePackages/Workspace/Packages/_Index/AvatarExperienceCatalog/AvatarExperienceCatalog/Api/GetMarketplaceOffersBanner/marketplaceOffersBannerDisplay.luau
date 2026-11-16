require(script.Parent.MarketplaceOffersBannerTypes)

local function getMarketplaceOffersBannerOfferDisplayTitle(offer) -- 1 equivalent call inferred from this helper
	return offer.localizedText
end

local MarketplaceOffersBannerDisplay = {}
MarketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle = getMarketplaceOffersBannerOfferDisplayTitle

function MarketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId(p)
	return p.offerId
end

function MarketplaceOffersBannerDisplay.marketplaceOffersBannerPayloadHasRenderableOffer(p): boolean
	for _, offer in p.offers do
		if getMarketplaceOffersBannerOfferDisplayTitle(offer) ~= nil then -- inferred equivalent call
			return true
		end
	end

	return false
end

return MarketplaceOffersBannerDisplay
