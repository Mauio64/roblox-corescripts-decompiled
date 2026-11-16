local fFlagAXCatalogOffersBannerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogOffersBannerEnabled

local createAXShoppingCartStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createAXShoppingCartStore")
local createCatalogOffersBannerStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createCatalogOffersBannerStore")

local function getCatalogStores()
	local catalogStores = { shoppingCartStore = createAXShoppingCartStore(), catalogOffersBannerStore = 0 }
	local v5 = if fFlagAXCatalogOffersBannerEnabled then createCatalogOffersBannerStore() else nil
	catalogStores.catalogOffersBannerStore = v5
	return catalogStores
end

return getCatalogStores
