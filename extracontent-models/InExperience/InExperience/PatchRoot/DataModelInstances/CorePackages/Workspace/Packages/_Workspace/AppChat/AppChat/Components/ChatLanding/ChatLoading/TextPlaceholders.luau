local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local withStyle = require(Parent.UIBlox).Style.withStyle
local Skeleton = require(Parent.Foundation).Skeleton
local v5 = Roact.PureComponent:extend("TextPlaceholders")

v5.defaultProps = {
	LayoutOrder = 0,
	avatarSize = 60,
	avatarCellWidth = 60
}

function v5.render(p1) -- line: 18
	-- upvalues: withStyle (copy), Roact (copy), Skeleton (copy)
	return withStyle(function(_) -- line: 19
		-- upvalues: Roact (copy), p1 (copy), Skeleton (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -p1.props.avatarCellWidth, 1, 0),
			LayoutOrder = p1.props.LayoutOrder
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 0)
			}),
			UIList = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			topRectangle = Roact.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0, 94, 0, 12)
			}),
			spacer = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 7)
			}),
			bottomRectangle = Roact.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(0, 169, 0, 12)
			})
		})
	end)
end

return v5
