local parent = script.Parent

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
local ItemStatusTypeEnum = require(script.Components.CatalogItemCard.Enums.ItemStatusTypeEnum)
local ColorGradientCircle = require(script.Components.ColorGradientCircle.ColorGradientCircle)
local normalize = require(script.Utils.normalize)
local AXPartialPageModal = require(script.Components.AXPartialPageModal.AXPartialPageModal)
local BackgroundHighlightContainer = require(script.Components.BackgroundHighlight.BackgroundHighlightContainer)

local ContextualActionButton = require(script.Components.ContextualActionButton.ContextualActionButton)
local LicensingBadge = require(script.Components.LicensingBadge.LicensingBadge)
local selectColorAdjustmentButtonColor = require(script.State.Selectors.selectColorAdjustmentButtonColor)
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
local ItemData = require(script.State.Selectors.ItemData)

local RobuxBalance = require(script.Components.RobuxBalance.RobuxBalance)
local AdjustmentType = require(script.Enums.AdjustmentType)
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
local SpecialFeatureFilter = require(script.Enums.SpecialFeatureFilter)

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
require(parent.AvatarExperienceModel)
require(script.Types.PurchaseItemsTypes)
require(script.Types.TryOnItemComparisonData)

require(script.Backgrounds.types)

local getIsInsufficientRobuxError = require(script.Utils.getIsInsufficientRobuxError)

local AvatarExperienceCommon = {}
AvatarExperienceCommon.Components = {
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
		ItemStatusTypeEnum = ItemStatusTypeEnum,
		CatalogItemCard = CatalogItemCard,
		CatalogRowItemCard = CatalogRowItemCard
	},
	Filters = {
		CheckboxButtonItem = require(script.Components.Filters.CheckboxButtonItem),
		CheckboxGroup = require(script.Components.Filters.CheckboxGroup),
		ExpandingFrame = require(script.Components.Filters.ExpandingFrame)
	},
	ContextualActionButton = ContextualActionButton,
	LicensingBadge = LicensingBadge,
	OfferExpiryBadge = require(script.Components.OfferExpiryBadge.OfferExpiryBadge),
	AnimatedScrollingFrame = {
		useAXAnimateScrollFrame = require(script.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame),
		AnimatedScrollingFrame = require(script.Components.AnimatedScrollingFrame.AnimatedScrollingFrame)
	},
	AXPartialPageModal = AXPartialPageModal,
	BackgroundHighlight = BackgroundHighlightContainer,
	wrapForReactPortal = require(script.Components.Wrappers.wrapForReactPortal),
	AXTooltip = require(script.Components.AXTooltip.AXTooltipContainer),
	TimeoutBanner = require(script.Components.TimeoutBanner.TimeoutBannerContainer),
	Prompts = {
		EnhancedAvatarHeadsFtuxPrompt = require(script.Components.Prompts.EnhancedAvatarHeadsFtuxPrompt)
	}
}

AvatarExperienceCommon.Enums = {
	AdjustmentType = AdjustmentType,
	OutfitTypes = require(script.Enums.OutfitTypes),
	ItemRestrictions = ItemRestrictions,
	ItemStatus = ItemStatus,
	SalesLocationType = SalesLocationType,
	CreatorType = CreatorType,
	NoPriceStatus = NoPriceStatus,
	ItemPurchaseActionTypeEnum = ItemPurchaseActionTypeEnum,
	CatalogSubcategories = CatalogSubcategories,
	CatalogCategoryIds = CatalogCategoryIds,
	CatalogSubcategoryIds = CatalogSubcategoryIds,
	CatalogSDUICategoryIds = CatalogSDUICategoryIds,
	CatalogCategoryKeys = CatalogCategoryKey,
	CatalogSubcategoryKeys = CatalogSubcategoryKey,
	FullView = FullView,
	WearTimeFilter = WearTimeFilter,
	SpecialFeatureFilter = SpecialFeatureFilter,
	DiscountTypeEnum = require(script.Enums.DiscountType)
}

