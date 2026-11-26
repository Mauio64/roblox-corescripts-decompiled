local fFlagSduiMarketplaceCatalogActions = require("@luauforge/bundled/dTo").FFlagSduiMarketplaceCatalogActions
local fFlagAXFavoritesManagerSdui = require("@luauforge/bundled/dTo").FFlagAXFavoritesManagerSdui
local fFlagAXItemDetailsSduiActions = require("@luauforge/bundled/dTp").FFlagAXItemDetailsSduiActions
local fFlagAXItemDetailsSduiFavorite = require("@luauforge/bundled/dTp").FFlagAXItemDetailsSduiFavorite
local fFlagAXItemDetailsSduiBodyActions = require("@luauforge/bundled/dTp").FFlagAXItemDetailsSduiBodyActions
local fFlagAXSduiClaimEventItemAction = require("@luauforge/bundled/dTp").FFlagAXSduiClaimEventItemAction

local module = require("@luauforge/bundled/dTq")
local sduiActionType = module.SduiActionType
local getSduiActionHandlerRegistry = module.getSduiActionHandlerRegistry

local function registerAvatarExperienceActions()
	local v5 = {
		[sduiActionType.OpenMarketplaceCatalogFilters] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTr")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceCatalogCategory] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTv")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceCatalogSubcategory] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTy")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenMarketplaceCatalogSeeAll] = fFlagSduiMarketplaceCatalogActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTz")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceFavoritesCategory] = fFlagAXFavoritesManagerSdui and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTA")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.SelectMarketplaceFavoritesSubcategory] = fFlagAXFavoritesManagerSdui and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTD")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemDetails] = fFlagAXItemDetailsSduiActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dTE")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenItemInfoRowPrompt] = fFlagAXItemDetailsSduiActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUk")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.ToggleCatalogItemFavorite] = fFlagAXItemDetailsSduiFavorite and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUl")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemCreatorProfile] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUo")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemOwnership] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUy")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemExperiences] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUz")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.PlayCatalogItemAttributionExperience] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUA")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.OpenCatalogItemResellers] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUB")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.TryOnCatalogItem] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUC")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.PurchaseCatalogItemFromStock] = fFlagAXItemDetailsSduiBodyActions and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUD")
			end,
			skipUnifiedLogging = true
		} or nil,
		[sduiActionType.ClaimEventItem] = fFlagAXSduiClaimEventItemAction and {
			lazyHandler = function()
				return require("@luauforge/bundled/dUE")
			end,
			skipUnifiedLogging = false
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerAvatarExperienceActions
