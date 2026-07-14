local CatalogItemCard = require(script.Components.CatalogItemCard.CatalogItemCard)
local CatalogRowItemCard = require(script.Components.CatalogRowItemCard.CatalogRowItemCard)

require(script.Components.CatalogRowItemCard.CatalogRowItemCardFooter)

local CatalogItemCardItemInfoEnum = require(script.Components.CatalogItemCard.Enums.CatalogItemCardItemInfoEnum)
local CatalogItemCardItemTypeEnum = require(script.Components.CatalogItemCard.Enums.CatalogItemCardItemTypeEnum)
local ItemRestrictions = require(script.Enums.ItemRestrictions)
local ItemStatus = require(script.Enums.ItemStatus)
local SalesLocationType = require(script.Enums.SalesLocationType)
local CreatorType = require(script.Enums.CreatorType)
local CatalogItemCardStatusIconTypeEnum = require(script.Components.CatalogItemCard.Enums.CatalogItemCardStatusIconTypeEnum)
local ColorGradientCircle = require(script.Components.ColorGradientCircle.ColorGradientCircle)
local normalize = require(script.Utils.normalize)
local AXPartialPageModal = require(script.Components.AXPartialPageModal.AXPartialPageModal)
local ContextualActionButton = require(script.Components.ContextualActionButton.ContextualActionButton)
local selectColorAdjustmentButtonColor = require(script.State.Selectors.selectColorAdjustmentButtonColor)
local selectAdjustableLastTryOnItem = require(script.State.Selectors.selectAdjustableLastTryOnItem)
local selectTryOnBodyIds = require(script.State.Selectors.selectTryOnBodyIds)
local selectHasBodyTryOn = require(script.State.Selectors.selectHasBodyTryOn)
local selectShowColorQuickButton = require(script.State.Selectors.selectShowColorQuickButton)
local selectAvatarPreviewColors = require(script.State.Selectors.selectAvatarPreviewColors)
local selectSearchKeyword = require(script.State.Selectors.selectSearchKeyword)
local selectCurrentAvatarRoute = require(script.State.Selectors.selectCurrentAvatarRoute)
local selectIsFullView = require(script.State.Selectors.selectIsFullView)
local selectTopBarHeight = require(script.State.Selectors.selectTopBarHeight)
local selectEquippedAssets = require(script.State.Selectors.selectEquippedAssets)
local selectHasMakeupTryOn = require(script.State.Selectors.selectHasMakeupTryOn)
local selectTryOnItems = require(script.State.Selectors.selectTryOnItems)
local selectCurrentAvatarEditorCategory = require(script.State.Selectors.selectCurrentAvatarEditorCategory)
local selectEquippedLayeredMakeupAssets = require(script.State.Selectors.selectEquippedLayeredMakeupAssets)
local selectTotalLayeredMakeupAssets = require(script.State.Selectors.selectTotalLayeredMakeupAssets)
local selectHasDynamicHead = require(script.State.Selectors.selectHasDynamicHead)
local selectTryOnsLookId = require(script.State.Selectors.selectTryOnsLookId)
local RobuxBalance = require(script.Components.RobuxBalance.RobuxBalance)
local ItemTypeEnum = require(script.Enums.ItemTypeEnum)
local CatalogCategories = require(script.Enums.CatalogCategories)
local CatalogSubcategories = require(script.Enums.CatalogSubcategories)
local CatalogCategoryIds = require(script.Enums.CatalogCategoryIds)
local CatalogSubcategoryIds = require(script.Enums.CatalogSubcategoryIds)
local CatalogSDUICategoryIds = require(script.Enums.CatalogSDUICategoryIds)
local CatalogCategoryKey = require(script.Enums.CatalogCategoryKey)
local CatalogSubcategoryKey = require(script.Enums.CatalogSubcategoryKey)
local NoPriceStatus = require(script.Enums.NoPriceStatus)
local ItemPurchaseActionTypeEnum = require(script.Enums.ItemPurchaseActionTypeEnum)
local FullView = require(script.Enums.FullView)
local WearTimeFilter = require(script.Enums.WearTimeFilter)
local CharacterHistoryStateChangeButtonActivated = require(script.State.CharacterHistoryStateChangeButtonActivated)
local useSelectorSignal = require(script.Hooks.useSelectorSignal)
local useSignal = require(script.Hooks.useSignal)
local useComputedSignal = require(script.Hooks.useComputedSignal)
local usePulseAnimationBinding = require(script.Hooks.usePulseAnimationBinding)
local useArrowNavScrollBehavior = require(script.Hooks.useArrowNavScrollBehavior)
local useCategoryPillColorAnimation = require(script.Hooks.useCategoryPillColorAnimation)
local useSubcategoryPillAnimation = require(script.Hooks.useSubcategoryPillAnimation)
local AdaptiveScrollingContext = require(script.Hooks.AdaptiveScrollingContext)
local withAdaptiveScrolling = require(script.Hooks.withAdaptiveScrolling)

