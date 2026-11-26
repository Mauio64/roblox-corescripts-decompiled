local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useImpressionsTagger = require("@luauforge/bundled/egA").useImpressionsTagger
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState

local module6 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dPs")
local module7 = require("@luauforge/bundled/dVl")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getItemSelectionAction = AvatarExperienceAnalytics.Utils.getItemSelectionAction
local getMarketplaceUnifiedItemType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedItemType
local getTimedOptionForItemData = AvatarExperienceAnalytics.Utils.getTimedOptionForItemData

local useTokens = Foundation.Hooks.useTokens
local useWidgetItemPayload = AvatarExperienceCatalog.Hooks.useWidgetItemPayload
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local sendUnifiedClickItemDetailsEvent = AvatarExperienceAnalytics.sendUnifiedClickItemDetailsEvent
local useUnifiedEventTagging = AvatarExperienceAnalytics.useUnifiedEventTagging
local module8 = require("@luauforge/bundled/eie")
local module9 = require("@luauforge/bundled/fDf")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module10 = require("@luauforge/deferred/hbC")
local module11 = require("@luauforge/deferred/gLj")
local module12 = require("@luauforge/deferred/gPx")
local module13 = require("@luauforge/deferred/hbK")

local module14 = require("@luauforge/deferred/hbN")
require("@luauforge/deferred/hca")

local module15 = require("@luauforge/deferred/hce")
local module16 = require("@luauforge/deferred/hcf")

local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local fFlagAXHeroSpotlightReportsThumbnailLoaded = AvatarExperienceFlags.FFlagAXHeroSpotlightReportsThumbnailLoaded
local fFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

local function selectSpotlightCardTryOnState(p2, p3, kind)
	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return {
		isSelected = if p3 and kind then tryOnItems[getTryOnItemReducerKey(p3, kind)] ~= nil else false,
		isAvatarR6 = p2.AvatarExperience.AvatarEditor.Character.AvatarType == module6.AvatarType.R6,
		isItemDetailsViewStateFull = p2.AvatarExperience.Common.ItemDetailsPeekView.viewState == peekViewState.Full,
		fullView = module10(p2)
	}
end

