local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/CatalogItemCard")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogRowItemCard/CatalogRowItemCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogRowItemCard/CatalogRowItemCardFooter")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemInfoEnum")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemTypeEnum")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/ItemRestrictions")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/ItemStatus")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/SalesLocationType")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CreatorType")

local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardStatusIconTypeEnum")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/ItemStatusTypeEnum")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/ColorGradientCircle/ColorGradientCircle")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/normalize")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AXPartialPageModal/AXPartialPageModal")
local BackgroundHighlightContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/BackgroundHighlight/BackgroundHighlightContainer")

local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/ContextualActionButton/ContextualActionButton")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/LicensingBadge/LicensingBadge")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectColorAdjustmentButtonColor")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTryOnBodyIds")
local module19 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectHasBodyTryOn")
local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectShowColorQuickButton")
local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectAvatarPreviewColors")
local module22 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectSearchKeyword")
local module23 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectCurrentAvatarRoute")
local module24 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectIsFullView")
local module25 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTopBarHeight")
local module26 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectEquippedAssets")
local module27 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectHasMakeupTryOn")
local module28 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTryOnItems")
local module29 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectCurrentAvatarEditorCategory")
local module30 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectEquippedLayeredMakeupAssets")
local module31 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTotalLayeredMakeupAssets")
local module32 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectHasDynamicHead")
local module33 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTryOnsLookId")
local module34 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/ItemData")

local module35 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/RobuxBalance/RobuxBalance")
local module36 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/AdjustmentType")
local module37 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CatalogSubcategories")
local module38 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CatalogCategoryIds")
local module39 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CatalogSubcategoryIds")
local module40 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CatalogSDUICategoryIds")
local CatalogCategoryKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CatalogCategoryKey")
local CatalogSubcategoryKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/CatalogSubcategoryKey")
local module43 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/NoPriceStatus")
local module44 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/ItemPurchaseActionTypeEnum")
local module45 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/FullView")
local module46 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/WearTimeFilter")
local module47 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/SpecialFeatureFilter")

local module48 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/CharacterHistoryStateChangeButtonActivated")

local module49 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useSelectorSignal")
local module50 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useSignal")
local module51 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useComputedSignal")
local module52 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/usePulseAnimationBinding")
local module53 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useArrowNavScrollBehavior")
local module54 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useCategoryPillColorAnimation")
local module55 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useSubcategoryPillAnimation")
local module56 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/AdaptiveScrollingContext")
local module57 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/withAdaptiveScrolling")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/createAnimatedVisibilityStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/AnimatedVisibilityContext")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CatalogCategoryTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/AvatarEditorCategoryTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/SharedCategoryTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/ButtonStackItemType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CommonTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/TimedOptionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/DiscountType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/AvatarColorTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/WidgetAnalyticsInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/WidgetInfoContextTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/ItemTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/PurchaseItemsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/TryOnItemComparisonData")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/types")

local module58 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getIsInsufficientRobuxError")

