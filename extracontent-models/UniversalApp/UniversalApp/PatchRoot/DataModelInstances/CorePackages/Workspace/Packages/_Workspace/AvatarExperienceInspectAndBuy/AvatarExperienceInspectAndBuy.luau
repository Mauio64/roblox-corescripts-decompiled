local scriptParent = script.Parent

require(script.Types)

local PriceStatus = require(script.Enums.PriceStatus)
local useViewBreakpoints = require(script.Hooks.useViewBreakpoints)
local useResponsivePanelLayoutProps = require(script.Components.useResponsivePanelLayoutProps)
local useInspectAndBuyFocusNavigation = require(script.Hooks.useInspectAndBuyFocusNavigation)
local ViewType = require(script.Enums.ViewType)
local InspectAndBuyVersion = require(script.Enums.InspectAndBuyVersion)
local Constants = require(script.Constants)
local FFlagSocialEnableProfileInspectAndBuy = require(scriptParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy
local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(scriptParent.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase

require(script.Stores.createItemSelectionStore)

return {
	Enums = {
		PriceStatus = PriceStatus,
		ViewType = ViewType,
		InspectAndBuyVersion = InspectAndBuyVersion
	},
	Utils = {
		getPriceStatus = require(script.Utils.getPriceStatus),
		getPriceStatusInShop = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.Utils.getPriceStatusInShop),
		getPriceLineContent = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.Utils.getPriceLineContent),
		getViewType = require(script.Utils.getViewType),
		applyTryOnItemToHumanoidDescription = require(script.Utils.applyTryOnItemToHumanoidDescription),
		convertAssetInfoToItemData = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else require(script.Utils.convertAssetInfoToItemData),
		convertBundleInfoToItemData = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else require(script.Utils.convertBundleInfoToItemData),
		itemDetailsUtils = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else require(script.Utils.itemDetailsUtils),
		buildBulkPurchaseAnalyticsPayload = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else require(script.Utils.buildBulkPurchaseAnalyticsPayload)
	},
	Hooks = {
		useViewBreakpoints = useViewBreakpoints,
		useResponsivePanelLayoutProps = useResponsivePanelLayoutProps,
		useInspectAndBuyFocusNavigation = useInspectAndBuyFocusNavigation
	},
	Components = {
		BuyActionBar = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(script.Components.Common.BuyActionBar),
		ResponsivePanelLayout = require(script.Components.Common.ResponsivePanelLayout)
	},
	Contexts = {
		ItemSelectionStoreContext = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else require(script.Contexts.ItemSelectionStoreContext)
	},
	Constants = Constants,
	["jest.config"] = script["jest.config"]
}
