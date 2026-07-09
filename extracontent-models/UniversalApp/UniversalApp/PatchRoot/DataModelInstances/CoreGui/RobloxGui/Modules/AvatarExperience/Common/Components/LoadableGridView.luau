local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local GridMetrics = UIBlox.App.Grid.GridMetrics
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v13 = Roact.PureComponent:extend("LoadableGridView")

v13.validateProps = t.strictInterface({
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
v13.defaultProps = {
	getItemMetrics = GridMetrics.getSmallMetrics
}

function v13.render(p1) -- line: 48
	-- upvalues: Roact (copy), DefaultMetricsGridView (copy), Constants (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy)
	local items = p1.props.items
	local totalNumItems = p1.props.totalNumItems
	local propsLayoutOrder = p1.props.LayoutOrder
	local getItemHeight = p1.props.getItemHeight
	local windowHeight = p1.props.windowHeight
	local getItemMetrics = p1.props.getItemMetrics

	if not items then
		items = {}

		for i = 1, totalNumItems do
			items[i] = {}
		end
	end

	local forwardRef = p1.props.forwardRef
	local v23 = Roact.createElement(DefaultMetricsGridView, {
		renderItem = p1.props.renderItem,
		windowHeight = windowHeight,
		getItemHeight = getItemHeight,
		getItemMetrics = getItemMetrics,
		itemPadding = Vector2.new(Constants.LoadableGridViewCellPadding, Constants.LoadableGridViewCellPadding),
		items = items,
		maxHeight = 1e999,
		LayoutOrder = propsLayoutOrder,
		NextSelectionUp = p1.props.NextSelectionUp,
		NextSelectionDown = p1.props.NextSelectionDown,
		NextSelectionRight = p1.props.NextSelectionRight,
		NextSelectionLeft = p1.props.NextSelectionLeft,
		[Roact.Ref] = forwardRef,
		defaultChildIndex = 1,
		restorePreviousChildFocus = p1.props.restorePreviousChildFocus,
		onFocusGained = p1.props.onFocusGained,
		onNumItemsPerRowChanged = p1.props.onNumItemsPerRowChanged,
		isRoactGamepadEnabled = not FFlagAXMigrateAXToGlobalAutofocus and nil
	})

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = propsLayoutOrder,
		SelectionGroup = not not FFlagAXScrollingFramesShouldAnimateOnFocus or nil,
		[Roact.Change.AbsoluteSize] = p1.props.onAbsoluteSizeChanged
	}, {
		DefaultMetricsGridView = v23
	})
end

return Roact.forwardRef(function(p2, p3) -- line: 97
	-- upvalues: Roact (copy), v13 (copy), Cryo (copy)
	return Roact.createElement(v13, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)
