local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/dPN")

local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local gridMetrics = UIBlox.App.Grid.GridMetrics

local extended = Roact.PureComponent:extend("LoadableGridView")

extended.validateProps = t.strictInterface({
	getItemMetrics = t.callback,
	items = t.optional(t.table),
	totalNumItems = t.optional(t.number),
	renderItem = t.callback,
	getItemHeight = t.callback,
	windowHeight = t.optional(t.number),
	LayoutOrder = t.optional(t.number),
	onNumItemsPerRowChanged = t.optional(t.callback),
	onAbsoluteSizeChanged = t.optional(t.callback),
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	forwardRef = t.optional(t.table),
	onFocusGained = t.optional(t.callback),
	restorePreviousChildFocus = t.optional(t.boolean)
})

extended.defaultProps = { getItemMetrics = gridMetrics.getSmallMetrics }

function extended.render(p2)
	local v5 = p2.props.items
	local totalNumItems = p2.props.totalNumItems
	local layoutOrder = p2.props.LayoutOrder
	local getItemHeight = p2.props.getItemHeight
	local windowHeight = p2.props.windowHeight
	local getItemMetrics = p2.props.getItemMetrics

	if not v5 then
		v5 = {}

		for i = 1, totalNumItems do
			v5[i] = {}
		end
	end

	local forwardRef = p2.props.forwardRef
	local element = Roact.createElement(defaultMetricsGridView, {
		renderItem = p2.props.renderItem,
		windowHeight = windowHeight,
		getItemHeight = getItemHeight,
		getItemMetrics = getItemMetrics,
		itemPadding = Vector2.new(module.LoadableGridViewCellPadding, module.LoadableGridViewCellPadding),
		items = v5,
		maxHeight = 1e999,
		LayoutOrder = layoutOrder,
		NextSelectionUp = p2.props.NextSelectionUp,
		NextSelectionDown = p2.props.NextSelectionDown,
		NextSelectionRight = p2.props.NextSelectionRight,
		NextSelectionLeft = p2.props.NextSelectionLeft,
		[Roact.Ref] = forwardRef,
		defaultChildIndex = 1,
		restorePreviousChildFocus = p2.props.restorePreviousChildFocus,
		onFocusGained = p2.props.onFocusGained,
		onNumItemsPerRowChanged = p2.props.onNumItemsPerRowChanged,
		isRoactGamepadEnabled = false
	})

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		SelectionGroup = true,
		[Roact.Change.AbsoluteSize] = p2.props.onAbsoluteSizeChanged
	}, { DefaultMetricsGridView = element })
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
