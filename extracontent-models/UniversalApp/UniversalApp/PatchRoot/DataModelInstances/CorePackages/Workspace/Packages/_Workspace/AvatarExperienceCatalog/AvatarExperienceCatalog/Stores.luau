local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local FFlagAXCatalogOffersBannerEnabled = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogOffersBannerEnabled
local createAXShoppingCartStore = require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)
local createCatalogOffersBannerStore = require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local function getCatalogStores() -- line: 21
	-- upvalues: createAXShoppingCartStore (copy), FFlagAXCatalogOffersBannerEnabled (copy), createCatalogOffersBannerStore (copy)
	return {
		shoppingCartStore = createAXShoppingCartStore(),
		catalogOffersBannerStore = if not FFlagAXCatalogOffersBannerEnabled then nil else createCatalogOffersBannerStore()
	}
end

return getCatalogStores
