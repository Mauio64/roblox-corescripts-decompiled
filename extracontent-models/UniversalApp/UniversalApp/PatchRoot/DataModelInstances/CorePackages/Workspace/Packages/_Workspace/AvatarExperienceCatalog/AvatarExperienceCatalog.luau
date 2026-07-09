local getWidgetListInfo = require(script.Api.GetWidgetListInfo.getWidgetListInfo)
local getWidgetListInfoSearch = require(script.Api.GetWidgetListInfo.getWidgetListInfoSearch)
local getLooksFromWidgetListInfo = require(script.Api.GetWidgetListInfo.getLooksFromWidgetListInfo)
local getCatalogV2SearchItemDetails = require(script.Api.GetCatalogV2SearchItemDetails.getCatalogV2SearchItemDetails)
local CatalogSearchAXPages = require(script.Api.GetCatalogV2SearchItemDetails.Types.CatalogSearchAXPages)

require(script.Api.GetCatalogV2SearchItemDetails.Types.AXPagesTypes)
require(script.Models.WidgetListInfo)
require(script.Models.CatalogV2SearchItemDetails)
require(script.Components.ResultsList.WidgetListInfoViewModel)

local useWidgetListInfoViewModel = require(script.Components.ResultsList.useWidgetListInfoViewModel)
local WidgetListBreakPointEnum = require(script.Components.ResultsList.WidgetListBreakPointEnum)
local WidgetListBreakPointThresholds = require(script.Components.ResultsList.WidgetListBreakPointThresholds)
local WidgetListBreakPointSizeMap = require(script.Components.ResultsList.WidgetListBreakPointSizeMap)
local WidgetIxpLayerMap = require(script.Utils.WidgetIxpLayerMap)
local getFooterVisibilityFromItemFooters = require(script.Utils.getFooterVisibilityFromItemFooters)
local PurchaseItemsSuccess = require(script.State.Actions.PurchaseItemsSuccess)
local FetchAssetOrBundleInfoBatchedSuccess = require(script.State.Actions.FetchAssetOrBundleInfoBatchedSuccess)
local FetchCollectibleItemDataBatchedSuccess = require(script.State.Actions.FetchCollectibleItemDataBatchedSuccess)
local SetSelectedTimedOption = require(script.State.Actions.SetSelectedTimedOption)
local SetLastToggledLookType = require(script.State.Actions.SetLastToggledLookType)
local getCatalogCategories = require(script.Api.GetCatalogCategories.getCatalogCategories)
local getFaeStatus = require(script.Api.GetFaeStatus.getFaeStatus).getFaeStatus

require(script.Api.GetFaeStatus.normalizeFaeStatus)

local SaveAsMakeupLookThunk = require(script.State.Thunks.SaveAsMakeupLookThunk)
local GetAXMarketplaceWidgetStore = require(script.Stores.GetAXMarketplaceWidgetStore)
local GetCatalogPageRequestIdStore = require(script.Stores.GetCatalogPageRequestIdStore)
local WidgetConstants = require(script.WidgetConstants)

require(script.Stores)

