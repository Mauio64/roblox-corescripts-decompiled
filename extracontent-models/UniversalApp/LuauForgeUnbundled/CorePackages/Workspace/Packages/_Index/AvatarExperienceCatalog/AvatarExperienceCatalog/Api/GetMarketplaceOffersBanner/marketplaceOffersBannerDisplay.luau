require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")

return {
	getMarketplaceOffersBannerOfferDisplayTitle = function(p2)
		return p2.localizedText
	end,
	getMarketplaceOffersBannerOfferDisplayId = function(p2)
		return p2.offerId
	end,
	marketplaceOffersBannerPayloadHasRenderableOffer = function(p2): boolean
		for k, offer in p2.offers do
			if offer.localizedText ~= nil then
				return true
			end
		end

		return false
	end
}
