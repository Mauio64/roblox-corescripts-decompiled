local ParentParent = script.Parent.Parent.Parent
local Core = ParentParent.Core
local ParentParentParent = ParentParent.Parent
local t = require(ParentParentParent.t)
local Roact = require(ParentParentParent.Roact)
local withStyle = require(Core.Style.withStyle)
local v7 = Roact.PureComponent:extend("ListTable")

v7.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	showDividers = t.optional(t.boolean),
	dividerStartOffset = t.optional(t.number),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	automaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	cells = t.array(t.table)
})
v7.defaultProps = {
	showDividers = true,
	dividerStartOffset = 24
}

function v7.render(p1) -- line: 49
	-- upvalues: withStyle (copy), Roact (copy)
	return withStyle(function(p2) -- line: 50
		-- upvalues: p1 (copy), Roact (copy)
		local size = p1.props.size
		local automaticSize = p1.props.automaticSize

		if not size then
			size = if not automaticSize then UDim2.fromScale(1, 1) else if automaticSize ~= Enum.AutomaticSize.X then if automaticSize ~= Enum.AutomaticSize.Y then if automaticSize ~= Enum.AutomaticSize.XY then UDim2.fromScale(1, 1) else UDim2.fromScale(0, 0) else UDim2.fromScale(1, 0) else UDim2.fromScale(0, 1)
		end

		local t1 = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}
		local cells = p1.props.cells

		for i, v in ipairs(cells) do
			local v16 = "Cell " .. i
			local v17 = p1.props.showDividers and i < #cells

			t1[v16] = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Content = v,
				Divider = v17 and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 100,
					Size = UDim2.new(1, -p1.props.dividerStartOffset, 0, 1),
					Position = UDim2.new(0, p1.props.dividerStartOffset, 1, -1),
					BackgroundColor3 = p2.Theme.Divider.Color,
					BackgroundTransparency = p2.Theme.Divider.Transparency
				}) or nil
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			Size = size,
			AutomaticSize = automaticSize,
			AnchorPoint = p1.props.anchorPoint,
			Position = p1.props.position
		}, t1)
	end)
end

return v7
