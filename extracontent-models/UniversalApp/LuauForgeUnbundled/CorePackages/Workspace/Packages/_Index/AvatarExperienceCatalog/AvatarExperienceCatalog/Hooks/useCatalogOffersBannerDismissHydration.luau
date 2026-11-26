local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createCatalogOffersBannerStore")
local catalogOffersBannerAppStorage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/catalogOffersBannerAppStorage")

local function useCatalogOffersBannerDismissHydration(p2, p3)
	React.useLayoutEffect(function()
		if p3 == nil then
			return
		end

		if catalogOffersBannerAppStorage.shouldHydrateDismissed(p3) then
			p2.setDismissed(true)
		else
			p2.setDismissed(false)
		end
	end, { p3, p2 })
end

return useCatalogOffersBannerDismissHydration
