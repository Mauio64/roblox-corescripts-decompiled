local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useImpressionsTagger = require(CorePackages.Workspace.Packages.Impressions).useImpressionsTagger
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
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
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local selectIsFullViewTable = require(Modules.AvatarExperience.Common.Selectors.selectIsFullViewTable)
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local MaybePromptForR15Upgrade = require(Modules.AvatarExperience.Catalog.Thunks.MaybePromptForR15Upgrade)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local useTryOnAssetOrBundle = require(Modules.AvatarExperience.Catalog.Components.ItemsList.useTryOnAssetOrBundle)
local useCatalogCategoryImpressionsInfo = require(Modules.AvatarExperience.Catalog.Hooks.useCatalogCategoryImpressionsInfo)

require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitSpotlightCardView)

local useHeroUnitResponsiveStyle = require(Modules.AvatarExperience.Common.Components.Widgets.useHeroUnitResponsiveStyle)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAddTypesToWidgetItems = AvatarExperienceFlags.FFlagAddTypesToWidgetItems
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local v46 = game:DefineFastFlag("AXHeroBugfixesRemoveAdditionalAssetInfoCall", false)

local function selectSpotlightCardTryOnState(p1, s1: string?, p2) -- line: 89
	-- upvalues: getTryOnItemReducerKey (copy), FFlagAXMISEnableMultiShopping (copy), Constants (copy), PeekViewState (copy), selectIsFullViewTable (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn
	local TryOnItems = OutfitTryOn.TryOnItems
	local v54 = false

	if s1 and p2 then
		local v55 = getTryOnItemReducerKey(s1, p2)

		if FFlagAXMISEnableMultiShopping then
			v54 = TryOnItems[v55] ~= nil
		else
			local v56 = OutfitTryOn.LookId == nil

			v54 = TryOnItems[v55] ~= nil and v56
		end
	end

	return {
		isSelected = v54,
		isAvatarR6 = p1.AvatarExperience.AvatarEditor.Character.AvatarType == Constants.AvatarType.R6,
		isItemDetailsViewStateFull = p1.AvatarExperience.Common.ItemDetailsPeekView.viewState == PeekViewState.Full,
		fullView = selectIsFullViewTable(p1)
	}
end
local function useHeroUnitSpotlightCardViewModel(t1: {[any]: any}) -- line: 112
	-- upvalues: useTokens (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), RoactNetworking (copy), useNavigation (copy), useAvatarRoute (copy), React (copy), useImpressionsTagger (copy), useSelector (copy), getUseSelectorDeepEquals (copy), ItemData (copy), v46 (copy), FetchAssetOrBundleInfo (copy), selectSpotlightCardTryOnState (copy), tutils (copy), MaybePromptForR15Upgrade (copy), useTryOnAssetOrBundle (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy), useCatalogCategoryImpressionsInfo (copy), AvatarScreen (copy), getMarketplaceUnifiedItemType (copy), UnifiedEventLogEnums (copy), useWidgetItemPayload (copy), getItemSelectionAction (copy), getTimedOptionForItemData (copy), FFlagAddTypesToWidgetItems (copy), useUnifiedEventTagging (copy), UnifiedEventLogConstants (copy), sendUnifiedClickItemDetailsEvent (copy), CatalogUtils (copy), OpenItemDetails (copy), useHeroUnitResponsiveStyle (copy), useLocalization (copy)
	local v58 = useTokens()
	local widgetInfo = t1.widgetInfo
	local template = widgetInfo.template
	local v61 = (widgetInfo.content or {})[1]
	local v62 = if not v61 then nil else v61.id
	local v63 = if not v61 then nil else v61.type
	local v64 = useDispatch()
	local v65 = useRoactService(Analytics)
	local v66 = useRoactService(RoactNetworking)
	local v67 = useNavigation()
	local v68 = useAvatarRoute()
	local v69 = React.useRef(nil)

	useImpressionsTagger(v69, t1.impressionsTag, 1)

	local v70 = useSelector(function(p3) -- line: 131
		-- upvalues: v62 (copy), v63 (copy)
		if not v62 or not v63 then
			return nil
		end

		local v89 = p3.AvatarExperience.Common.Widgets.HydratedWidgetData[v63]

		if v89 then
			return v89[tostring(v62)]
		end

		return nil
	end, getUseSelectorDeepEquals())
	local v71 = useSelector(function(p4) -- line: 139
		-- upvalues: v62 (copy), v63 (copy), ItemData (copy)
		if not v62 or not v63 then
			return nil
		end

		return ItemData(p4.AvatarExperience.Common, tostring(v62), v63)
	end, getUseSelectorDeepEquals())

	if not v46 then
		React.useEffect(function() -- line: 147
			-- upvalues: v62 (copy), v63 (copy), v64 (copy), FetchAssetOrBundleInfo (copy), v66 (copy), v65 (copy)
			if v62 and v63 then
				v64(FetchAssetOrBundleInfo(v66, v65, tostring(v62), v63))
			end
		end, {
			v62,
			v63,
			v66,
			v65,
			v64
		})
	end

	local v72 = if not v62 then nil else tostring(v62)
	local v73 = React.useCallback(function(p5) -- line: 164
		-- upvalues: selectSpotlightCardTryOnState (copy), v72 (copy), v63 (copy)
		return (selectSpotlightCardTryOnState(p5, v72, v63))
	end, {
		v72,
		v63
	})
	local v74 = useSelector(v73, tutils.shallowEqual)
	local v75 = React.useCallback(function() -- line: 169
		-- upvalues: v72 (copy), v63 (copy), v64 (copy), MaybePromptForR15Upgrade (copy), v67 (copy)
		if not v72 or not v63 then
			return false
		end

		return v64(MaybePromptForR15Upgrade(v67, v72, v63, nil, nil, false))
	end, {
		v64,
		v67,
		v72,
		v63
	})
	local v76 = useTryOnAssetOrBundle({
		itemId = v72,
		itemType = v63,
		itemData = v71,
		isSelected = v74.isSelected,
		textButtonRef = v69,
		fullView = v74.fullView,
		isAvatarR6 = v74.isAvatarR6,
		isItemDetailsViewStateFull = v74.isItemDetailsViewStateFull,
		maybePromptForR15Upgrade = v75,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo
	})
	local v77 = v68 and (v68.opaque and v68.opaque.name)
	local v78 = if not FFlagAXCatalogCategoriesStoreImprovePerf then useCatalogCategoryImpressionsInfo(v77 == AvatarScreen.CatalogSearch) else useCatalogCategoryImpressionsInfo(v77 == AvatarScreen.CatalogSearch, t1.selectedCategory, t1.selectedSubcategory, t1.selectedCategoryInfo)
	local v79 = t1.widgetRow or 1
	local v80 = getMarketplaceUnifiedItemType(v63) or UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	local v81 = if not v70 then nil else v70.price
	local isSelected = v74.isSelected
	local v83 = useWidgetItemPayload({
		itemPosition = 1,
		gridPositionColumn = 1,
		action = getItemSelectionAction(isSelected),
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		itemId = v72,
		itemType = v80,
		gridPositionRow = v79,
		uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT,
		themeId = widgetInfo.tagId,
		category = v78.impressionsCategory,
		subcategory = v78.impressionsSubcategory,
		taxonomyId = v78.impressionsTaxonomyId,
		widgetItemPrice = v81,
		widgetTimedOption = getTimedOptionForItemData(v71),
		widgetAssetType = if not FFlagAddTypesToWidgetItems or not v71 then nil else v71.assetType,
		widgetBundleType = if not FFlagAddTypesToWidgetItems or not v71 then nil else v71.bundleType
	})

	useUnifiedEventTagging({
		ref = v69,
		payload = v83,
		isReady = v72 ~= nil and v81 ~= nil,
		options = {
			isSelected = isSelected,
			sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
		}
	})

	local v84 = React.useCallback(function() -- line: 235
		-- upvalues: v72 (copy), v63 (copy), sendUnifiedClickItemDetailsEvent (copy), v68 (copy), CatalogUtils (copy), v71 (copy), v70 (copy), v64 (copy), OpenItemDetails (copy), v65 (copy), v67 (copy), t1 (copy)
		if not v72 or not v63 then
			return
		end

		sendUnifiedClickItemDetailsEvent({
			itemId = v72,
			itemType = v63,
			avatarRoute = v68
		})

		local v92 = CatalogUtils.GetItemSubType(v63, v71)
		local v93 = if not v71 then nil else v71.lowestPrice or v71.priceInRobux
		local v94 = if not v70 then nil else v70.price

		v64(OpenItemDetails({
			showFullWithNoPeekView = true,
			itemId = v72,
			itemType = v63,
			itemSubType = v92,
			priceInRobux = v93 or v94,
			catalogAnalytics = v65,
			avatarRoute = v68,
			navigation = v67,
			itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
			resultsListRef = t1.resultsListRef,
			widgetInfo = t1.widgetAnalyticsInfo
		}))
	end, {
		v64,
		v72,
		v63,
		v71,
		v70,
		v65,
		v68,
		v67,
		t1.itemDetailsPeekViewRefs,
		t1.resultsListRef,
		t1.widgetAnalyticsInfo
	})
	local v85 = if not template.widgetStyle or not template.widgetStyle.backgroundLayers then nil else template.widgetStyle.backgroundLayers
	local v86 = useHeroUnitResponsiveStyle(t1.rowWidth)
	local v87 = useLocalization({
		detailsButtonText = "Feature.Catalog.Label.Details"
	})

	return {
		cardRef = v69,
		cardHeight = v86.spotlightCardHeight,
		cornerRadius = UDim.new(0, v58.Radius.Large),
		backgroundLayers = v85,
		titleText = template.localizedTitle,
		titleTag = v86.titleTag,
		descriptionText = template.localizedDescription,
		descriptionTag = v86.descriptionTag,
		titleGroupGapTag = v86.titleGroupGapTag,
		priceInRobux = v81,
		availableUntil = template.availableUntil,
		buttonSize = v86.spotlightButtonSize,
		cardPaddingTag = v86.cardPaddingTag,
		detailsButtonText = v87.detailsButtonText,
		isSelected = v74.isSelected,
		onTryOn = v76,
		onOpenDetails = v84
	}
end

return useHeroUnitSpotlightCardViewModel
