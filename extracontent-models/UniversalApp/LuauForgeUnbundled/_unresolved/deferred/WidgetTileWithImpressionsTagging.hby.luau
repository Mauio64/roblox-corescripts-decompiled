local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useImpressionsTagger = require("@luauforge/bundled/egA").useImpressionsTagger
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module = require("@luauforge/deferred/hbz")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local fFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget
local fFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration
local fFlagAXSduiSponsoredItemClickTracking = AvatarExperienceFlags.FFlagAXSduiSponsoredItemClickTracking
local fFlagAXSduiCarouselTileLayoutOrder = AvatarExperienceFlags.FFlagAXSduiCarouselTileLayoutOrder

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module4 = require("@luauforge/bundled/dPt")
local module5 = require("@luauforge/deferred/hbA")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local module6 = require("@luauforge/bundled/dPU")
local itemTypeEnum = module4.Enums.ItemTypeEnum
local module7 = require("@luauforge/bundled/dPN")

local module8 = require("@luauforge/deferred/hbN")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module9 = require("@luauforge/deferred/hbO")

local function WidgetTileWithImpressionsTagging(props)
	useImpressionsTagger(props.refCache[props.index], props.impressionsTag, props.index)

	local contentType = props.contentType
	local contentId = props.contentId
	local index = props.index
	local refCache = props.refCache

	local v6 = useSelector(function(p2)
		local v7 = p2.AvatarExperience.Common.Widgets.HydratedWidgetData[contentType]

		if v7 then
			return v7[tostring(contentId)]
		end

		return nil
	end, getUseSelectorDeepEquals())

	local v7 = v6 and v6.type == itemTypeEnum.Look

	local v8 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarScene.AvatarRoute.opaque.name
	end, getUseSelectorDeepEquals())
	local v9

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		v9 = module8(
			v8 == avatarScreen.CatalogSearch,
			props.selectedCategory,
			props.selectedSubcategory,
			props.selectedCategoryInfo
		)
	else
		v9 = module8(v8 == avatarScreen.CatalogSearch)
	end

	local impressionsCategory = v9.impressionsCategory
	local impressionsSubcategory = v9.impressionsSubcategory
	local impressionsTaxonomyId = v9.impressionsTaxonomyId

	local lookType = v6 and v6.lookType
	local widgetAnalyticsInfo = props.widgetAnalyticsInfo
	local v10 = React.useMemo(function()
		if fFlagAXDeferLookImpressionsForHydration then
			return module(widgetAnalyticsInfo, lookType)
		end

		return widgetAnalyticsInfo
	end, { widgetAnalyticsInfo, lookType })

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v11 = {
		Size = UDim2.new(props.size.X, UDim.new()),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = if fFlagAXSduiCarouselTileLayoutOrder then index else nil,
		ref = refCache[index],
		NextSelectionRight = 0,
		NextSelectionLeft = 0
	}
	local v13 = if index < props.itemsPerRow then refCache[index + 1] else nil
	v11.NextSelectionRight = v13
	local v14 = if index > 1 then refCache[index - 1] else nil
	v11.NextSelectionLeft = v14

	local createElement2 = React.createElement
	local v18 = if v6 then tostring(v6.id) else nil
	local v19 = if v6 then v6.type else nil
	local v17 = {
		itemId = v18,
		itemType = v19,
		index = props.index,
		analyticsItemCountPerPage = props.analyticsItemCountPerPage,
		analyticsContext = module6.AnalyticsContext.Catalog,
		widgetAnalyticsInfo = v10,
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
	local v20 = if props.onThumbnailLoaded then props.onThumbnailLoaded else nil
	v17.onThumbnailLoaded = v20
	v17.isCreatorNameVisible = props.isCreatorNameVisible
	v17.isTitleVisible = props.isTitleVisible
	v17.isPriceVisible = props.isPriceVisible
	v17.lookData = if v7 then v6 else nil

	if v7 then
		v6 = nil
	end

	v17.hydratedContent = v6
	v17.tileContentType = props.tileContentType
	local v22

	if v7 then
		v22 = module7.LookTileAspectRatio
	elseif fFlagAXTallTilesForAdvancedBodiesWidget and props.isTallTile then
		v22 = module7.ItemTileTallAspectRatio
	end

	v17.thumbailAspectRatio = v22
	local v23

	if v7 then
		v23 = "w=300&h=450"
	elseif fFlagAXTallTilesForAdvancedBodiesWidget and props.isTallTile then
		v23 = module9()
	end

	v17.thumbnailSize = v23

	v17.impressionsCategory = impressionsCategory
	v17.impressionsSubcategory = impressionsSubcategory
	v17.impressionsTaxonomyId = impressionsTaxonomyId
	local v24 = if fFlagAXSduiSponsoredItemClickTracking then props.adTrackingData else nil
	v17.adTrackingData = v24
	return createElement(frame, v11, { WidgetItemTile = createElement2(module5, v17) })
end

return WidgetTileWithImpressionsTagging
