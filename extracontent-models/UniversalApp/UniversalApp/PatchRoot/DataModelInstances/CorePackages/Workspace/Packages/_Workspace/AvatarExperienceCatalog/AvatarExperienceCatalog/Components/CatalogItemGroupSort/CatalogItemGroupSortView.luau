local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local useTokens = require(AvatarExperienceCatalogParent.Foundation).Hooks.useTokens
local AvatarExperienceUIKit = require(AvatarExperienceCatalogParent.AvatarExperienceUIKit)
local Impressions = require(AvatarExperienceCatalogParent.Impressions)
local useImpressionsTagger = Impressions.useImpressionsTagger
local ScreenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector

require(AvatarExperienceCatalogParent.AppCommonLib)

local FFlagAXCatalogItemInformationPopover = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogItemInformationPopover
local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local WidgetListItem = AvatarExperienceUIKit.WidgetComponents.WidgetListItem
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local v15 = game:DefineFastInt("WidgetPaddingSizing", 32)

local function resolveBottomPaddingPx(p1) -- line: 48
	-- upvalues: v15 (copy)
	local XXLarge = p1.Padding.XXLarge

	return ({
		[32] = XXLarge,
		[24] = p1.Padding.XXLarge,
		[20] = p1.Padding.XLarge,
		[16] = p1.Padding.Large
	})[v15] or XXLarge
end
local function CatalogItemGroupSortView(t1: {[any]: any}, p2) -- line: 97
	-- upvalues: useImpressionsTagger (copy), WidgetConstants (copy), useTokens (copy), React (copy), WidgetListItem (copy), v15 (copy), WidgetLayout (copy), WidgetHeader (copy), FFlagAXCatalogItemInformationPopover (copy), Grid (copy), ScreenSizeImpressionsDetector (copy)
	useImpressionsTagger(t1.containerRef, WidgetConstants.WidgetExposureMetadata.TagName, t1.widgetRow)

	local v22 = useTokens()
	local v23 = t1.headerText ~= nil and t1.headerText ~= "" or (t1.headerDescription ~= nil and t1.headerDescription ~= "" or t1.seeAllCallback ~= nil)
	local createElement = React.createElement
	local v25 = WidgetListItem
	local t2 = {
		ref = p2
	}
	local t3 = {}
	local new = UDim.new
	local XXLarge = v22.Padding.XXLarge

	t3.bottom = new(0, ({
		[32] = XXLarge,
		[24] = v22.Padding.XXLarge,
		[20] = v22.Padding.XLarge,
		[16] = v22.Padding.Large
	})[v15] or XXLarge)
	t2.padding = t3
	t2.horizontalMargin = t1.horizontalMargin

	return createElement(v25, t2, {
		Widget = React.createElement(WidgetLayout, {
			headerSlot = if not v23 then nil else React.createElement(WidgetHeader, {
				LayoutOrder = 1,
				titleText = t1.headerText,
				descriptionText = t1.headerDescription,
				informationPopoverText = if not FFlagAXCatalogItemInformationPopover then nil else t1.informationPopoverText,
				onInformationIconActivated = if not FFlagAXCatalogItemInformationPopover then nil else t1.onInformationIconActivated,
				seeAllCallback = t1.seeAllCallback
			}),
			contentSlot = React.createElement(React.Fragment, nil, {
				["Widget_" .. t1.widgetId] = React.createElement(Grid, {
					itemsPerRow = t1.itemsPerRow,
					renderItem = function(p3) -- line: 104
						-- upvalues: t1 (copy)
						local item = p3.item

						return t1.renderTile({
							id = item.id,
							type = item.type,
							gridInformation = p3.gridInformation
						}, p3.index)
					end,
					getItemId = function(p4) -- line: 113
						-- upvalues: t1 (copy)
						return tostring(p4.id) .. "_" .. tostring(t1.itemsPerRow)
					end,
					items = t1.gridItems,
					gapVertical = t1.itemGap,
					gapHorizontal = t1.itemGap,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = t1.containerRef,
					[React.Tag] = "data-testid=CatalogItemGroupSortView"
				}),
				ImpressionsDetector = React.createElement(ScreenSizeImpressionsDetector, {
					onRequestImpressionsSignal = t1.onItemsUpdatedSignal,
					onImpressionsDetected = t1.onImpressionsDetected,
					filterImpressionFunc = t1.filterImpressionFunc,
					impressionsTag = t1.impressionsKey
				})
			})
		})
	})
end

return React.forwardRef(CatalogItemGroupSortView)
