local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle

local skeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Skeleton

local extended = Roact.PureComponent:extend("TextPlaceholders")

extended.defaultProps = { LayoutOrder = 0, avatarSize = 60, avatarCellWidth = 60 }

function extended.render(p2)
	return withStyle(function(p3)
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, -p2.props.avatarCellWidth, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = p2.props.LayoutOrder
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 0)
			}),
			UIList = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			topRectangle = Roact.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0, 94, 0, 12)
			}),
			spacer = Roact.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 7),
				BackgroundTransparency = 1
			}),
			bottomRectangle = Roact.createElement(skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(0, 169, 0, 12)
			})
		})
	end)
end

return extended