AvatarExperienceCommon.Hooks = {
	useSelectorSignal = useSelectorSignal,
	useSignal = useSignal,
	useComputedSignal = useComputedSignal,
	usePulseAnimationBinding = usePulseAnimationBinding,
	useArrowNavScrollBehavior = useArrowNavScrollBehavior,
	useCategoryPillColorAnimation = useCategoryPillColorAnimation,
	useSubcategoryPillAnimation = useSubcategoryPillAnimation,
	useRedirectFocusIntoGuiObject = require(script.Hooks.useRedirectFocusIntoGuiObject),
	useNetworking = require(script.Hooks.useNetworking),
	useHydrateEquippedAvatarOutfitId = require(script.Hooks.useHydrateEquippedAvatarOutfitId),
	useFocusOnMountEffect = require(script.Hooks.useFocusOnMountEffect),
	useEnhancedAvatarHeadsFtux = require(script.Hooks.useEnhancedAvatarHeadsFtux),
	useAdaptiveScrolling = require(script.Hooks.useAdaptiveScrolling),
	AdaptiveScrollingContext = AdaptiveScrollingContext,
	withAdaptiveScrolling = withAdaptiveScrolling,
	useUnifiedImpressionExposer = require(script.Hooks.useUnifiedImpressionExposer),
	useIsDirectional = require(script.Hooks.useIsDirectional),
	useAvatarChangeAcknowledgementPrompt = require(script.Hooks.useAvatarChangeAcknowledgementPrompt),
	useIsAvatarChangeTimeoutActive = require(script.Hooks.useIsAvatarChangeTimeoutActive)
}

AvatarExperienceCommon.Lib = {
	SafeAppStorageService = require(script.Lib.SafeAppStorageService)
}

AvatarExperienceCommon.Experiments = {
	AXRecentlyViewedSearchItemsIXPTest = require(script.Experiments.AXRecentlyViewedSearchItemsIXPTest),
	AXAvatarsTabIXP = require(script.Experiments.AXAvatarsTabIXP)
}

AvatarExperienceCommon.State = {
	Selectors = {
		selectColorAdjustmentButtonColor = selectColorAdjustmentButtonColor,
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
		selectTryOnsLookId = selectTryOnsLookId,
		ItemData = ItemData
	},
	Actions = {
		CharacterHistoryStateChangeButtonActivated = CharacterHistoryStateChangeButtonActivated
	}
}

AvatarExperienceCommon.Stores = {
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
	getApplyingLayeredClothingStore = require(script.Stores.ApplyingLayeredClothingStore.getApplyingLayeredClothingStore),
	getLayeredClothingCurrentSortStore = require(script.Stores.LayeredClothingCurrentSortStore.getLayeredClothingCurrentSortStore),
	getTimeoutStatusStore = require(script.Stores.TimeoutStatusStore.getTimeoutStatusStore),
	getAdjustmentTypeSelectedStore = require(script.Stores.AdjustmentTypeSelectedStore.getAdjustmentTypeSelectedStore),
	getEquippedAvatarOutfitIdStore = require(script.Stores.EquippedAvatarOutfitIdStore.getEquippedAvatarOutfitIdStore)
}

