local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dMc")

local module = require("@luauforge/deferred/gQc")
local module2 = require("@luauforge/deferred/gQd")

local module3 = require("@luauforge/deferred/gQa")

local function HeroUnitSideBySide(props)
	local v5 = module3(props.rowWidth)
	local widgetInfo = props.widgetInfo
	local template = widgetInfo.template
	local backgroundLayers

	if template.widgetStyle and template.widgetStyle.backgroundLayers then
		backgroundLayers = template.widgetStyle.backgroundLayers
	end

	local availableUntil = template.availableUntil

	local cardPaddingPx = v5.cardPaddingPx

	local v6 = math.max(1, (math.floor(props.rowWidth * 0.4)))
	local v7 = math.max(1, props.rowWidth - v6)
	local v8 = math.max(1, v7 - 2 * cardPaddingPx)
	local v9 = math.max(1, props.itemsPerRow)
	local itemGapPx = v5.itemGapPx
	local v10 = math.max(1, (math.floor((v8 - (v9 - 1) * itemGapPx) / v9)))

	local v11 = math.min(#(not widgetInfo.content and {} or widgetInfo.content), v9)
	local v12 = math.min(
		v7,
		math.max(1, v11 * v10 + math.max(0, (v11 - 1) * itemGapPx)) + 2 * cardPaddingPx
	)
	local v13 = math.max(1, props.rowWidth - v12)

	return React.createElement(module2, {
		direction = "row",
		backgroundLayers = backgroundLayers,
		header = {
			size = UDim2.fromOffset(v13, 0),
			paddingTag = `col align-x-left size-full {v5.cardPaddingTag}`,
			props = {
				titleText = template.localizedTitle,
				titleTag = v5.titleTag,
				descriptionText = template.localizedDescription,
				descriptionTag = v5.descriptionTag,
				titleGroupGapTag = v5.titleGroupGapTag,
				availableUntil = availableUntil,
				centerTitleGroup = true
			}
		},
		itemsClipSize = UDim2.new(0, v12, 0, 0),
		itemsClipTag = "auto-y clip",
		itemsContentTag = `size-full-0 auto-y {v5.cardPaddingTag}`
	}, {
		ItemRow = React.createElement(module, {
			widgetInfo = widgetInfo,
			widgetConfiguration = props.widgetConfiguration,
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			itemWidth = v10,
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

return HeroUnitSideBySide
