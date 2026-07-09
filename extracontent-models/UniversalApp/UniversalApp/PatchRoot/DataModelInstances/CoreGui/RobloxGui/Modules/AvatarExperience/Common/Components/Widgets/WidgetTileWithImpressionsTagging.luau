local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useImpressionsTagger = require(CorePackages.Workspace.Packages.Impressions).useImpressionsTagger

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local applyWidgetTileLookTypeOverride = require(script.Parent.applyWidgetTileLookTypeOverride)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local FFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget
local FFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogItemCardContainer = require(Modules.AvatarExperience.Catalog.Components.ItemsList.CatalogItemCardContainer)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local Constants = require(Modules.AvatarExperience.Common.Constants)
local useCatalogCategoryImpressionsInfo = require(Modules.AvatarExperience.Catalog.Hooks.useCatalogCategoryImpressionsInfo)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local GetFStringAXTallTilesThumbnailSize = require(Modules.AvatarExperience.Flags.GetFStringAXTallTilesThumbnailSize)
local FFlagAXHeroWidget = AvatarExperienceFlags.FFlagAXHeroWidget

local function WidgetTileWithImpressionsTagging(t1: {[any]: any}) -- line: 64
	-- upvalues: useImpressionsTagger (copy), useSelector (copy), getUseSelectorDeepEquals (copy), ItemTypeEnum (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy), useCatalogCategoryImpressionsInfo (copy), AvatarScreen (copy), React (copy), FFlagAXDeferLookImpressionsForHydration (copy), applyWidgetTileLookTypeOverride (copy), RoactGamepad (copy), CatalogItemCardContainer (copy), CatalogConstants (copy), FFlagAXHeroWidget (copy), Constants (copy), FFlagAXTallTilesForAdvancedBodiesWidget (copy), GetFStringAXTallTilesThumbnailSize (copy)
	local v24 = t1.refCache[t1.index]

	useImpressionsTagger(v24, t1.impressionsTag, t1.index)

	local contentType = t1.contentType
	local contentId = t1.contentId
	local index = t1.index
	local refCache = t1.refCache
	local v29 = useSelector(function(p1) -- line: 73
		-- upvalues: contentType (copy), contentId (copy)
		local v40 = p1.AvatarExperience.Common.Widgets.HydratedWidgetData[contentType]

		if v40 then
			return v40[tostring(contentId)]
		end

		return nil
	end, getUseSelectorDeepEquals())
	local v30 = v29 and v29.type == ItemTypeEnum.Look
	local v31 = useSelector(function(p2) -- line: 82
		return p2.AvatarExperience.AvatarScene.AvatarRoute.opaque.name
	end, getUseSelectorDeepEquals())
	local v32 = if not FFlagAXCatalogCategoriesStoreImprovePerf then useCatalogCategoryImpressionsInfo(v31 == AvatarScreen.CatalogSearch) else useCatalogCategoryImpressionsInfo(v31 == AvatarScreen.CatalogSearch, t1.selectedCategory, t1.selectedSubcategory, t1.selectedCategoryInfo)
	local impressionsCategory = v32.impressionsCategory
	local impressionsSubcategory = v32.impressionsSubcategory
	local impressionsTaxonomyId = v32.impressionsTaxonomyId
	local v36 = v29 and v29.lookType
	local widgetAnalyticsInfo = t1.widgetAnalyticsInfo
	local v38 = React.useMemo(function() -- line: 119
		-- upvalues: FFlagAXDeferLookImpressionsForHydration (copy), widgetAnalyticsInfo (copy), applyWidgetTileLookTypeOverride (copy), v36 (copy)
		if not FFlagAXDeferLookImpressionsForHydration then
			return widgetAnalyticsInfo
		end

		return applyWidgetTileLookTypeOverride(widgetAnalyticsInfo, v36)
	end, {
		widgetAnalyticsInfo,
		v36
	})

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(t1.size.X, UDim.new()),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = refCache[index],
		NextSelectionRight = if not (index < t1.itemsPerRow) then nil else refCache[index + 1],
		NextSelectionLeft = if not (index > 1) then nil else refCache[index - 1]
	}, {
		WidgetItemTile = React.createElement(CatalogItemCardContainer, {
			itemId = if not v29 then nil else tostring(v29.id),
			itemType = if not v29 then nil else v29.type,
			index = t1.index,
			analyticsItemCountPerPage = t1.analyticsItemCountPerPage,
			analyticsContext = CatalogConstants.AnalyticsContext.Catalog,
			widgetAnalyticsInfo = v38,
			itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
			resultsListRef = t1.resultsListRef,
			itemCreatorNamesEnabled = t1.creatorNameFooterEnabled,
			creatorNameTileFooterEnabled = t1.creatorNameTileFooterEnabled,
			cardStyle = t1.cardStyle,
			imageScaleType = if not FFlagAXHeroWidget then nil else t1.imageScaleType,
			tileWidth = t1.size.X.Offset,
			onThumbnailLoaded = if not t1.onThumbnailLoaded then nil else t1.onThumbnailLoaded,
			isCreatorNameVisible = t1.isCreatorNameVisible,
			isTitleVisible = t1.isTitleVisible,
			isPriceVisible = t1.isPriceVisible,
			lookData = if not v30 then nil else v29,
			hydratedContent = if v30 then nil else v29,
			tileContentType = t1.tileContentType,
			thumbailAspectRatio = if not v30 then if not FFlagAXTallTilesForAdvancedBodiesWidget or not t1.isTallTile then nil else Constants.ItemTileTallAspectRatio else Constants.LookTileAspectRatio,
			thumbnailSize = if not v30 then if not FFlagAXTallTilesForAdvancedBodiesWidget or not t1.isTallTile then nil else GetFStringAXTallTilesThumbnailSize() else "w=300&h=450",
			impressionsCategory = impressionsCategory,
			impressionsSubcategory = impressionsSubcategory,
			impressionsTaxonomyId = impressionsTaxonomyId
		})
	})
end

return WidgetTileWithImpressionsTagging
