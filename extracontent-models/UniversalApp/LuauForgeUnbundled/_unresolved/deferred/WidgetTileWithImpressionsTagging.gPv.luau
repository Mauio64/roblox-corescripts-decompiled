local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useImpressionsTagger = require("@luauforge/bundled/edd").useImpressionsTagger
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module = require("@luauforge/deferred/gPw")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local fFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget
local fFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration
local fFlagAXSduiSponsoredItemClickTracking = AvatarExperienceFlags.FFlagAXSduiSponsoredItemClickTracking
local fFlagAXSduiCarouselTileLayoutOrder = AvatarExperienceFlags.FFlagAXSduiCarouselTileLayoutOrder

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module4 = require("@luauforge/bundled/dMd")
local module5 = require("@luauforge/deferred/gPx")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local module6 = require("@luauforge/bundled/dME")
local itemTypeEnum = module4.Enums.ItemTypeEnum
local module7 = require("@luauforge/bundled/dMx")

local module8 = require("@luauforge/deferred/gPK")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module9 = require("@luauforge/deferred/gPL")

local function WidgetTileWithImpressionsTagging(props)
	useImpressionsTagger(props.refCache[props.index], props.impressionsTag, props.index)

	local contentType = props.contentType
	local contentId = props.contentId
	local index = props.index
	local refCache = props.refCache

	local v5 = useSelector(function(p2)
		local v6 = p2.AvatarExperience.Common.Widgets.HydratedWidgetData[contentType]

		if v6 then
			return v6[tostring(contentId)]
		end

		return nil
	end, getUseSelectorDeepEquals())

	local v6 = v5 and v5.type == itemTypeEnum.Look

	local v7 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarScene.AvatarRoute.opaque.name
	end, getUseSelectorDeepEquals())
	local v8

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		v8 = module8(
			v7 == avatarScreen.CatalogSearch,
			props.selectedCategory,
			props.selectedSubcategory,
			props.selectedCategoryInfo
		)
	else
		v8 = module8(v7 == avatarScreen.CatalogSearch)
	end

	local impressionsCategory = v8.impressionsCategory
	local impressionsSubcategory = v8.impressionsSubcategory
	local impressionsTaxonomyId = v8.impressionsTaxonomyId

	local lookType = v5 and v5.lookType
	local widgetAnalyticsInfo = props.widgetAnalyticsInfo
	local v9 = React.useMemo(function()
		if fFlagAXDeferLookImpressionsForHydration then
			return module(widgetAnalyticsInfo, lookType)
		end

		return widgetAnalyticsInfo
	end, { widgetAnalyticsInfo, lookType })

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v10 = {
		Size = UDim2.new(props.size.X, UDim.new()),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = if fFlagAXSduiCarouselTileLayoutOrder then index else nil,
		ref = refCache[index],
		NextSelectionRight = 0,
		NextSelectionLeft = 0
	}
	local v12 = if index < props.itemsPerRow then refCache[index + 1] else nil
	v10.NextSelectionRight = v12
	local v13 = if index > 1 then refCache[index - 1] else nil
	v10.NextSelectionLeft = v13

	local createElement2 = React.createElement
	local v17 = if v5 then tostring(v5.id) else nil
	local v18 = if v5 then v5.type else nil
	local v16 = {
		itemId = v17,
		itemType = v18,
		index = props.index,
		analyticsItemCountPerPage = props.analyticsItemCountPerPage,
		analyticsContext = module6.AnalyticsContext.Catalog,
		widgetAnalyticsInfo = v9,
		itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
		resultsListRef = props.resultsListRef,
		itemCreatorNamesEnabled = props.creatorNameFooterEnabled,
		creatorNameTileFooterEnabled = props.creatorNameTileFooterEnabled,
		cardStyle = props.cardStyle,
		imageScaleType = props.imageScaleType,
		tileWidth = props.size.X.Offset,
		onThumbnailLoaded = 0,
		isCreatorNameVisible = 0,
		isTitleVisible = 0,
		isPriceVisible = 0,
		lookData = 0,
		hydratedContent = 0,
		tileContentType = 0,
		thumbailAspectRatio = 0,
		thumbnailSize = 0,
		impressionsCategory = 0,
		impressionsSubcategory = 0,
		impressionsTaxonomyId = 0,
		adTrackingData = 0
	}
	local v19 = if props.onThumbnailLoaded then props.onThumbnailLoaded else nil
	v16.onThumbnailLoaded = v19
	v16.isCreatorNameVisible = props.isCreatorNameVisible
	v16.isTitleVisible = props.isTitleVisible
	v16.isPriceVisible = props.isPriceVisible
	v16.lookData = if v6 then v5 else nil

	if v6 then
		v5 = nil
	end

	v16.hydratedContent = v5
	v16.tileContentType = props.tileContentType
	local v21

	if v6 then
		v21 = module7.LookTileAspectRatio
	elseif fFlagAXTallTilesForAdvancedBodiesWidget and props.isTallTile then
		v21 = module7.ItemTileTallAspectRatio
	end

	v16.thumbailAspectRatio = v21
	local v22

	if v6 then
		v22 = "w=300&h=450"
	elseif fFlagAXTallTilesForAdvancedBodiesWidget and props.isTallTile then
		v22 = module9()
	end

	v16.thumbnailSize = v22

	v16.impressionsCategory = impressionsCategory
	v16.impressionsSubcategory = impressionsSubcategory
	v16.impressionsTaxonomyId = impressionsTaxonomyId
	local v23 = if fFlagAXSduiSponsoredItemClickTracking then props.adTrackingData else nil
	v16.adTrackingData = v23
	return createElement(frame, v10, { WidgetItemTile = createElement2(module5, v16) })
end

return WidgetTileWithImpressionsTagging
