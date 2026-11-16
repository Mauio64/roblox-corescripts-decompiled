local fFlagSduiMarketplaceCatalogActions = require("@luauforge/bundled/dPY").FFlagSduiMarketplaceCatalogActions
local fFlagAXFavoritesManagerSdui = require("@luauforge/bundled/dPY").FFlagAXFavoritesManagerSdui
local fFlagAXItemDetailsSduiActions = require("@luauforge/bundled/dPZ").FFlagAXItemDetailsSduiActions
local fFlagAXItemDetailsSduiFavorite = require("@luauforge/bundled/dPZ").FFlagAXItemDetailsSduiFavorite
local fFlagAXItemDetailsSduiBodyActions = require("@luauforge/bundled/dPZ").FFlagAXItemDetailsSduiBodyActions

local module = require("@luauforge/bundled/dQa")
local sduiActionType = module.SduiActionType
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry

local function registerAvatarExperienceActions()
	local v5 = {
		[sduiActionType.OpenMarketplaceCatalogFilters] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQb")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceCatalogCategory] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQf")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceCatalogSubcategory] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQi")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenMarketplaceCatalogSeeAll] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQj")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceFavoritesCategory] = fFlagAXFavoritesManagerSdui and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQk")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceFavoritesSubcategory] = fFlagAXFavoritesManagerSdui and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQn")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemDetails] = fFlagAXItemDetailsSduiActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQo")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenItemInfoRowPrompt] = fFlagAXItemDetailsSduiActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQT")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.ToggleCatalogItemFavorite] = fFlagAXItemDetailsSduiFavorite and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQU")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemCreatorProfile] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dQX")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemOwnership] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dRh")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemExperiences] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dRi")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.PlayCatalogItemAttributionExperience] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dRj")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemResellers] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dRk")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.TryOnCatalogItem] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dRl")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.PurchaseCatalogItemFromStock] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dRm")
			end,
			skipUnifiedLogging = true
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerAvatarExperienceActions
