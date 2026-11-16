local parent = script.Parent
require(script.Types)
local PriceStatus = require(script.Enums.PriceStatus)
local useViewBreakpoints = require(script.Hooks.useViewBreakpoints)
local useResponsivePanelLayoutProps = require(script.Components.useResponsivePanelLayoutProps)
local useInspectAndBuyFocusNavigation = require(script.Hooks.useInspectAndBuyFocusNavigation)
local ViewType = require(script.Enums.ViewType)
local InspectAndBuyVersion = require(script.Enums.InspectAndBuyVersion)
local Constants = require(script.Constants)
local BuyActionBar = require(script.Components.Common.BuyActionBar)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags.FFlagSocialEnableProfileInspectAndBuy
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXIaBEnableShopContext = AvatarExperienceFlags.FFlagAXIaBEnableShopContext

local v = FFlagSocialEnableProfileInspectAndBuy or FFlagAXIaBEnableShopContext

require(script.Stores.createItemSelectionStore)

local getTryOnItemsTotalPrice = require(script.Utils.getTryOnItemsTotalPrice)

local selectItemDataForTryOnItems = require(script.Utils.selectItemDataForTryOnItems)

local utils = {
	getPriceStatus = require(script.Utils.getPriceStatus),
	getPriceStatusInShop = 0,
	getPriceLineContent = 0,
	getViewType = 0,
	applyTryOnItemToHumanoidDescription = 0,
	convertAssetInfoToItemData = 0,
	convertBundleInfoToItemData = 0,
	itemDetailsUtils = 0,
	buildBulkPurchaseAnalyticsPayload = 0,
	buildItemDataFromAXRodux = 0,
	getTryOnItemsTotalPrice = 0,
	selectItemDataForTryOnItems = 0,
	formatNumber = 0
}
local getPriceStatusInShop

if v then
	getPriceStatusInShop = require(script.Utils.getPriceStatusInShop)
end

utils.getPriceStatusInShop = getPriceStatusInShop
local getPriceLineContent

if v then
	getPriceLineContent = require(script.Utils.getPriceLineContent)
end

utils.getPriceLineContent = getPriceLineContent
utils.getViewType = require(script.Utils.getViewType)
utils.applyTryOnItemToHumanoidDescription = require(script.Utils.applyTryOnItemToHumanoidDescription)
utils.convertAssetInfoToItemData = require(script.Utils.convertAssetInfoToItemData)
utils.convertBundleInfoToItemData = require(script.Utils.convertBundleInfoToItemData)
utils.itemDetailsUtils = require(script.Utils.itemDetailsUtils)
utils.buildBulkPurchaseAnalyticsPayload = require(script.Utils.buildBulkPurchaseAnalyticsPayload)
utils.buildItemDataFromAXRodux = require(script.Utils.buildItemDataFromAXRodux)
utils.getTryOnItemsTotalPrice = getTryOnItemsTotalPrice
utils.selectItemDataForTryOnItems = selectItemDataForTryOnItems
utils.formatNumber = require(script.Utils.formatNumber)
return {
	Enums = {
		PriceStatus = PriceStatus,
		ViewType = ViewType,
		InspectAndBuyVersion = InspectAndBuyVersion
	},
	Utils = utils,
	Hooks = {
		useViewBreakpoints = useViewBreakpoints,
		useResponsivePanelLayoutProps = useResponsivePanelLayoutProps,
		useInspectAndBuyFocusNavigation = useInspectAndBuyFocusNavigation
	},
	Components = {
		BuyActionBar = BuyActionBar,
		ResponsivePanelLayout = require(script.Components.Common.ResponsivePanelLayout),
		SelectableItemCardRow = require(script.Components.Common.SelectableItemCardRow.SelectableCardRowContainer),
		SelectableItemCardList = require(script.Components.Common.SelectableItemCardList.SelectableItemCardList)
	},
	Contexts = {
		ItemSelectionStoreContext = require(script.Contexts.ItemSelectionStoreContext)
	},
	Constants = Constants,
	["jest.config"] = script["jest.config"]
}
