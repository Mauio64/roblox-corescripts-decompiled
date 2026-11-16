local module = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/getWidgetListInfo")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/getWidgetListInfoSearch")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/getLooksFromWidgetListInfo")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/getCatalogV2SearchItemDetails")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/Types/CatalogSearchAXPages")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/Types/AXPagesTypes")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/TrackSponsoredItemClick/trackSponsoredItemClick")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/CatalogV2SearchItemDetails")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/useWidgetListInfoViewModel")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointThresholds")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointSizeMap")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/WidgetIxpLayerMap")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getFooterVisibilityFromItemFooters")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Actions/PurchaseItemsSuccess")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Actions/FetchAssetOrBundleInfoBatchedSuccess")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Actions/FetchCollectibleItemDataBatchedSuccess")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Actions/SetSelectedTimedOption")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogCategories/getCatalogCategories")
local getFaeStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetFaeStatus/getFaeStatus").getFaeStatus
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetFaeStatus/normalizeFaeStatus")
local module18 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Thunks/SaveAsMakeupLookThunk")

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter
local module19 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/addSpecialFeaturesFilter")

local GetAXMarketplaceWidgetStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetAXMarketplaceWidgetStore")
local GetAvatarsTabSearchInfoStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetAvatarsTabSearchInfoStore")
local GetCatalogPageRequestIdStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetCatalogPageRequestIdStore")
local module23 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetFaeFeatureAccessStore")
local module24 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/WidgetConstants")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores")

local v6 = {
	getWidgetListInfo = module,
	getWidgetListInfoSearch = module2,
	getLooksFromWidgetListInfo = module3,
	getCatalogV2SearchItemDetails = module4.getCatalogV2SearchItemDetails,
	CatalogSearchAXPages = module5,
	getCatalogCategories = module17.getCatalogCategories,
	getFaeStatus = getFaeStatus,
	trackSponsoredItemClick = module6,
	addSpecialFeaturesFilter = 0
}

if not fFlagAXCatalogSpecialFeaturesFilter then
	module19 = nil
end

