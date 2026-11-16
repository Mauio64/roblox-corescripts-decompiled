local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/ecR")

local extended = module.PureComponent:extend("MoreGrid")

extended.defaultProps = { layoutOrder = 1, size = UDim2.fromScale(1, 1) }

extended.validateProps = t.strictInterface({
	defaultFocusRef = t.optional(t.callback),
	gridCellPadding = t.integer,
	gridCellSize = t.integer,
	items = t.table,
	layoutOrder = t.optional(t.integer),
	renderItem = t.callback,
	size = t.optional(t.UDim2)
})

function extended.render(p2)
	local gridCellPadding = p2.props.gridCellPadding
	local gridCellSize = p2.props.gridCellSize
	local items = p2.props.items
	local layoutOrder = p2.props.layoutOrder
	local renderItem = p2.props.renderItem
	local size = p2.props.size

	local udim = UDim2.fromOffset(gridCellPadding, gridCellPadding)
	local udim2 = UDim2.fromOffset(gridCellSize, gridCellSize)

	local v5 = {}

	for i, item in ipairs(items) do
		v5[i] = renderItem(item, i)
	end

	v5.GridLayout = module.createElement("UIGridLayout", {
		CellPadding = udim,
		CellSize = udim2,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return module.createElement(
		"Frame",
		{
			[module.Ref] = p2.props.defaultFocusRef,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			Size = size
		},
		v5
	)
end

return extended
