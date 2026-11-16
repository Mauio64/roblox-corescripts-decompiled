local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled

local createAXShoppingCartStore = require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)
local createCatalogOffersBannerStore = require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local function getCatalogStores()
	local catalogStores = {
		shoppingCartStore = createAXShoppingCartStore(),
		catalogOffersBannerStore = 0
	}
	local catalogOffersBannerStore

	if FFlagAXCatalogOffersBannerEnabled then
		catalogOffersBannerStore = createCatalogOffersBannerStore()
	end

	catalogStores.catalogOffersBannerStore = catalogOffersBannerStore
	return catalogStores
end

return getCatalogStores