return {
	Components = {
		ArrowNavV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/ArrowNav/ArrowNavV2"),
		RobuxBalance = module35,
		AnimatedCategoryPill = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CategoryPill/AnimatedCategoryPill"),
		AnimatedSubcategoryPill = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CategoryPill/AnimatedSubcategoryPill"),
		CategoryPill = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CategoryPill/CategoryPill"),
		CategoryPillCloseButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CategoryPill/CategoryPillCloseButton"),
		ColorGradientCircle = module11,
		Overlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Overlay/Overlay"),
		FlexLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/FlexLayout/FlexLayout"),
		CatalogItemCard = {
			CatalogItemCardItemInfoEnum = module3,
			CatalogItemCardItemTypeEnum = module4,
			CatalogItemCardStatusIconTypeEnum = module9,
			ItemStatusTypeEnum = module10,
			CatalogItemCard = module,
			CatalogRowItemCard = module2
		},
		Filters = {
			CheckboxButtonItem = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Filters/CheckboxButtonItem"),
			CheckboxGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Filters/CheckboxGroup"),
			ExpandingFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Filters/ExpandingFrame")
		},
		ContextualActionButton = module15,
		LicensingBadge = module16,
		OfferExpiryBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/OfferExpiryBadge/OfferExpiryBadge"),
		AnimatedScrollingFrame = {
			useAXAnimateScrollFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AnimatedScrollingFrame/useAXAnimateScrollFrame"),
			AnimatedScrollingFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AnimatedScrollingFrame/AnimatedScrollingFrame")
		},
		AXPartialPageModal = module13,
		BackgroundHighlight = BackgroundHighlightContainer,
		wrapForReactPortal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Wrappers/wrapForReactPortal"),
		AXTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AXTooltip/AXTooltipContainer"),
		TimeoutBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/TimeoutBanner/TimeoutBannerContainer"),
		Prompts = { EnhancedAvatarHeadsFtuxPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/Prompts/EnhancedAvatarHeadsFtuxPrompt") }
	},
	Enums = {
		AdjustmentType = module36,
		OutfitTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/OutfitTypes"),
		ItemRestrictions = module5,
		ItemStatus = module6,
		SalesLocationType = module7,
		CreatorType = module8,
		NoPriceStatus = module43,
		ItemPurchaseActionTypeEnum = module44,
		CatalogSubcategories = module37,
		CatalogCategoryIds = module38,
		CatalogSubcategoryIds = module39,
		CatalogSDUICategoryIds = module40,
		CatalogCategoryKeys = CatalogCategoryKey,
		CatalogSubcategoryKeys = CatalogSubcategoryKey,
		FullView = module45,
		WearTimeFilter = module46,
		SpecialFeatureFilter = module47,
		DiscountTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/DiscountType")
	},
	Hooks = {
		useSelectorSignal = module49,
		useSignal = module50,
		useComputedSignal = module51,
		usePulseAnimationBinding = module52,
		useArrowNavScrollBehavior = module53,
		useCategoryPillColorAnimation = module54,
		useSubcategoryPillAnimation = module55,
		useRedirectFocusIntoGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useRedirectFocusIntoGuiObject"),
		useNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useNetworking"),
		useHydrateEquippedAvatarOutfitId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useHydrateEquippedAvatarOutfitId"),
		useFocusOnMountEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useFocusOnMountEffect"),
		useEnhancedAvatarHeadsFtux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useEnhancedAvatarHeadsFtux"),
		useAdaptiveScrolling = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useAdaptiveScrolling"),
		AdaptiveScrollingContext = module56,
		withAdaptiveScrolling = module57,
		useUnifiedImpressionExposer = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useUnifiedImpressionExposer"),
		useIsDirectional = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useIsDirectional"),
		useAvatarChangeAcknowledgementPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useAvatarChangeAcknowledgementPrompt"),
		useIsAvatarChangeTimeoutActive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useIsAvatarChangeTimeoutActive")
	},
	Lib = { SafeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Lib/SafeAppStorageService") },
	Experiments = {
		AXRecentlyViewedSearchItemsIXPTest = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Experiments/AXRecentlyViewedSearchItemsIXPTest"),
		AXAvatarsTabIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Experiments/AXAvatarsTabIXP")
	},
	State = {
		Selectors = {
			selectColorAdjustmentButtonColor = module17,
			selectTryOnBodyIds = module18,
			selectHasBodyTryOn = module19,
			selectShowColorQuickButton = module20,
			selectAvatarPreviewColors = module21,
			selectSearchKeyword = module22,
			selectCurrentAvatarRoute = module23,
			selectIsFullView = module24,
			selectTopBarHeight = module25,
			selectEquippedAssets = module26,
			selectHasMakeupTryOn = module27,
			selectTryOnItems = module28,
			selectCurrentAvatarEditorCategory = module29,
			selectEquippedLayeredMakeupAssets = module30,
			selectTotalLayeredMakeupAssets = module31,
			selectHasDynamicHead = module32,
			selectTryOnsLookId = module33,
			ItemData = module34
		},
		Actions = { CharacterHistoryStateChangeButtonActivated = module48 }
	},
	Stores = {
		AnimatedVisibilityStore = {
			createAnimatedVisibilityStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/createAnimatedVisibilityStore"),
			AnimatedVisibilityContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/AnimatedVisibilityContext"),
			AnimatedVisibilityProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/AnimatedVisibilityContextProvider"),
			useAnimatedVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AnimatedVisibilityStore/useAnimatedVisibility")
		},
		AvatarLastEquippedStateStore = {
			avatarLastEquippedStateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AvatarLastEquippedStateStore/avatarLastEquippedStateStore")
		},
		AXTooltipStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AXTooltipStore"),
		getApplyingLayeredClothingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/ApplyingLayeredClothingStore/getApplyingLayeredClothingStore"),
		getLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/LayeredClothingCurrentSortStore/getLayeredClothingCurrentSortStore"),
		getTimeoutStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/TimeoutStatusStore/getTimeoutStatusStore"),
		getAdjustmentTypeSelectedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AdjustmentTypeSelectedStore/getAdjustmentTypeSelectedStore"),
		getEquippedAvatarOutfitIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/EquippedAvatarOutfitIdStore/getEquippedAvatarOutfitIdStore")
	},
	Utils = {
		createSelectorSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/createSelectorSignal"),
		buildHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/buildHumanoidDescription"),
		getAssetIdToAssetTypeIdFromHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/getAssetIdToAssetTypeIdFromHumanoidDescription"),
		getHumanoidDescriptionFromState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/getHumanoidDescriptionFromState"),
		setHumanoidDescriptionColorsFromBodyColor3s = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setHumanoidDescriptionColorsFromBodyColor3s"),
		setMakeupDescriptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setMakeupDescriptions"),
		destroyMakeupDescriptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/destroyMakeupDescriptions"),
		getMakeupDescriptionsFromHumanoidDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/getMakeupDescriptionsFromHumanoidDescription"),
		createHumanoidDescriptionAccessoryInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/createHumanoidDescriptionAccessoryInfo"),
		getGearAssetIdFromEquippedAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getGearAssetIdFromEquippedAssets"),
		getEquippedLayeredMakeupAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getEquippedLayeredMakeupAssets"),
		getRbxThumbType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getRbxThumbType"),
		isVRHiddenRobuxBalanceScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isVRHiddenRobuxBalanceScreen"),
		normalize = module12,
		getRawItemLicensingInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getRawItemLicensingInfo"),
		parseItemLicensing = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/parseItemLicensing"),
		normalizeScreenSizeForWire = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/normalizeScreenSizeForWire"),
		debounce = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/debounce"),
		getZoomedSizeAndOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getZoomedSizeAndOffset"),
		getThumbSizeVectorFromParamString = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getThumbSizeVectorFromParamString"),
		getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getUseSelectorDeepEquals"),
		findItemInTryOnItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/findItemInTryOnItems"),
		getTryOnItemReducerKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getTryOnItemReducerKey"),
		getFilteredTryOnItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/TryOns/getFilteredTryOnItems"),
		getTryOnItemComparisonData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/TryOns/getTryOnItemComparisonData"),
		getShouldReplaceTryOn = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/TryOns/getShouldReplaceTryOn"),
		removeMakeupAssetsFromTryOnsIfOverLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/TryOns/removeMakeupAssetsFromTryOnsIfOverLimit"),
		getItemPurchaseActionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getItemPurchaseActionType"),
		RoactGamepadMigration = { findValueKeyInRefCache = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/RoactGamepadMigration/findValueKeyInRefCache") },
		getBackendLayerNamesForCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getBackendLayerNamesForCatalog"),
		getGearAssetIdFromState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getGearAssetIdFromState"),
		getEquippedAssetIdsForType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getEquippedAssetIdsForType"),
		isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType"),
		isMakeupOrEyebrowEyelashAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupOrEyebrowEyelashAssetType"),
		isLayeredClothingAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isLayeredClothingAssetType"),
		isDurableItemExpired = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isDurableItemExpired"),
		formatTimeoutEndTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/formatTimeoutEndTime"),
		showAvatarChangeFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/showAvatarChangeFeatureRestriction"),
		isOutfitNameValid = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isOutfitNameValid"),
		isValidAssetTypeForOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isValidAssetTypeForOutfitType"),
		getHumanoidDescriptionFromStateForOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/getHumanoidDescriptionFromStateForOutfitType"),
		getIsInsufficientRobuxError = module58,
		getInventoryOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getInventoryOutfitType"),
		getGrantedOutfitIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getGrantedOutfitIds")
	},
	Backgrounds = {
		loadBackgroundAsset = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/loadBackgroundAsset"),
		selectActiveBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/selectActiveBackground"),
		selectActiveBackgroundPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/selectActiveBackgroundPreview"),
		selectTryOnBackgroundId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/selectTryOnBackgroundId"),
		previewImageRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/previewImageRegistry"),
		buildOutfitProfileConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/buildOutfitProfileConfiguration"),
		normalizeBackgroundId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/normalizeBackgroundId"),
		getTemporaryPlusBackgroundIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/getTemporaryPlusBackgroundIds"),
		isPlusExclusiveBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/isPlusExclusiveBackground"),
		NO_BACKGROUND_ASSET_ID = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/constants").NO_BACKGROUND_ASSET_ID
	},
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants"),
	AnimationConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/AnimationConstants")
}
