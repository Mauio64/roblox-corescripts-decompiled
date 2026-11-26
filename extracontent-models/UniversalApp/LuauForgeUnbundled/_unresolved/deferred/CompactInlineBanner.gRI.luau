local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local button = Foundation.Button
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

local NavigationTabLayout = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Navigation/Enum/NavigationTabLayout")
local BadgeVariant = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Indicator/Enum/BadgeVariant")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local function CompactInlineBanner(p2)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		return {
			visible = true,
			placement = NavigationTabLayout.Bleed,
			variant = BadgeVariant.Default,
			margin = v5.Margin.Small
		}
	end, { v5 })

	local union = Cryo.Dictionary.union(v6, p2)
	local placement = union.placement
	local variant = union.variant
	local v7 = union.margin

	local v8 = placement == NavigationTabLayout.Inline

	local v9 = not (union.actionText == nil) and union.onActivated ~= nil

	local v10 = {
		[BadgeVariant.Default] = v5.Color.Shift.Shift_100,
		[BadgeVariant.Success] = v5.Color.System.Success,
		[BadgeVariant.Alert] = v5.Color.System.Alert
	}

	local v11 = {
		[BadgeVariant.Default] = v10[BadgeVariant.Default].Transparency,
		[BadgeVariant.Success] = 0.8,
		[BadgeVariant.Alert] = 0.8
	}

	local v12 = {
		[BadgeVariant.Default] = v5.Color.Content.Default,
		[BadgeVariant.Success] = v5.Color.System.Success,
		[BadgeVariant.Alert] = v5.Color.System.Alert
	}

	local v13 = {
		[BadgeVariant.Default] = "icons/actions/info_small",
		[BadgeVariant.Success] = "icons/status/success_small",
		[BadgeVariant.Alert] = "icons/status/alert_small"
	}

	local createElement = React.createElement
	local v15 = {
		BackgroundTransparency = v11[variant],
		BackgroundColor3 = v10[variant].Color3,
		BorderSizePixel = 0,
		Visible = union.visible,
		Size = UDim2.new(1, not v8 and 0 or -2 * v7, 0, 0),
		Position = UDim2.new(0, not v8 and 0 or v7, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local children = {
		UILayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Medium)
		}),
		UIPadding = 0,
		UICorner = 0,
		Icon = 0,
		TextView = 0,
		Button = 0
	}

	local createElement2 = React.createElement
	local newUDim = UDim.new
	local v19 = if v8 then v5.Padding.Medium else v7
	local v17 = {
		PaddingLeft = newUDim(0, v19),
		PaddingRight = 0,
		PaddingTop = 0,
		PaddingBottom = 0
	}
	local newUDim2 = UDim.new

	if v8 then
		v7 = v5.Padding.Small
	end

	v17.PaddingRight = newUDim2(0, v7)
	v17.PaddingTop = UDim.new(0, v5.Padding.Small)
	v17.PaddingBottom = UDim.new(0, v5.Padding.Small)
	children.UIPadding = createElement2("UIPadding", v17)

	local v21 = if v8 then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, v5.Radius.Medium)
	}) else nil
	children.UICorner = v21

	children.Icon = React.createElement(icon, {
		style = v12[variant],
		name = union.iconImage or v13[variant],
		size = iconSize.Small,
		LayoutOrder = 1
	})

	children.TextView = React.createElement(
		view,
		{
			Size = UDim2.fromScale(0, 0),
			tag = "auto-y grow padding-right-xsmall",
			LayoutOrder = 2
		},
		{
			ContentText = React.createElement(text, {
				textStyle = v5.Color.Content.Emphasis,
				fontStyle = v5.Typography.CaptionLarge,
				Text = union.contentText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 0, v5.Size.Size_800)
			})
		}
	)

	children.Button = v9 and React.createElement(button, {
		text = union.actionText,
		onActivated = union.onActivated,
		variant = buttonVariant.Link,
		size = buttonSize.XSmall,
		LayoutOrder = 3
	})
	return createElement("Frame", v15, children)
end

return CompactInlineBanner
