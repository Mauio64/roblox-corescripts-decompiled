local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)
require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local catalogOffersBannerAppStorage = require(AvatarExperienceCatalog.Utils.catalogOffersBannerAppStorage)

local function useCatalogOffersBannerDismissHydration(p1, p2) -- line: 18
	-- upvalues: React (copy), catalogOffersBannerAppStorage (copy)
	React.useLayoutEffect(function() -- line: 22
		-- upvalues: p2 (copy), catalogOffersBannerAppStorage (copy), p1 (copy)
		if p2 == nil then
			return
		end

		if catalogOffersBannerAppStorage.shouldHydrateDismissed(p2) then
			p1.setDismissed(true)

			return
		end

		p1.setDismissed(false)
	end, {
		p2,
		p1
	})
end

return useCatalogOffersBannerDismissHydration
