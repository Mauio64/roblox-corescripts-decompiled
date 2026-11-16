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
local useImpressionsTagger = require("@luauforge/bundled/edd").useImpressionsTagger
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState

local module6 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dMc")
local module7 = require("@luauforge/bundled/dRQ")
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
local module8 = require("@luauforge/bundled/eeH")
local module9 = require("@luauforge/bundled/fvF")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module10 = require("@luauforge/deferred/gPz")
local module11 = require("@luauforge/deferred/ggD")
local module12 = require("@luauforge/deferred/gkR")
local module13 = require("@luauforge/deferred/gPH")

local module14 = require("@luauforge/deferred/gPK")
require("@luauforge/deferred/gPX")

local module15 = require("@luauforge/deferred/gQa")

local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local fFlagAXHeroSpotlightReportsThumbnailLoaded = AvatarExperienceFlags.FFlagAXHeroSpotlightReportsThumbnailLoaded

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

	local v14 = useSelector(React.useCallback(function(p2)
		return selectSpotlightCardTryOnState(p2, v13, kind)
	end, { v13, kind }), tutils.shallowEqual)

	local v15 = React.useCallback(function()
		if v13 and kind then
			return v7(module12(v9, v13, kind, nil, nil, false))
		end

		return false
	end, { v7, v9, v13, kind })

	local v16 = module13({
		itemId = v13,
		itemType = kind,
		itemData = v12,
		isSelected = v14.isSelected,
		textButtonRef = ref,
		fullView = v14.fullView,
		isAvatarR6 = v14.isAvatarR6,
		isItemDetailsViewStateFull = v14.isItemDetailsViewStateFull,
		maybePromptForR15Upgrade = v15,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo
	})

	local name = v10 and v10.opaque and v10.opaque.name
	local v17

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		v17 = module14(
			name == avatarScreen.CatalogSearch,
			data.selectedCategory,
			data.selectedSubcategory,
			data.selectedCategoryInfo
		)
	else
		v17 = module14(name == avatarScreen.CatalogSearch)
	end

	local widgetRow = data.widgetRow or 1
	local v18 = getMarketplaceUnifiedItemType(kind)
		or unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	local price = if v11 then v11.price else nil
	local isSelected = v14.isSelected

	local v20 = {
		action = getItemSelectionAction(isSelected),
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		itemId = v13,
		itemType = v18,
		itemPosition = 1,
		gridPositionRow = widgetRow,
		gridPositionColumn = 1,
		uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT,
		themeId = widgetInfo.tagId,
		category = v17.impressionsCategory,
		subcategory = v17.impressionsSubcategory,
		taxonomyId = v17.impressionsTaxonomyId,
		widgetItemPrice = price,
		widgetTimedOption = getTimedOptionForItemData(v12),
		widgetAssetType = 0,
		widgetBundleType = 0
	}
	local v21 = if v12 then v12.assetType else nil
	v20.widgetAssetType = v21
	local v22 = if v12 then v12.bundleType else nil
	v20.widgetBundleType = v22
	useUnifiedEventTagging({
		ref = ref,
		payload = useWidgetItemPayload(v20),
		isReady = v13 ~= nil and price ~= nil,
		options = {
			isSelected = isSelected,
			sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
		}
	})

	local v27 = React.useCallback(function()
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
		local v28 = if v11 then v11.price else nil
		v7(module11({
			itemId = v13,
			itemType = kind,
			itemSubType = itemSubType,
			priceInRobux = lowestPrice or v28,
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

	local v28

	if fFlagAXHeroSpotlightReportsThumbnailLoaded then
		local v29 = false

		if backgroundLayers then
			for k, backgroundLayer in backgroundLayers do
				if
					backgroundLayer.type == "ImageBackground"
					and backgroundLayer.resourceIdentifier
					and backgroundLayer.resourceIdentifier ~= ""
				then
					v29 = true
					break
				end
			end
		end

		local state, setState = React.useState(false)
		v28 = React.useCallback(function()
			setState(true)
		end, {})

		local onThumbnailLoaded = data.onThumbnailLoaded
		local v30 = not (v11 == nil) and (not v29 or state)
		React.useEffect(function()
			if v30 and onThumbnailLoaded and v13 then
				onThumbnailLoaded(v13)
			end
		end, { v30, onThumbnailLoaded, v13 })
	end

	local v29 = module15(data.rowWidth)

	local v30 = useLocalization({ detailsButtonText = "Feature.Catalog.Label.Details" })

	local v31 = {
		cardRef = ref,
		cardHeight = v29.spotlightCardHeight,
		cornerRadius = UDim.new(0, v5.Radius.Large),
		backgroundLayers = backgroundLayers,
		titleText = template.localizedTitle,
		titleTag = v29.titleTag,
		descriptionText = template.localizedDescription,
		descriptionTag = v29.descriptionTag,
		titleGroupGapTag = v29.titleGroupGapTag,
		priceInRobux = price,
		availableUntil = template.availableUntil,
		buttonSize = v29.spotlightButtonSize,
		cardPaddingTag = v29.cardPaddingTag,
		detailsButtonText = v30.detailsButtonText,
		isSelected = v14.isSelected,
		onTryOn = v16,
		onOpenDetails = v27,
		onBackgroundImageLoaded = 0
	}

	if not (fFlagAXHeroSpotlightReportsThumbnailLoaded and data.onThumbnailLoaded) then
		v28 = nil
	end

	v31.onBackgroundImageLoaded = v28
	return v31
end

return useHeroUnitSpotlightCardViewModel