require(script.Stores.AnimatedVisibilityStore.createAnimatedVisibilityStore)
require(script.Stores.AnimatedVisibilityStore.AnimatedVisibilityContext)
require(script.Types.CategoryTypes.CategoryTypes)
require(script.Types.CategoryTypes.CatalogCategoryTypes)
require(script.Types.CategoryTypes.AvatarEditorCategoryTypes)
require(script.Types.CategoryTypes.SharedCategoryTypes)
require(script.Types.ButtonStackItemType)
require(script.Types.CommonTypes)
require(script.Types.TimedOptionType)
require(script.Types.DiscountType)
require(script.Types.AvatarColorTypes)
require(script.Types.WidgetAnalyticsInfo)
require(script.Types.WidgetInfoContextTypes)
require(script.Types.ItemTypes)
require(script.Backgrounds.types)

return {
	Components = {
		ArrowNavV2 = require(script.Components.ArrowNav.ArrowNavV2),
		RobuxBalance = RobuxBalance,
		AnimatedCategoryPill = require(script.Components.CategoryPill.AnimatedCategoryPill),
		AnimatedSubcategoryPill = require(script.Components.CategoryPill.AnimatedSubcategoryPill),
		CategoryPill = require(script.Components.CategoryPill.CategoryPill),
		CategoryPillCloseButton = require(script.Components.CategoryPill.CategoryPillCloseButton),
		ColorGradientCircle = ColorGradientCircle,
		Overlay = require(script.Components.Overlay.Overlay),
		FlexLayout = require(script.Components.FlexLayout.FlexLayout),
		CatalogItemCard = {
			CatalogItemCardItemInfoEnum = CatalogItemCardItemInfoEnum,
			CatalogItemCardItemTypeEnum = CatalogItemCardItemTypeEnum,
			CatalogItemCardStatusIconTypeEnum = CatalogItemCardStatusIconTypeEnum,
			CatalogItemCard = CatalogItemCard,
			CatalogRowItemCard = CatalogRowItemCard,
			WearTimeFTUXStatusEnum = require(script.Components.CatalogItemCard.Enums.WearTimeFTUXStatusEnum)
		},
		Filters = {
			CheckboxButtonItem = require(script.Components.Filters.CheckboxButtonItem),
			CheckboxGroup = require(script.Components.Filters.CheckboxGroup),
			ExpandingFrame = require(script.Components.Filters.ExpandingFrame)
		},
		ContextualActionButton = ContextualActionButton,
		AnimatedScrollingFrame = {
			useAXAnimateScrollFrame = require(script.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame),
			AnimatedScrollingFrame = require(script.Components.AnimatedScrollingFrame.AnimatedScrollingFrame)
		},
		AXPartialPageModal = AXPartialPageModal,
		wrapForReactPortal = require(script.Components.Wrappers.wrapForReactPortal),
		AXTooltip = require(script.Components.AXTooltip.AXTooltipContainer),
		TimeoutBanner = require(script.Components.TimeoutBanner.TimeoutBannerContainer),
		Prompts = {
			EnhancedAvatarHeadsFtuxPrompt = require(script.Components.Prompts.EnhancedAvatarHeadsFtuxPrompt)
		}
	},
	Enums = {
		OutfitTypes = require(script.Enums.OutfitTypes),
		ItemTypeEnum = ItemTypeEnum,
		ItemRestrictions = ItemRestrictions,
		ItemStatus = ItemStatus,
		SalesLocationType = SalesLocationType,
		CreatorType = CreatorType,
		NoPriceStatus = NoPriceStatus,
		ItemPurchaseActionTypeEnum = ItemPurchaseActionTypeEnum,
		CatalogCategories = CatalogCategories,
		CatalogSubcategories = CatalogSubcategories,
		CatalogCategoryIds = CatalogCategoryIds,
		CatalogSubcategoryIds = CatalogSubcategoryIds,
		CatalogSDUICategoryIds = CatalogSDUICategoryIds,
		CatalogCategoryKeys = CatalogCategoryKey,
		CatalogSubcategoryKeys = CatalogSubcategoryKey,
		FullView = FullView,
		WearTimeFilter = WearTimeFilter,
		DiscountTypeEnum = require(script.Enums.DiscountType)
	},
	Hooks = {
		useSelectorSignal = useSelectorSignal,
		useSignal = useSignal,
		useComputedSignal = useComputedSignal,
		usePulseAnimationBinding = usePulseAnimationBinding,
		useArrowNavScrollBehavior = useArrowNavScrollBehavior,
		useCategoryPillColorAnimation = useCategoryPillColorAnimation,
		useSubcategoryPillAnimation = useSubcategoryPillAnimation,
		useRedirectFocusIntoGuiObject = require(script.Hooks.useRedirectFocusIntoGuiObject),
		useNetworking = require(script.Hooks.useNetworking),
		useFocusOnMountEffect = require(script.Hooks.useFocusOnMountEffect),
		useEnhancedAvatarHeadsFtux = require(script.Hooks.useEnhancedAvatarHeadsFtux),
		useAdaptiveScrolling = require(script.Hooks.useAdaptiveScrolling),
		AdaptiveScrollingContext = AdaptiveScrollingContext,
		withAdaptiveScrolling = withAdaptiveScrolling,
		useUnifiedImpressionExposer = require(script.Hooks.useUnifiedImpressionExposer)
	},
	Lib = {
		SafeAppStorageService = require(script.Lib.SafeAppStorageService)
	},
	Experiments = {
		AXRecentlyViewedSearchItemsIXPTest = require(script.Experiments.AXRecentlyViewedSearchItemsIXPTest),
		AXAvatarsTabIXP = require(script.Experiments.AXAvatarsTabIXP)
	},
	State = {
		Selectors = {
			selectColorAdjustmentButtonColor = selectColorAdjustmentButtonColor,
			selectAdjustableLastTryOnItem = selectAdjustableLastTryOnItem,
			selectTryOnBodyIds = selectTryOnBodyIds,
			selectHasBodyTryOn = selectHasBodyTryOn,
			selectShowColorQuickButton = selectShowColorQuickButton,
			selectAvatarPreviewColors = selectAvatarPreviewColors,
			selectSearchKeyword = selectSearchKeyword,
			selectCurrentAvatarRoute = selectCurrentAvatarRoute,
			selectIsFullView = selectIsFullView,
			selectTopBarHeight = selectTopBarHeight,
			selectEquippedAssets = selectEquippedAssets,
			selectHasMakeupTryOn = selectHasMakeupTryOn,
			selectTryOnItems = selectTryOnItems,
			selectCurrentAvatarEditorCategory = selectCurrentAvatarEditorCategory,
			selectEquippedLayeredMakeupAssets = selectEquippedLayeredMakeupAssets,
			selectTotalLayeredMakeupAssets = selectTotalLayeredMakeupAssets,
			selectHasDynamicHead = selectHasDynamicHead,
			selectTryOnsLookId = selectTryOnsLookId
		},
		Actions = {
			CharacterHistoryStateChangeButtonActivated = CharacterHistoryStateChangeButtonActivated
		}
	},
	Stores = {
		AnimatedVisibilityStore = {
			createAnimatedVisibilityStore = require(script.Stores.AnimatedVisibilityStore.createAnimatedVisibilityStore),
			AnimatedVisibilityContext = require(script.Stores.AnimatedVisibilityStore.AnimatedVisibilityContext),
			AnimatedVisibilityProvider = require(script.Stores.AnimatedVisibilityStore.AnimatedVisibilityContextProvider),
			useAnimatedVisibility = require(script.Stores.AnimatedVisibilityStore.useAnimatedVisibility)
		},
		AvatarLastEquippedStateStore = {
			avatarLastEquippedStateStore = require(script.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore)
		},
		AXTooltipStore = require(script.Stores.AXTooltipStore),
		getTimeoutStatusStore = require(script.Stores.TimeoutStatusStore.getTimeoutStatusStore)
	},
	Utils = {
		createSelectorSignal = require(script.Utils.createSelectorSignal),
		buildHumanoidDescription = require(script.Utils.Humanoid.buildHumanoidDescription),
		getAssetIdToAssetTypeIdFromHumanoidDescription = require(script.Utils.Humanoid.getAssetIdToAssetTypeIdFromHumanoidDescription),
		getHumanoidDescriptionFromState = require(script.Utils.Humanoid.getHumanoidDescriptionFromState),
		setHumanoidDescriptionColorsFromBodyColor3s = require(script.Utils.Humanoid.setHumanoidDescriptionColorsFromBodyColor3s),
		setMakeupDescriptions = require(script.Utils.Humanoid.setMakeupDescriptions),
		destroyMakeupDescriptions = require(script.Utils.Humanoid.destroyMakeupDescriptions),
		getMakeupDescriptionsFromHumanoidDescription = require(script.Utils.Humanoid.getMakeupDescriptionsFromHumanoidDescription),
		createHumanoidDescriptionAccessoryInfo = require(script.Utils.Humanoid.createHumanoidDescriptionAccessoryInfo),
		getGearAssetIdFromEquippedAssets = require(script.Utils.getGearAssetIdFromEquippedAssets),
		getRbxThumbType = require(script.Utils.getRbxThumbType),
		normalize = normalize,
		debounce = require(script.Utils.debounce),
		getZoomedSizeAndOffset = require(script.Utils.getZoomedSizeAndOffset),
		getThumbSizeVectorFromParamString = require(script.Utils.getThumbSizeVectorFromParamString),
		getUseSelectorDeepEquals = require(script.Utils.getUseSelectorDeepEquals),
		findItemInTryOnItems = require(script.Utils.findItemInTryOnItems),
		getTryOnItemReducerKey = require(script.Utils.getTryOnItemReducerKey),
		getItemPurchaseActionType = require(script.Utils.getItemPurchaseActionType),
		RoactGamepadMigration = {
			useTableWrappedCallbackRef = require(script.Utils.RoactGamepadMigration.useTableWrappedCallbackRef),
			findValueKeyInRefCache = require(script.Utils.RoactGamepadMigration.findValueKeyInRefCache)
		},
		getBackendLayerNamesForCatalog = require(script.Utils.getBackendLayerNamesForCatalog),
		getGearAssetIdFromState = require(script.Utils.getGearAssetIdFromState),
		getEquippedAssetIdsForType = require(script.Utils.getEquippedAssetIdsForType),
		isMakeupAssetType = require(script.Utils.isMakeupAssetType),
		isMakeupOrEyebrowEyelashAssetType = require(script.Utils.isMakeupOrEyebrowEyelashAssetType),
		isLayeredClothingAssetType = require(script.Utils.isLayeredClothingAssetType),
		isDurableItemExpired = require(script.Utils.isDurableItemExpired),
		formatTimeoutEndTime = require(script.Utils.formatTimeoutEndTime)
	},
	Backgrounds = {
		loadBackgroundAsset = require(script.Backgrounds.loadBackgroundAsset),
		selectActiveBackground = require(script.Backgrounds.selectActiveBackground),
		buildOutfitProfileConfiguration = require(script.Backgrounds.buildOutfitProfileConfiguration),
		NO_BACKGROUND_ASSET_ID = require(script.Backgrounds.constants).NO_BACKGROUND_ASSET_ID
	},
	Constants = require(script.Constants),
	AnimationConstants = require(script.AnimationConstants),
	["jest.config"] = script["jest.config"]
}
