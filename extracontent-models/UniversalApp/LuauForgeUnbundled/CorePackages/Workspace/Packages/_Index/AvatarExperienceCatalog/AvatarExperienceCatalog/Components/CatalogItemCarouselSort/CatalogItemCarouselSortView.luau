local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation").Hooks.useTokens
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceUIKit")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Impressions")
local useImpressionsTagger = Impressions.useImpressionsTagger
local screenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib")
local scrollingAppCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppBlox").ScrollingAppCarousel

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

local function CatalogItemCarouselSortView(props, p2)
	useImpressionsTagger(props.containerRef, WidgetConstants.WidgetExposureMetadata.TagName, props.widgetRow)
	local v5 = useTokens()
	local v6 = props.headerText ~= nil and props.headerText ~= ""
		or props.headerDescription ~= nil and props.headerDescription ~= ""
		or props.seeAllCallback ~= nil

	local v7 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, props.itemGap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}

	for k, visibleItem in props.visibleItems do
		v7[`item-{visibleItem.absoluteIndex}`] = props.renderTile(
			{
				id = visibleItem.id,
				type = visibleItem.type,
				gridInformation = visibleItem.gridInformation
			},
			visibleItem.absoluteIndex
		)
	end

	local createElement = React.createElement

	local newUDim = UDim.new
	local v12

	if fFlagAXSduiSortLegacyBottomPadding then
		v12 = v5.Size.Size_600
	else
		v12 = if fFlagAXCatalogUseFixedWidgetPadding then v5.Size.Size_800 else resolveWidgetListItemBottomPaddingPx(v5)
	end

	local v9 = {
		ref = p2,
		padding = { bottom = newUDim(0, v12) },
		horizontalMargin = props.horizontalMargin
	}

	local createElement2 = React.createElement
	local v16

	if v6 then
		local createElement3 = React.createElement
		local v18 = {
			titleText = props.headerText,
			descriptionText = props.headerDescription,
			informationPopoverText = 0,
			onInformationIconActivated = 0,
			seeAllCallback = 0,
			seeAllRef = 0,
			LayoutOrder = 1
		}

		local v19 = if fFlagAXCatalogItemInformationPopover then props.informationPopoverText else nil
		v18.informationPopoverText = v19

		local v20 = if fFlagAXCatalogItemInformationPopover then props.onInformationIconActivated else nil
		v18.onInformationIconActivated = v20

		v18.seeAllCallback = props.seeAllCallback
		local v21 = if fFlagAXSduiSeeAllClickLogging then props.seeAllRef else nil
		v18.seeAllRef = v21
		v16 = createElement3(widgetHeader, v18)
	end

	return createElement(widgetListItem, v9, {
		Widget = createElement2(widgetLayout, {
			headerSlot = v16,
			contentSlot = React.createElement(React.Fragment, nil, {
				["Widget_" .. props.widgetId] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ref = props.containerRef,
					[React.Tag] = "data-testid=CatalogItemCarouselSortView"
				}, React.createElement(scrollingAppCarousel, {
					items = v7,
					index = math.max(
						1,
						(math.min(props.carouselIndex, (math.max(1, props.carouselItemCount))))
					),
					styleProps = props.carouselArrowStyleProps,
					itemCount = props.carouselItemCount,
					itemWidth = math.max(1, props.itemWidth),
					itemPadding = props.itemGap,
					carouselMargin = props.carouselMargin,
					carouselHeight = 0,
					canvasWidth = math.max(1, props.canvasWidth),
					onChangeCanvasPosition = props.onScrollChanged,
					onRefCallback = props.onScrollChanged,
					shouldExpandToFitContentHeight = true
				})),
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

return React.forwardRef(CatalogItemCarouselSortView)
