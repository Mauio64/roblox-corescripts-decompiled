local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation").Hooks.useTokens
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceUIKit")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Impressions")
local useImpressionsTagger = Impressions.useImpressionsTagger
local screenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local fFlagAXCatalogUseFixedWidgetPadding = AvatarExperienceFlags.FFlagAXCatalogUseFixedWidgetPadding
local fFlagAXSduiSeeAllClickLogging = AvatarExperienceFlags.FFlagAXSduiSeeAllClickLogging
local fFlagAXSduiSortLegacyBottomPadding = AvatarExperienceFlags.FFlagAXSduiSortLegacyBottomPadding

local WidgetConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/WidgetConstants")
local resolveWidgetListItemBottomPaddingPx = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/resolveWidgetListItemBottomPaddingPx")

local widgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local widgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local widgetListItem = AvatarExperienceUIKit.WidgetComponents.WidgetListItem
local grid = AvatarExperienceUIKit.GridComponents.Grid

local function CatalogItemGroupSortView(props, p2)
	useImpressionsTagger(props.containerRef, WidgetConstants.WidgetExposureMetadata.TagName, props.widgetRow)
	local v5 = useTokens()
	local v6 = props.headerText ~= nil and props.headerText ~= ""
		or props.headerDescription ~= nil and props.headerDescription ~= ""
		or props.seeAllCallback ~= nil

	local function fn(data)
		local item = data.item
		return props.renderTile(
			{ id = item.id, type = item.type, gridInformation = data.gridInformation },
			data.index
		)
	end

	local function fn2(p3)
		return tostring(p3.id) .. "_" .. tostring(props.itemsPerRow)
	end

	local createElement = React.createElement

	local newUDim = UDim.new
	local v11

	if fFlagAXSduiSortLegacyBottomPadding then
		v11 = v5.Size.Size_600
	else
		v11 = if fFlagAXCatalogUseFixedWidgetPadding then v5.Size.Size_800 else resolveWidgetListItemBottomPaddingPx(v5)
	end

	local v8 = {
		ref = p2,
		padding = { bottom = newUDim(0, v11) },
		horizontalMargin = props.horizontalMargin
	}

	local createElement2 = React.createElement
	local v15

	if v6 then
		local createElement3 = React.createElement
		local v17 = {
			titleText = props.headerText,
			descriptionText = props.headerDescription,
			informationPopoverText = 0,
			onInformationIconActivated = 0,
			seeAllCallback = 0,
			seeAllRef = 0,
			LayoutOrder = 1
		}

		local v18 = if fFlagAXCatalogItemInformationPopover then props.informationPopoverText else nil
		v17.informationPopoverText = v18

		local v19 = if fFlagAXCatalogItemInformationPopover then props.onInformationIconActivated else nil
		v17.onInformationIconActivated = v19

		v17.seeAllCallback = props.seeAllCallback
		local v20 = if fFlagAXSduiSeeAllClickLogging then props.seeAllRef else nil
		v17.seeAllRef = v20
		v15 = createElement3(widgetHeader, v17)
	end

	return createElement(widgetListItem, v8, {
		Widget = createElement2(widgetLayout, {
			headerSlot = v15,
			contentSlot = React.createElement(React.Fragment, nil, {
				["Widget_" .. props.widgetId] = React.createElement(grid, {
					itemsPerRow = props.itemsPerRow,
					renderItem = fn,
					getItemId = fn2,
					items = props.gridItems,
					gapVertical = props.itemGap,
					gapHorizontal = props.itemGap,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = props.containerRef,
					[React.Tag] = "data-testid=CatalogItemGroupSortView"
				}),
				ImpressionsDetector = React.createElement(screenSizeImpressionsDetector, {
					onRequestImpressionsSignal = props.onItemsUpdatedSignal,
					onImpressionsDetected = props.onImpressionsDetected,
					filterImpressionFunc = props.filterImpressionFunc,
					impressionsTag = props.impressionsKey
				})
			})
		})
	})
end

return React.forwardRef(CatalogItemGroupSortView)
