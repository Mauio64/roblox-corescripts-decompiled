local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local v5 = Roact.PureComponent:extend("MoreGrid")
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection

v5.defaultProps = {
	layoutOrder = 1,
	size = UDim2.fromScale(1, 1)
}
v5.validateProps = t.strictInterface({
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	gridCellPadding = t.integer,
	gridCellSize = t.integer,
	items = t.table,
	layoutOrder = t.optional(t.integer),
	renderItem = t.callback,
	size = t.optional(t.UDim2)
})

function v5.render(p1) -- line: 25
	-- upvalues: Roact (copy), FFlagLuaAppsDefaultSelection (copy)
	local gridCellPadding = p1.props.gridCellPadding
	local gridCellSize = p1.props.gridCellSize
	local items = p1.props.items
	local layoutOrder = p1.props.layoutOrder
	local renderItem = p1.props.renderItem
	local size = p1.props.size
	local uDim2 = UDim2.fromOffset(gridCellPadding, gridCellPadding)
	local uDim2_2 = UDim2.fromOffset(gridCellSize, gridCellSize)
	local t1 = {}

	for i, v in ipairs(items) do
		t1[i] = renderItem(v, i)
	end

	t1.GridLayout = Roact.createElement("UIGridLayout", {
		CellPadding = uDim2,
		CellSize = uDim2_2,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return Roact.createElement("Frame", {
		[Roact.Ref] = if not FFlagLuaAppsDefaultSelection then nil else p1.props.defaultFocusRef,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Size = size
	}, t1)
end

return v5
