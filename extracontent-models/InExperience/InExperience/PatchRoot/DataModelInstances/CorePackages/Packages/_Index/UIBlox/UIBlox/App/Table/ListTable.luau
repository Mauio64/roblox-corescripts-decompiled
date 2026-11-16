local parent = script.Parent.Parent.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)
local withStyle = require(core.Style.withStyle)

local extended = Roact.PureComponent:extend("ListTable")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	showDividers = t.optional(t.boolean),
	dividerStartOffset = t.optional(t.number),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	automaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	cells = t.array(t.table)
})

extended.defaultProps = { showDividers = true, dividerStartOffset = 24 }

function extended.render(p)
	return withStyle(function(p2)
		local size = p.props.size
		local automaticSize = p.props.automaticSize

		if not size then
			if automaticSize then
				if automaticSize == Enum.AutomaticSize.X then
					size = UDim2.fromScale(0, 1)
				elseif automaticSize == Enum.AutomaticSize.Y then
					size = UDim2.fromScale(1, 0)
				elseif automaticSize == Enum.AutomaticSize.XY then
					size = UDim2.fromScale(0, 0)
				else
					size = UDim2.fromScale(1, 1)
				end
			else
				size = UDim2.fromScale(1, 1)
			end
		end

		local children = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}

		local cells = p.props.cells

		for i, cell in ipairs(cells) do
			local v = "Cell " .. i
			local v2 = p.props.showDividers and i < #cells
			local createElement = Roact.createElement
			local v3 = {
				LayoutOrder = i,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local divider

			if v2 then
				divider = Roact.createElement("Frame", {
					Size = UDim2.new(1, -p.props.dividerStartOffset, 0, 1),
					Position = UDim2.new(0, p.props.dividerStartOffset, 1, -1),
					BorderSizePixel = 0,
					BackgroundColor3 = p2.Theme.Divider.Color,
					BackgroundTransparency = p2.Theme.Divider.Transparency,
					ZIndex = 100
				}) or nil
			end

			children[v] = createElement("Frame", v3, { Content = cell, Divider = divider })
		end

		return Roact.createElement("Frame", {
			LayoutOrder = p.props.layoutOrder,
			Size = size,
			AutomaticSize = automaticSize,
			AnchorPoint = p.props.anchorPoint,
			Position = p.props.position,
			BackgroundTransparency = 1
		}, children)
	end)
end

return extended