v6.addSpecialFeaturesFilter = module19
return {
	Api = v6,
	Components = {
		CatalogSduiFeedEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiFeedEntryPoint"),
		CatalogSduiCategoryMenuEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiCategoryMenuEntryPoint"),
		MarketplaceFeedSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/MarketplaceFeedSkeleton/MarketplaceFeedSkeleton"),
		MarketplaceCategoryMenuSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/MarketplaceCategoryMenuSkeleton/MarketplaceCategoryMenuSkeleton"),
		CatalogOffersBanner = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/CatalogOffersBanner"),
		CatalogItemGroupSort = {
			CatalogItemGroupSortContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemGroupSort/CatalogItemGroupSortContainer"),
			CatalogItemGroupSortView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemGroupSort/CatalogItemGroupSortView"),
			useCatalogItemGroupSortViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemGroupSort/useCatalogItemGroupSortViewModel")
		},
		CatalogItemCarouselSort = {
			CatalogItemCarouselSortContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemCarouselSort/CatalogItemCarouselSortContainer"),
			CatalogItemCarouselSortView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemCarouselSort/CatalogItemCarouselSortView"),
			useCatalogItemCarouselSortViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemCarouselSort/useCatalogItemCarouselSortViewModel")
		},
		Checkout = {
			CheckoutPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutPage"),
			CheckoutPageContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutPageContainer"),
			CheckoutActionBarContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutActionBarContainer"),
			OwnedActionBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/OwnedActionBar")
		},
		ResultsList = {
			useWidgetListInfoViewModel = module7,
			WidgetListBreakPointEnum = module8,
			WidgetListBreakPointThresholds = module9,
			WidgetListBreakPointSizeMap = module10,
			getOrderedWidgets = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/getOrderedWidgets")
		},
		WidgetPanelContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/WidgetPanel/WidgetPanelContainer"),
		Prompts = {
			ClearAllItemsOnAvatarPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/ClearAllItemsOnAvatarPrompt"),
			WearAvatarReplaceAllItemsPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/WearAvatarReplaceAllItemsPrompt"),
			CartUnavailableItemsPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/CartUnavailableItemsPrompt"),
			GoToCustomizeToEditPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/GoToCustomizeToEditPrompt"),
			ItemReplacedOnAvatarPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/ItemReplacedOnAvatarPrompt"),
			ItemsUnavailablePrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/ItemsUnavailablePrompt"),
			TimeoutStatusPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Prompts/TimeoutStatusPrompt")
		}
	},
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants"),
	WidgetConstants = module24,
	Hooks = {
		useMultiItemShoppingFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMultiItemShoppingFtux"),
		useTimedOptionsFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useTimedOptionsFtux"),
		useCatalogPageTimeoutPrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useCatalogPageTimeoutPrompt"),
		useMakeupFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMakeupFtux"),
		useMakeupLayeringTooltip = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMakeupLayeringTooltip"),
		useCatalogPageMakeupReleaseFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useCatalogPageMakeupReleaseFtux"),
		useWidgetItemImpressions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useWidgetItemImpressions"),
		useWidgetItemPayload = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useWidgetItemPayload"),
		useAddUnifiedLoggingToCatalogSortEffect = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useAddUnifiedLoggingToCatalogSortEffect"),
		useHydrateCatalogSortOnDemandEffect = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useHydrateCatalogSortOnDemandEffect"),
		useHydrateCatalogItemGridOnDemandEffect = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useHydrateCatalogItemGridOnDemandEffect"),
		useShouldFetchCartPricingForPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useShouldFetchCartPricingForPurchasePrompt"),
		useShouldFetchCartPricingForLookPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useShouldFetchCartPricingForLookPurchasePrompt"),
		useOnRequestImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useOnRequestImpressionsSignal")
	},
	Utils = {
		WidgetIxpLayerMap = module11,
		getFooterVisibilityFromItemFooters = module12,
		resolveWidgetListItemBottomPaddingPx = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/resolveWidgetListItemBottomPaddingPx"),
		getBreakpointFromRowWidth = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getBreakpointFromRowWidth"),
		getUIScaleFromTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getUIScaleFromTokens"),
		getShouldPageUseWidgetOnlyFetcher = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getShouldPageUseWidgetOnlyFetcher"),
		logEditorTaxonomyExposureIfApplicable = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/logEditorTaxonomyExposureIfApplicable"),
		TryOns = {
			getEquippableAssetsFromTryOnItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/TryOns/getEquippableAssetsFromTryOnItems"),
			getDoesBundleHaveClothingOrAccessories = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/TryOns/getDoesBundleHaveClothingOrAccessories"),
			getTryOnItemsContainsOnlyMakeupTypes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/TryOns/getTryOnItemsContainsOnlyMakeupTypes")
		}
	},
	Context = {
		AXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/AXCatalogStoreContext"),
		useAXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/useAXCatalogStoreContext")
	},
	Providers = { CatalogPageMonolithDependenciesContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/CatalogPageMonolithDependenciesContext") },
	Stores = {
		getCatalogStores = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores"),
		getAXMarketplaceWidgetStore = GetAXMarketplaceWidgetStore,
		getAvatarsTabSearchInfoStore = GetAvatarsTabSearchInfoStore,
		getCatalogPageRequestIdStore = GetCatalogPageRequestIdStore,
		GetFaeFeatureAccessStore = module23
	},
	State = {
		Actions = {
			PurchaseItemsSuccess = module13,
			FetchAssetOrBundleInfoBatchedSuccess = module14,
			FetchCollectibleItemDataBatchedSuccess = module15,
			SetSelectedTimedOption = module16
		},
		Selectors = { selectHydratedWidgetData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedWidgetData") }
	},
	Sdui = {
		fetchCatalogPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/fetchCatalogPage"),
		CatalogSduiPageContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiPageContext"),
		getCatalogConfigKey = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogConfigKey"),
		getCatalogPageIdentifier = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogPageIdentifier"),
		buildOrderedWidgetsFromCatalogPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/buildOrderedWidgetsFromCatalogPage"),
		hydrateCatalogSortEntities = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/hydrateCatalogSortEntities"),
		hydrateCatalogSortById = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/hydrateCatalogSortById"),
		buildFocusedSortWidgetInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/buildFocusedSortWidgetInfo"),
		resolveSduiFocusedSortContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/resolveSduiFocusedSortContext"),
		useApplySduiFocusedSort = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/useApplySduiFocusedSort"),
		useClearSduiFocusedSort = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/useClearSduiFocusedSort"),
		useCatalogSduiPageRequestId = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Hooks/useCatalogSduiPageRequestId"),
		createMapMarketplaceCategoryToCatalogCategory = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/createMapMarketplaceCategoryToCatalogCategory")
	},
	Thunks = { SaveAsMakeupLookThunk = module18 }
}