return {
	Api = {
		getWidgetListInfo = getWidgetListInfo,
		getWidgetListInfoSearch = getWidgetListInfoSearch,
		getLooksFromWidgetListInfo = getLooksFromWidgetListInfo,
		getCatalogV2SearchItemDetails = getCatalogV2SearchItemDetails.getCatalogV2SearchItemDetails,
		CatalogSearchAXPages = CatalogSearchAXPages,
		getCatalogCategories = getCatalogCategories.getCatalogCategories,
		getFaeStatus = getFaeStatus
	},
	Components = {
		CatalogSduiFeedEntryPoint = require(script.Sdui.CatalogSduiFeedEntryPoint),
		CatalogSduiCategoryMenuEntryPoint = require(script.Sdui.CatalogSduiCategoryMenuEntryPoint),
		MarketplaceFeedSkeleton = require(script.Components.MarketplaceFeedSkeleton.MarketplaceFeedSkeleton),
		MarketplaceCategoryMenuSkeleton = require(script.Components.MarketplaceCategoryMenuSkeleton.MarketplaceCategoryMenuSkeleton),
		CatalogOffersBanner = require(script.Components.CatalogOffersBanner.CatalogOffersBanner),
		CatalogItemGroupSort = {
			CatalogItemGroupSortContainer = require(script.Components.CatalogItemGroupSort.CatalogItemGroupSortContainer),
			CatalogItemGroupSortView = require(script.Components.CatalogItemGroupSort.CatalogItemGroupSortView),
			useCatalogItemGroupSortViewModel = require(script.Components.CatalogItemGroupSort.useCatalogItemGroupSortViewModel)
		},
		CatalogItemCarouselSort = {
			CatalogItemCarouselSortContainer = require(script.Components.CatalogItemCarouselSort.CatalogItemCarouselSortContainer),
			CatalogItemCarouselSortView = require(script.Components.CatalogItemCarouselSort.CatalogItemCarouselSortView),
			useCatalogItemCarouselSortViewModel = require(script.Components.CatalogItemCarouselSort.useCatalogItemCarouselSortViewModel)
		},
		Checkout = {
			CheckoutPage = require(script.Components.Checkout.CheckoutPage),
			CheckoutPageContainer = require(script.Components.Checkout.CheckoutPageContainer),
			CheckoutActionBarContainer = require(script.Components.Checkout.CheckoutActionBarContainer),
			OwnedActionBar = require(script.Components.Checkout.OwnedActionBar)
		},
		ResultsList = {
			useWidgetListInfoViewModel = useWidgetListInfoViewModel,
			WidgetListBreakPointEnum = WidgetListBreakPointEnum,
			WidgetListBreakPointThresholds = WidgetListBreakPointThresholds,
			WidgetListBreakPointSizeMap = WidgetListBreakPointSizeMap
		},
		Prompts = {
			ClearAllItemsOnAvatarPrompt = require(script.Components.Prompts.ClearAllItemsOnAvatarPrompt),
			WearAvatarReplaceAllItemsPrompt = require(script.Components.Prompts.WearAvatarReplaceAllItemsPrompt),
			CartUnavailableItemsPrompt = require(script.Components.Prompts.CartUnavailableItemsPrompt),
			GoToCustomizeToEditPrompt = require(script.Components.Prompts.GoToCustomizeToEditPrompt),
			ItemReplacedOnAvatarPrompt = require(script.Components.Prompts.ItemReplacedOnAvatarPrompt),
			ItemsUnavailablePrompt = require(script.Components.Prompts.ItemsUnavailablePrompt),
			TimeoutStatusPrompt = require(script.Components.Prompts.TimeoutStatusPrompt)
		}
	},
	Constants = require(script.Constants),
	WidgetConstants = WidgetConstants,
	Enums = {
		WearTimeFTUXStatusSessionEnum = require(script.Enums.WearTimeFTUXStatusSessionEnum)
	},
	Hooks = {
		useMultiItemShoppingFtux = require(script.Hooks.useMultiItemShoppingFtux),
		useCatalogPageTimeoutPrompt = require(script.Hooks.useCatalogPageTimeoutPrompt),
		useMakeupFtux = require(script.Hooks.useMakeupFtux),
		useMakeupLayeringTooltip = require(script.Hooks.useMakeupLayeringTooltip),
		useCatalogPageMakeupReleaseFtux = require(script.Hooks.useCatalogPageMakeupReleaseFtux),
		useWidgetItemImpressions = require(script.Hooks.useWidgetItemImpressions),
		useWidgetItemPayload = require(script.Hooks.useWidgetItemPayload),
		useAddUnifiedLoggingToCatalogSortEffect = require(script.Components.Hooks.useAddUnifiedLoggingToCatalogSortEffect),
		useShouldFetchCartPricingForPurchasePrompt = require(script.Hooks.useShouldFetchCartPricingForPurchasePrompt),
		useShouldFetchCartPricingForLookPurchasePrompt = require(script.Hooks.useShouldFetchCartPricingForLookPurchasePrompt)
	},
	Utils = {
		WidgetIxpLayerMap = WidgetIxpLayerMap,
		getFooterVisibilityFromItemFooters = getFooterVisibilityFromItemFooters,
		getBreakpointFromRowWidth = require(script.Utils.getBreakpointFromRowWidth),
		getUIScaleFromTokens = require(script.Utils.getUIScaleFromTokens),
		getShouldPageUseWidgetOnlyFetcher = require(script.Utils.getShouldPageUseWidgetOnlyFetcher),
		TryOns = {
			getFilteredTryOnItems = require(script.Utils.TryOns.getFilteredTryOnItems),
			getTryOnItemComparisonData = require(script.Utils.TryOns.getTryOnItemComparisonData),
			getShouldReplaceTryOn = require(script.Utils.TryOns.getShouldReplaceTryOn),
			getEquippableAssetsFromTryOnItems = require(script.Utils.TryOns.getEquippableAssetsFromTryOnItems),
			getDoesBundleHaveClothingOrAccessories = require(script.Utils.TryOns.getDoesBundleHaveClothingOrAccessories),
			removeMakeupAssetsFromTryOnsIfOverLimit = require(script.Utils.TryOns.removeMakeupAssetsFromTryOnsIfOverLimit),
			getTryOnItemsContainsOnlyMakeupTypes = require(script.Utils.TryOns.getTryOnItemsContainsOnlyMakeupTypes)
		}
	},
	Context = {
		AXCatalogStoreContext = require(script.Context.AXCatalogStoreContext),
		useAXCatalogStoreContext = require(script.Context.useAXCatalogStoreContext)
	},
	Providers = {
		CatalogPageMonolithDependenciesContext = require(script.Providers.CatalogPageMonolithDependenciesContext)
	},
	Stores = {
		getCatalogStores = require(script.Stores),
		getAXMarketplaceWidgetStore = GetAXMarketplaceWidgetStore,
		getCatalogPageRequestIdStore = GetCatalogPageRequestIdStore
	},
	State = {
		Actions = {
			PurchaseItemsSuccess = PurchaseItemsSuccess,
			FetchAssetOrBundleInfoBatchedSuccess = FetchAssetOrBundleInfoBatchedSuccess,
			FetchCollectibleItemDataBatchedSuccess = FetchCollectibleItemDataBatchedSuccess,
			SetSelectedTimedOption = SetSelectedTimedOption,
			SetLastToggledLookType = SetLastToggledLookType
		},
		Selectors = {
			selectHydratedWidgetData = require(script.State.Selectors.selectHydratedWidgetData)
		}
	},
	Sdui = {
		fetchCatalogPage = require(script.Sdui.fetchCatalogPage),
		CatalogSduiPageContext = require(script.Sdui.CatalogSduiPageContext),
		getCatalogConfigKey = require(script.Sdui.Utils.getCatalogConfigKey),
		getCatalogPageIdentifier = require(script.Sdui.Utils.getCatalogPageIdentifier),
		buildOrderedWidgetsFromCatalogPage = require(script.Sdui.buildOrderedWidgetsFromCatalogPage),
		hydrateCatalogSortEntities = require(script.Sdui.hydrateCatalogSortEntities),
		hydrateCatalogSortById = require(script.Sdui.hydrateCatalogSortById),
		buildFocusedSortWidgetInfo = require(script.Sdui.buildFocusedSortWidgetInfo),
		useApplySduiFocusedSort = require(script.Sdui.useApplySduiFocusedSort),
		useClearSduiFocusedSort = require(script.Sdui.useClearSduiFocusedSort),
		createMapMarketplaceCategoryToCatalogCategory = require(script.Sdui.createMapMarketplaceCategoryToCatalogCategory)
	},
	Thunks = {
		SaveAsMakeupLookThunk = SaveAsMakeupLookThunk
	},
	["jest.config"] = script["jest.config"]
}
