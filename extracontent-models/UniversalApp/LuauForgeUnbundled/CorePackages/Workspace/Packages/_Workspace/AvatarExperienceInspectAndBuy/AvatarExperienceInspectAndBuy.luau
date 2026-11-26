require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useViewBreakpoints")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/useResponsivePanelLayoutProps")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useInspectAndBuyFocusNavigation")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/InspectAndBuyVersion")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Constants")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local fFlagAXIaBEnableShopContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXIaBEnableShopContext

local v5 = fFlagSocialEnableProfileInspectAndBuy or fFlagAXIaBEnableShopContext

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Stores/createItemSelectionStore")

local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getTryOnItemsTotalPrice")

local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/selectItemDataForTryOnItems")

local v7 = {
	getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus"),
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

local v8 = if v5 then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatusInShop") else nil
v7.getPriceStatusInShop = v8

local v9 = if v5 then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceLineContent") else nil
v7.getPriceLineContent = v9
v7.getViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getViewType")
v7.applyTryOnItemToHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/applyTryOnItemToHumanoidDescription")
v7.convertAssetInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertAssetInfoToItemData")
v7.convertBundleInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertBundleInfoToItemData")
v7.itemDetailsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils")
v7.buildBulkPurchaseAnalyticsPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/buildBulkPurchaseAnalyticsPayload")
v7.buildItemDataFromAXRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/buildItemDataFromAXRodux")
v7.getTryOnItemsTotalPrice = module9
v7.selectItemDataForTryOnItems = module10
v7.formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/formatNumber")
return {
	Enums = { PriceStatus = module, ViewType = module5, InspectAndBuyVersion = module6 },
	Utils = v7,
	Hooks = {
		useViewBreakpoints = module2,
		useResponsivePanelLayoutProps = module3,
		useInspectAndBuyFocusNavigation = module4
	},
	Components = {
		BuyActionBar = module8,
		ResponsivePanelLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/ResponsivePanelLayout"),
		SelectableItemCardRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SelectableItemCardRow/SelectableCardRowContainer"),
		SelectableItemCardList = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SelectableItemCardList/SelectableItemCardList")
	},
	Contexts = { ItemSelectionStoreContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Contexts/ItemSelectionStoreContext") },
	Constants = module7
}
