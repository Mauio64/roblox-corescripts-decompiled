local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(Modules.AvatarExperience.Common.Types)

local HeroItemRow = require(Modules.AvatarExperience.Common.Components.Widgets.HeroItemRow)
local HeroUnitMultiItemFrame = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitMultiItemFrame)
local useHeroUnitResponsiveStyle = require(Modules.AvatarExperience.Common.Components.Widgets.useHeroUnitResponsiveStyle)

local function HeroUnitSideBySide(t1: {[any]: any}) -- line: 48
	-- upvalues: useHeroUnitResponsiveStyle (copy), React (copy), HeroUnitMultiItemFrame (copy), HeroItemRow (copy)
	local v9 = useHeroUnitResponsiveStyle(t1.rowWidth)
	local widgetInfo = t1.widgetInfo
	local template = widgetInfo.template
	local v12 = if not template.widgetStyle or not template.widgetStyle.backgroundLayers then nil else template.widgetStyle.backgroundLayers
	local availableUntil = template.availableUntil
	local cardPaddingPx = v9.cardPaddingPx
	local v15 = math.max(1, (math.floor(t1.rowWidth * 0.4)))
	local v16 = math.max(1, t1.rowWidth - v15)
	local v17 = math.max(1, v16 - 2 * cardPaddingPx)
	local v18 = math.max(1, t1.itemsPerRow)
	local itemGapPx = v9.itemGapPx
	local v20 = math.max(1, (math.floor((v17 - (v18 - 1) * itemGapPx) / v18)))
	local v21 = math.min(#if not widgetInfo.content then {} else widgetInfo.content, v18)
	local v22 = math.min(v16, math.max(1, v21 * v20 + math.max(0, (v21 - 1) * itemGapPx)) + 2 * cardPaddingPx)
	local v23 = math.max(1, t1.rowWidth - v22)

	return React.createElement(HeroUnitMultiItemFrame, {
		direction = "row",
		itemsClipTag = "auto-y clip",
		backgroundLayers = v12,
		header = {
			size = UDim2.fromOffset(v23, 0),
			paddingTag = `col align-x-left size-full { v9.cardPaddingTag }`,
			props = {
				centerTitleGroup = true,
				titleText = template.localizedTitle,
				titleTag = v9.titleTag,
				descriptionText = template.localizedDescription,
				descriptionTag = v9.descriptionTag,
				titleGroupGapTag = v9.titleGroupGapTag,
				availableUntil = availableUntil
			}
		},
		itemsClipSize = UDim2.new(0, v22, 0, 0),
		itemsContentTag = `size-full-0 auto-y { v9.cardPaddingTag }`
	}, {
		ItemRow = React.createElement(HeroItemRow, {
			widgetInfo = widgetInfo,
			widgetConfiguration = t1.widgetConfiguration,
			widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
			widgetRow = t1.widgetRow,
			itemWidth = v20,
			itemsPerRow = t1.itemsPerRow,
			impressionsTag = t1.impressionsTag,
			resultsListRef = t1.resultsListRef,
			itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
			hydratedWidgetData = t1.hydratedWidgetData,
			onThumbnailLoaded = t1.onThumbnailLoaded,
			selectedCategory = t1.selectedCategory,
			selectedSubcategory = t1.selectedSubcategory,
			selectedCategoryInfo = t1.selectedCategoryInfo
		})
	})
end

return HeroUnitSideBySide
