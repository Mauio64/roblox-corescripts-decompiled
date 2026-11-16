local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)
require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)
local catalogOffersBannerAppStorage = require(AvatarExperienceCatalog.Utils.catalogOffersBannerAppStorage)

local function useCatalogOffersBannerDismissHydration(p, p2)
	React.useLayoutEffect(function()
		if p2 == nil then
			return
		end

		if catalogOffersBannerAppStorage.shouldHydrateDismissed(p2) then
			p.setDismissed(true)
		else
			p.setDismissed(false)
		end
	end, { p2, p })
end

return useCatalogOffersBannerDismissHydration
