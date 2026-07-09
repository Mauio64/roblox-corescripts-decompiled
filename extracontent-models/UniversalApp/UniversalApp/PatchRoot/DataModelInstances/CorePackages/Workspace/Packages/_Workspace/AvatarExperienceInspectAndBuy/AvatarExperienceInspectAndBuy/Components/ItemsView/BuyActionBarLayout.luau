local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local Divider = Foundation.Divider
local DividerOrientation = Foundation.Enums.DividerOrientation
local BuyActionBar = require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

local function BuyActionBarLayout(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), Divider (copy), DividerOrientation (copy), BuyActionBar (copy)
	return React.createElement("TextButton", {
		Size = t1.Size,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder or 2,
		BorderSizePixel = 0,
		ZIndex = t1.ZIndex,
		Selectable = false,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = function() -- line: 46
		end
	}, {
		TopBorder = if not t1.enableTopBorder then nil else React.createElement(Divider, {
			orientation = DividerOrientation.Horizontal,
			Position = UDim2.new(0, 0, 0, 0)
		}),
		BuyActionBar = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = t1.padding,
				PaddingBottom = t1.padding,
				PaddingLeft = t1.padding,
				PaddingRight = t1.padding
			}),
			BuyActionBar = React.createElement(BuyActionBar, t1.buyActionBarProps)
		})
	})
end

return BuyActionBarLayout
