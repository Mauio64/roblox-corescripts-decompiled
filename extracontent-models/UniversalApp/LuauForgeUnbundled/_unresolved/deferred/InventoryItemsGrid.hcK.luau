local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/deferred/gPt")

local gridMetrics = UIBlox.App.Grid.GridMetrics
local grid = module.GridComponents.Grid
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module3 = require("@luauforge/bundled/dRg")

local fFlagAXSlotsInventoryLoadableGridView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsInventoryLoadableGridView

local function InventoryItemsGrid(props)
	local renderItem = props.renderItem
	local itemsPerRow = props.itemsPerRow

	local v5 = React.useCallback(function(p2, p3, p4)
		return renderItem({ item = p2, index = p3, gridInformation = p4 })
	end, { renderItem })

	local v6 = React.useCallback(function(p2)
		return `{p2.itemId}{itemsPerRow}`
	end, { itemsPerRow })

	if fFlagAXSlotsInventoryLoadableGridView then
		return React.createElement(DefaultMetricsGridView, {
			getItemMetrics = gridMetrics.makeCustomMetricsGetter(module3.ItemsGridMetrics),
			items = props.items,
			getItemHeight = props.getItemHeight,
			totalNumItems = props.totalNumItems,
			renderItem = v5,
			windowHeight = props.screenHeight,
			ref = props.gridRef
		})
	end

	return React.createElement(grid, {
		AutomaticSize = Enum.AutomaticSize.Y,
		itemsPerRow = itemsPerRow,
		renderItem = renderItem,
		items = props.items,
		gapVertical = props.itemsGap,
		gapHorizontal = props.itemsGap,
		getItemId = v6,
		ref = props.gridRef
	})
end

return InventoryItemsGrid
