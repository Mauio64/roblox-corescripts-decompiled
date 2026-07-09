local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(Modules.AvatarExperience.Common.Types)

local HeroItemRow = require(Modules.AvatarExperience.Common.Components.Widgets.HeroItemRow)
local HeroUnitMultiItemFrame = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitMultiItemFrame)
local useHeroUnitResponsiveStyle = require(Modules.AvatarExperience.Common.Components.Widgets.useHeroUnitResponsiveStyle)

local function HeroUnitStacked(t1: {[any]: any}) -- line: 41
	-- upvalues: useHeroUnitResponsiveStyle (copy), React (copy), HeroUnitMultiItemFrame (copy), HeroItemRow (copy)
	local v9 = useHeroUnitResponsiveStyle(t1.rowWidth)
	local widgetInfo = t1.widgetInfo
	local template = widgetInfo.template
	local v12 = if not template.widgetStyle or not template.widgetStyle.backgroundLayers then nil else template.widgetStyle.backgroundLayers
	local availableUntil = template.availableUntil
	local v14 = math.max(1, t1.rowWidth - 2 * v9.cardPaddingPx)
	local v15 = math.max(1, t1.itemsPerRow)
	local itemGapPx = v9.itemGapPx
	local v17 = math.max(1, (math.floor((v14 - (v15 - 1) * itemGapPx) / v15)))
	local stackedSeamScale = v9.stackedSeamScale

	return React.createElement(HeroUnitMultiItemFrame, {
		direction = "col",
		itemsClipTag = "size-full-0 auto-y clip",
		backgroundLayers = v12,
		header = {
			tag = "auto-y",
			size = UDim2.fromScale(1, 0),
			paddingTag = `col align-x-left size-full-0 auto-y { v9.cardPaddingTag } padding-bottom-{ stackedSeamScale }`,
			props = {
				LayoutOrder = 1,
				titleText = template.localizedTitle,
				titleTag = v9.titleTag,
				descriptionText = template.localizedDescription,
				descriptionTag = v9.descriptionTag,
				titleGroupGapTag = v9.titleGroupGapTag,
				badgeGapTag = v9.stackedBadgeGapTag,
				availableUntil = availableUntil
			}
		},
		itemsContentSize = UDim2.new(1, 0, 0, 0),
		itemsContentAutomaticSize = Enum.AutomaticSize.Y,
		itemsContentTag = `{ v9.cardPaddingTag } padding-top-{ stackedSeamScale }`
	}, {
		ItemRow = React.createElement(HeroItemRow, {
			widgetInfo = widgetInfo,
			widgetConfiguration = t1.widgetConfiguration,
			widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
			widgetRow = t1.widgetRow,
			itemWidth = v17,
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

return HeroUnitStacked
