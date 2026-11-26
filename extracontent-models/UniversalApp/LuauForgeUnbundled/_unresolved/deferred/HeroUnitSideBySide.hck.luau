local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

require("@luauforge/bundled/dPs")

local module2 = require("@luauforge/deferred/hci")
local module3 = require("@luauforge/deferred/hcj")
local module4 = require("@luauforge/deferred/hcc")
local module5 = require("@luauforge/deferred/hcf")

local module6 = require("@luauforge/deferred/hce")

local fFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

local function HeroUnitSideBySide(props)
	local v5 = module6(props.rowWidth)
	local widgetInfo = props.widgetInfo
	local template = widgetInfo.template
	local backgroundLayers

	if template.widgetStyle and template.widgetStyle.backgroundLayers then
		backgroundLayers = template.widgetStyle.backgroundLayers
	end

	local availableUntil = template.availableUntil

	local cardPaddingPx = v5.cardPaddingPx
	local v6

	if fFlagAXHeroUnitActionButton then
		v6 = module5(template.button, {
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			tagId = widgetInfo.tagId
		})
	end

	local v7 = math.max(1, (math.floor(props.rowWidth * 0.4)))
	local v8 = math.max(1, props.rowWidth - v7)
	local v9 = math.max(1, v8 - 2 * cardPaddingPx)
	local v10 = math.max(1, props.itemsPerRow)
	local itemGapPx = v5.itemGapPx
	local v11 = math.max(1, (math.floor((v9 - (v10 - 1) * itemGapPx) / v10)))

	local v12 = math.min(#(not widgetInfo.content and {} or widgetInfo.content), v10)
	local v13 = math.min(
		v8,
		math.max(1, v12 * v11 + math.max(0, (v12 - 1) * itemGapPx)) + 2 * cardPaddingPx
	)
	local v14 = math.max(1, props.rowWidth - v13)

	local createElement = React.createElement

	local v17 = {
		size = UDim2.fromOffset(v14, 0),
		paddingTag = `col align-x-left size-full {v5.cardPaddingTag}`,
		props = 0
	}
	local v18 = {
		titleText = template.localizedTitle,
		titleTag = v5.titleTag,
		descriptionText = template.localizedDescription,
		descriptionTag = v5.descriptionTag,
		titleGroupGapTag = v5.titleGroupGapTag,
		availableUntil = availableUntil,
		centerTitleGroup = true,
		bottomSlot = 0
	}

	local v19 = if fFlagAXHeroUnitActionButton and v6 then React.createElement(module4, {
		action = v6,
		size = v5.spotlightButtonSize,
		testId = `--avatar-marketplace-herounit-actionbutton-{widgetInfo.id}`
	}) else nil
	v18.bottomSlot = v19
	v17.props = v18
	return createElement(module3, {
		direction = "row",
		backgroundLayers = backgroundLayers,
		header = v17,
		itemsClipSize = UDim2.new(0, v13, 0, 0),
		itemsClipTag = "auto-y clip",
		itemsContentTag = `size-full-0 auto-y {v5.cardPaddingTag}`
	}, {
		ItemRow = React.createElement(module2, {
			widgetInfo = widgetInfo,
			widgetConfiguration = props.widgetConfiguration,
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			itemWidth = v11,
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
