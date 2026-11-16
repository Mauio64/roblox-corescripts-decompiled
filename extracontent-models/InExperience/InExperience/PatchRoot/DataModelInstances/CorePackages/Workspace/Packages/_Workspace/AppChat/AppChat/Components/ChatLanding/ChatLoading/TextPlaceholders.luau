local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton

local extended = Roact.PureComponent:extend("TextPlaceholders")

extended.defaultProps = { LayoutOrder = 0, avatarSize = 60, avatarCellWidth = 60 }

function extended.render(p)
	return withStyle(function(_)
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, -p.props.avatarCellWidth, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = p.props.LayoutOrder
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
				Size = UDim2.new(1, 0, 0, 7),
				BackgroundTransparency = 1
			}),
			bottomRectangle = Roact.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(0, 169, 0, 12)
			})
		})
	end)
end

return extended
