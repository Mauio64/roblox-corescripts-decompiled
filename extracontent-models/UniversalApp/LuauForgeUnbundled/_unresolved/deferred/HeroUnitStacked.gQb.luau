local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dMc")

local module = require("@luauforge/deferred/gQc")
local module2 = require("@luauforge/deferred/gQd")

local module3 = require("@luauforge/deferred/gQa")

local function HeroUnitStacked(props)
	local v5 = module3(props.rowWidth)
	local widgetInfo = props.widgetInfo
	local template = widgetInfo.template
	local backgroundLayers

	if template.widgetStyle and template.widgetStyle.backgroundLayers then
		backgroundLayers = template.widgetStyle.backgroundLayers
	end

	local availableUntil = template.availableUntil

	local v6 = math.max(1, props.rowWidth - 2 * v5.cardPaddingPx)
	local v7 = math.max(1, props.itemsPerRow)
	local itemGapPx = v5.itemGapPx
	local v8 = math.max(1, (math.floor((v6 - (v7 - 1) * itemGapPx) / v7)))

	local stackedSeamScale = v5.stackedSeamScale

	return React.createElement(module2, {
		direction = "col",
		backgroundLayers = backgroundLayers,
		header = {
			size = UDim2.fromScale(1, 0),
			tag = "auto-y",
			paddingTag = `col align-x-left size-full-0 auto-y {v5.cardPaddingTag} padding-bottom-{stackedSeamScale}`,
			props = {
				LayoutOrder = 1,
				titleText = template.localizedTitle,
				titleTag = v5.titleTag,
				descriptionText = template.localizedDescription,
				descriptionTag = v5.descriptionTag,
				titleGroupGapTag = v5.titleGroupGapTag,
				badgeGapTag = v5.stackedBadgeGapTag,
				availableUntil = availableUntil
			}
		},
		itemsClipTag = "size-full-0 auto-y clip",
		itemsContentSize = UDim2.new(1, 0, 0, 0),
		itemsContentAutomaticSize = Enum.AutomaticSize.Y,
		itemsContentTag = `{v5.cardPaddingTag} padding-top-{stackedSeamScale}`
	}, {
		ItemRow = React.createElement(module, {
			widgetInfo = widgetInfo,
			widgetConfiguration = props.widgetConfiguration,
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			itemWidth = v8,
			itemsPerRow = props.itemsPerRow,
			impressionsTag = props.impressionsTag,
			resultsListRef = props.resultsListRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			hydratedWidgetData = props.hydratedWidgetData,
			onThumbnailLoaded = props.onThumbnailLoaded,
			selectedCategory = props.selectedCategory,
			selectedSubcategory = props.selectedSubcategory,
			selectedCategoryInfo = props.selectedCategoryInfo
		})
	})
end

return HeroUnitStacked
