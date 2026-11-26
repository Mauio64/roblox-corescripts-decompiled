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

local function HeroUnitStacked(props)
	local v5 = module6(props.rowWidth)
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
	local v9

	if fFlagAXHeroUnitActionButton then
		v9 = module5(template.button, {
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			tagId = widgetInfo.tagId
		})
	end

	local createElement = React.createElement
	local v11 = {
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
		itemsContentTag = `{v5.cardPaddingTag} padding-top-{stackedSeamScale}`,
		itemsContentLayout = fFlagAXHeroUnitActionButton and v9 and {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v5.stackedActionButtonGapPx),
			SortOrder = Enum.SortOrder.LayoutOrder
		} or nil
	}

	local v12 = {
		ItemRow = React.createElement(module2, {
			LayoutOrder = fFlagAXHeroUnitActionButton and 1 or nil,
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
		}),
		ActionButton = 0
	}

	local v13 = if fFlagAXHeroUnitActionButton and v9 then React.createElement(module4, {
		action = v9,
		size = v5.spotlightButtonSize,
		width = v6,
		LayoutOrder = 2,
		testId = `--avatar-marketplace-herounit-actionbutton-{widgetInfo.id}`
	}) else nil
	v12.ActionButton = v13
	return createElement(module3, v11, v12)
end

return HeroUnitStacked
