local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Divider = Foundation.Divider
local DividerOrientation = Foundation.Enums.DividerOrientation

local BuyActionBar = require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

local function BuyActionBarLayout(props)
	local createElement = React.createElement
	local v = {
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
	local topBorder

	if props.enableTopBorder then
		topBorder = React.createElement(Divider, {
			orientation = DividerOrientation.Horizontal,
			Position = UDim2.new(0, 0, 0, 0)
		})
	end

	return createElement("TextButton", v, {
		TopBorder = topBorder,
		BuyActionBar = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = props.padding,
				PaddingBottom = props.padding,
				PaddingLeft = props.padding,
				PaddingRight = props.padding
			}),
			BuyActionBar = React.createElement(BuyActionBar, props.buyActionBarProps)
		})
	})
end

return BuyActionBarLayout
