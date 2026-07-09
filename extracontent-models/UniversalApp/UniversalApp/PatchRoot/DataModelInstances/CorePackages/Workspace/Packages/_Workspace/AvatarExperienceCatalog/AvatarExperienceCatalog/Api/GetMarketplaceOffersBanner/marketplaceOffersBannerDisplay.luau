require(script.Parent.MarketplaceOffersBannerTypes)

return {
	getMarketplaceOffersBannerOfferDisplayTitle = function(p1) -- line: 6
		return p1.localizedText
	end,
	getMarketplaceOffersBannerOfferDisplayId = function(p2) -- line: 10
		return p2.offerId
	end,
	marketplaceOffersBannerPayloadHasRenderableOffer = function(p3) -- line: 14
		for _, v5 in p3.offers do
			if v5.localizedText ~= nil then
				return true
			end
		end

		return false
	end
}