AvatarExperienceCommon.Utils = {
	createSelectorSignal = require(script.Utils.createSelectorSignal),
	buildHumanoidDescription = require(script.Utils.Humanoid.buildHumanoidDescription),
	getAssetIdToAssetTypeIdFromHumanoidDescription = require(script.Utils.Humanoid.getAssetIdToAssetTypeIdFromHumanoidDescription),
	getHumanoidDescriptionFromState = require(script.Utils.Humanoid.getHumanoidDescriptionFromState),
	setHumanoidDescriptionColorsFromBodyColor3s = require(script.Utils.Humanoid.setHumanoidDescriptionColorsFromBodyColor3s),
	setMakeupDescriptions = require(script.Utils.Humanoid.setMakeupDescriptions),
	setAvatarEffectDescriptions = require(script.Utils.Humanoid.setAvatarEffectDescriptions),
	destroyMakeupDescriptions = require(script.Utils.Humanoid.destroyMakeupDescriptions),
	getMakeupDescriptionsFromHumanoidDescription = require(script.Utils.Humanoid.getMakeupDescriptionsFromHumanoidDescription),
	createHumanoidDescriptionAccessoryInfo = require(script.Utils.Humanoid.createHumanoidDescriptionAccessoryInfo),
	getGearAssetIdFromEquippedAssets = require(script.Utils.getGearAssetIdFromEquippedAssets),
	getEquippedLayeredMakeupAssets = require(script.Utils.getEquippedLayeredMakeupAssets),
	getRbxThumbType = require(script.Utils.getRbxThumbType),
	isVRHiddenRobuxBalanceScreen = require(script.Utils.isVRHiddenRobuxBalanceScreen),
	normalize = normalize,
	getRawItemLicensingInfo = require(script.Utils.getRawItemLicensingInfo),
	parseItemLicensing = require(script.Utils.parseItemLicensing),
	normalizeScreenSizeForWire = require(script.Utils.normalizeScreenSizeForWire),
	debounce = require(script.Utils.debounce),
	getZoomedSizeAndOffset = require(script.Utils.getZoomedSizeAndOffset),
	getThumbSizeVectorFromParamString = require(script.Utils.getThumbSizeVectorFromParamString),
	getUseSelectorDeepEquals = require(script.Utils.getUseSelectorDeepEquals),
	findItemInTryOnItems = require(script.Utils.findItemInTryOnItems),
	getTryOnItemReducerKey = require(script.Utils.getTryOnItemReducerKey),
	getFilteredTryOnItems = require(script.Utils.TryOns.getFilteredTryOnItems),
	getTryOnItemComparisonData = require(script.Utils.TryOns.getTryOnItemComparisonData),
	getShouldReplaceTryOn = require(script.Utils.TryOns.getShouldReplaceTryOn),
	removeMakeupAssetsFromTryOnsIfOverLimit = require(script.Utils.TryOns.removeMakeupAssetsFromTryOnsIfOverLimit),
	getItemPurchaseActionType = require(script.Utils.getItemPurchaseActionType),
	RoactGamepadMigration = {
		findValueKeyInRefCache = require(script.Utils.RoactGamepadMigration.findValueKeyInRefCache)
	},
	getBackendLayerNamesForCatalog = require(script.Utils.getBackendLayerNamesForCatalog),
	getGearAssetIdFromState = require(script.Utils.getGearAssetIdFromState),
	getEquippedAssetIdsForType = require(script.Utils.getEquippedAssetIdsForType),
	isMakeupAssetType = require(script.Utils.isMakeupAssetType),
	isSpawnEffectAssetType = require(script.Utils.isSpawnEffectAssetType),
	isMakeupOrEyebrowEyelashAssetType = require(script.Utils.isMakeupOrEyebrowEyelashAssetType),
	isLayeredClothingAssetType = require(script.Utils.isLayeredClothingAssetType),
	isDurableItemExpired = require(script.Utils.isDurableItemExpired),
	formatTimeoutEndTime = require(script.Utils.formatTimeoutEndTime),
	showAvatarChangeFeatureRestriction = require(script.Utils.showAvatarChangeFeatureRestriction),
	isOutfitNameValid = require(script.Utils.isOutfitNameValid),
	isValidAssetTypeForOutfitType = require(script.Utils.isValidAssetTypeForOutfitType),
	getHumanoidDescriptionFromStateForOutfitType = require(script.Utils.Humanoid.getHumanoidDescriptionFromStateForOutfitType),
	getIsInsufficientRobuxError = getIsInsufficientRobuxError,
	getInventoryOutfitType = require(script.Utils.getInventoryOutfitType),
	getGrantedOutfitIds = require(script.Utils.getGrantedOutfitIds)
}

local backgrounds = {
	loadBackgroundAsset = require(script.Backgrounds.loadBackgroundAsset),
	selectActiveBackground = require(script.Backgrounds.selectActiveBackground),
	selectActiveBackgroundPreview = require(script.Backgrounds.selectActiveBackgroundPreview),
	selectTryOnBackgroundId = require(script.Backgrounds.selectTryOnBackgroundId),
	previewImageRegistry = require(script.Backgrounds.previewImageRegistry),
	buildOutfitProfileConfiguration = require(script.Backgrounds.buildOutfitProfileConfiguration),
	normalizeBackgroundId = require(script.Backgrounds.normalizeBackgroundId),
	getTemporaryPlusBackgroundIds = require(script.Backgrounds.getTemporaryPlusBackgroundIds),
	isPlusExclusiveBackground = require(script.Backgrounds.isPlusExclusiveBackground),
	NO_BACKGROUND_ASSET_ID = 0
}
local constants = require(script.Backgrounds.constants)
backgrounds.NO_BACKGROUND_ASSET_ID = constants.NO_BACKGROUND_ASSET_ID
AvatarExperienceCommon.Backgrounds = backgrounds

AvatarExperienceCommon.Constants = require(script.Constants)
AvatarExperienceCommon.AnimationConstants = require(script.AnimationConstants)
AvatarExperienceCommon["jest.config"] = script["jest.config"]
return AvatarExperienceCommon
