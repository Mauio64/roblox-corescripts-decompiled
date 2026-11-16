local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local divider = Foundation.Divider
local dividerOrientation = Foundation.Enums.DividerOrientation

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")

local function BuyActionBarLayout(props)
	local createElement = React.createElement
	local v6 = {
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder or 2,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		Selectable = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = function() end
	}

	local v8 = if props.enableTopBorder then React.createElement(divider, {
		orientation = dividerOrientation.Horizontal,
		Position = UDim2.new(0, 0, 0, 0)
	}) else nil
	return createElement("TextButton", v6, {
		TopBorder = v8,
		BuyActionBar = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = props.padding,
					PaddingBottom = props.padding,
					PaddingLeft = props.padding,
					PaddingRight = props.padding
				}),
				BuyActionBar = React.createElement(module3, props.buyActionBarProps)
			}
		)
	})
end

return BuyActionBarLayout