local function useHeroUnitSpotlightCardViewModel(data)
	local v5 = useTokens()
	local widgetInfo = data.widgetInfo
	local template = widgetInfo.template
	local v6 = (widgetInfo.content or {})[1]

	local id = if v6 then v6.id else nil
	local kind = if v6 then v6.type else nil

	local v7 = useDispatch()
	local v8 = module8(module9)
	local v9 = useNavigation()
	local v10 = useAvatarRoute()

	local ref = React.useRef(nil)
	useImpressionsTagger(ref, data.impressionsTag, 1)

	local v11 = useSelector(function(p2)
		if not (id and kind) then
			return nil
		end

		local v12 = p2.AvatarExperience.Common.Widgets.HydratedWidgetData[kind]

		if v12 then
			return v12[tostring(id)]
		end

		return nil
	end, getUseSelectorDeepEquals())

	local v12 = useSelector(function(p2)
		if id and kind then
			return itemData(p2.AvatarExperience.Common, tostring(id), kind)
		end

		return nil
	end, getUseSelectorDeepEquals())

	local v13 = if id then tostring(id) else nil

	local v15 = useSelector(React.useCallback(function(p2)
		return selectSpotlightCardTryOnState(p2, v13, kind)
	end, { v13, kind }), tutils.shallowEqual)

	local v16 = React.useCallback(function()
		if v13 and kind then
			return v7(module12(v9, v13, kind, nil, nil, false))
		end

		return false
	end, { v7, v9, v13, kind })

	local v17 = module13({
		itemId = v13,
		itemType = kind,
		itemData = v12,
		isSelected = v15.isSelected,
		textButtonRef = ref,
		fullView = v15.fullView,
		isAvatarR6 = v15.isAvatarR6,
		isItemDetailsViewStateFull = v15.isItemDetailsViewStateFull,
		maybePromptForR15Upgrade = v16,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo
	})

	local name = v10 and v10.opaque and v10.opaque.name
	local v18

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		v18 = module14(
			name == avatarScreen.CatalogSearch,
			data.selectedCategory,
			data.selectedSubcategory,
			data.selectedCategoryInfo
		)
	else
		v18 = module14(name == avatarScreen.CatalogSearch)
	end

	local widgetRow = data.widgetRow or 1
	local v19 = getMarketplaceUnifiedItemType(kind)
		or unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	local price = if v11 then v11.price else nil
	local isSelected = v15.isSelected

	local v21 = {
		action = getItemSelectionAction(isSelected),
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		itemId = v13,
		itemType = v19,
		itemPosition = 1,
		gridPositionRow = widgetRow,
		gridPositionColumn = 1,
		uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT,
		themeId = widgetInfo.tagId,
		category = v18.impressionsCategory,
		subcategory = v18.impressionsSubcategory,
		taxonomyId = v18.impressionsTaxonomyId,
		widgetItemPrice = price,
		widgetTimedOption = getTimedOptionForItemData(v12),
		widgetAssetType = 0,
		widgetBundleType = 0
	}
	local v22 = if v12 then v12.assetType else nil
	v21.widgetAssetType = v22
	local v23 = if v12 then v12.bundleType else nil
	v21.widgetBundleType = v23
	useUnifiedEventTagging({
		ref = ref,
		payload = useWidgetItemPayload(v21),
		isReady = v13 ~= nil and price ~= nil,
		options = {
			isSelected = isSelected,
			sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
		}
	})

	local v28 = React.useCallback(function()
		if not (v13 and kind) then
			return
		end

		sendUnifiedClickItemDetailsEvent({
			itemId = v13,
			itemType = kind,
			avatarRoute = v10
		})

		local itemSubType = module7.GetItemSubType(kind, v12)
		local lowestPrice = if v12 then v12.lowestPrice or v12.priceInRobux else nil
		local v29 = if v11 then v11.price else nil
		v7(module11({
			itemId = v13,
			itemType = kind,
			itemSubType = itemSubType,
			priceInRobux = lowestPrice or v29,
			catalogAnalytics = v8,
			avatarRoute = v10,
			navigation = v9,
			itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs,
			resultsListRef = data.resultsListRef,
			widgetInfo = data.widgetAnalyticsInfo,
			showFullWithNoPeekView = true
		}))
	end, {
		v7,
		v13,
		kind,
		v12,
		v11,
		v8,
		v10,
		v9,
		data.itemDetailsPeekViewRefs,
		data.resultsListRef,
		data.widgetAnalyticsInfo
	})
	local backgroundLayers

	if template.widgetStyle and template.widgetStyle.backgroundLayers then
		backgroundLayers = template.widgetStyle.backgroundLayers
	end

	local v29

	if fFlagAXHeroSpotlightReportsThumbnailLoaded then
		local v30 = false

		if backgroundLayers then
			for k, backgroundLayer in backgroundLayers do
				if
					backgroundLayer.type == "ImageBackground"
					and backgroundLayer.resourceIdentifier
					and backgroundLayer.resourceIdentifier ~= ""
				then
					v30 = true
					break
				end
			end
		end

		local state, setState = React.useState(false)
		v29 = React.useCallback(function()
			setState(true)
		end, {})

		local onThumbnailLoaded = data.onThumbnailLoaded
		local v31 = not (v11 == nil) and (not v30 or state)
		React.useEffect(function()
			if v31 and onThumbnailLoaded and v13 then
				onThumbnailLoaded(v13)
			end
		end, { v31, onThumbnailLoaded, v13 })
	end

	local v30 = module15(data.rowWidth)

	local v31 = useLocalization({ detailsButtonText = "Feature.Catalog.Label.Details" })
	local v32

	if fFlagAXHeroUnitActionButton then
		v32 = module16(template.button, {
			widgetAnalyticsInfo = data.widgetAnalyticsInfo,
			widgetRow = widgetRow,
			tagId = widgetInfo.tagId
		})
	end

	local v33 = {
		cardRef = ref,
		cardHeight = v30.spotlightCardHeight,
		cornerRadius = UDim.new(0, v5.Radius.Large),
		backgroundLayers = backgroundLayers,
		titleText = template.localizedTitle,
		titleTag = v30.titleTag,
		descriptionText = template.localizedDescription,
		descriptionTag = v30.descriptionTag,
		titleGroupGapTag = v30.titleGroupGapTag,
		priceInRobux = price,
		availableUntil = template.availableUntil,
		buttonSize = v30.spotlightButtonSize,
		cardPaddingTag = v30.cardPaddingTag,
		detailsButtonText = v31.detailsButtonText,
		isSelected = v15.isSelected,
		onTryOn = v17,
		onOpenDetails = v28,
		onBackgroundImageLoaded = 0,
		heroUnitButtonAction = 0,
		actionButtonTestId = 0,
		detailsButtonTestId = 0
	}

	if not (fFlagAXHeroSpotlightReportsThumbnailLoaded and data.onThumbnailLoaded) then
		v29 = nil
	end

	v33.onBackgroundImageLoaded = v29

	if not fFlagAXHeroUnitActionButton then
		v32 = nil
	end

	v33.heroUnitButtonAction = v32

	local v34 = if fFlagAXHeroUnitActionButton then `--avatar-marketplace-herounit-actionbutton-{widgetInfo.id}` else nil
	v33.actionButtonTestId = v34

	local v35 = if fFlagAXHeroUnitActionButton then `--avatar-marketplace-herounit-detailsbutton-{widgetInfo.id}` else nil
	v33.detailsButtonTestId = v35
	return v33
end

return useHeroUnitSpotlightCardViewModel
