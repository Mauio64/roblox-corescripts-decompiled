local module = require("@luauforge/bundled/dTq")
local getSduiComponentRegistry = module.getSduiComponentRegistry
local sduiComponentType = module.SduiComponentType

local fFlagSduiCatalogVirtualizedFeed = require("@luauforge/bundled/dTo").FFlagSduiCatalogVirtualizedFeed
local fFlagSduiCatalogCategoryMenu = require("@luauforge/bundled/dTo").FFlagSduiCatalogCategoryMenu
local fFlagSduiMarketplaceCatalogSortSupport = require("@luauforge/bundled/dTo").FFlagSduiMarketplaceCatalogSortSupport
local fFlagSduiCatalogItemGrid = require("@luauforge/bundled/dTo").FFlagSduiCatalogItemGrid
local fFlagAXFavoritesManagerSdui = require("@luauforge/bundled/dTo").FFlagAXFavoritesManagerSdui
local fFlagSduiItemMediaHeader = require("@luauforge/bundled/dTo").FFlagSduiItemMediaHeader
local fFlagSduiCatalogItemCard = require("@luauforge/bundled/dTo").FFlagSduiCatalogItemCard

local function registerAvatarExperienceUiComponents()
	local v5 = {
		[sduiComponentType.CatalogCategoryMenu] = fFlagSduiCatalogCategoryMenu and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dUI")
			end
		} or nil,
		[sduiComponentType.CatalogVirtualizedFeed] = fFlagSduiCatalogVirtualizedFeed and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dUS")
			end
		} or nil,
		[sduiComponentType.CatalogItemCard] = fFlagSduiCatalogItemCard and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dUW")
			end
		} or nil,
		[sduiComponentType.CatalogItemGroup] = fFlagSduiMarketplaceCatalogSortSupport and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dUZ")
			end
		} or nil,
		[sduiComponentType.CatalogItemCarousel] = fFlagSduiMarketplaceCatalogSortSupport and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dVf")
			end
		} or nil,
		[sduiComponentType.CatalogItemGrid] = fFlagSduiCatalogItemGrid and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dVg")
			end
		} or nil,
		[sduiComponentType.ItemMediaHeader] = fFlagSduiItemMediaHeader and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dVh")
			end
		} or nil,
		[sduiComponentType.MarketplaceFavoritesCategoryMenu] = fFlagAXFavoritesManagerSdui and {
			getLazyComponent = function()
				return require("@luauforge/bundled/dVi")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerAvatarExperienceUiComponents
