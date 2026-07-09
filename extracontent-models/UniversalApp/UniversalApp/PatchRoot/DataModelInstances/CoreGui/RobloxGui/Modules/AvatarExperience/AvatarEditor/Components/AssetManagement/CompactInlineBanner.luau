local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Button = Foundation.Button
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local CompactInlineBannerPlacement = require(Modules.AvatarExperience.Common.Enum.CompactInlineBannerPlacement)
local CompactInlineBannerVariant = require(Modules.AvatarExperience.Common.Enum.CompactInlineBannerVariant)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local function CompactInlineBanner(p1) -- line: 38
	-- upvalues: useTokens (copy), React (copy), CompactInlineBannerPlacement (copy), CompactInlineBannerVariant (copy), Cryo (copy), Icon (copy), IconSize (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v19 = useTokens()
	local v20 = React.useMemo(function() -- line: 41
		-- upvalues: CompactInlineBannerPlacement (copy), CompactInlineBannerVariant (copy), v19 (copy)
		return {
			visible = true,
			placement = CompactInlineBannerPlacement.Bleed,
			variant = CompactInlineBannerVariant.Default,
			margin = v19.Margin.Small
		}
	end, { v19 })
	local v21 = Cryo.Dictionary.union(v20, p1)
	local placement = v21.placement
	local variant = v21.variant
	local margin = v21.margin
	local v25 = placement == CompactInlineBannerPlacement.Inline
	local v26 = v21.actionText ~= nil and v21.onActivated ~= nil
	local t1 = {
		[CompactInlineBannerVariant.Default] = v19.Color.Shift.Shift_100,
		[CompactInlineBannerVariant.Success] = v19.Color.System.Success,
		[CompactInlineBannerVariant.Alert] = v19.Color.System.Alert
	}
	local t2 = {
		[CompactInlineBannerVariant.Default] = t1[CompactInlineBannerVariant.Default].Transparency,
		[CompactInlineBannerVariant.Success] = 0.8,
		[CompactInlineBannerVariant.Alert] = 0.8
	}
	local t3 = {
		[CompactInlineBannerVariant.Default] = v19.Color.Content.Default,
		[CompactInlineBannerVariant.Success] = v19.Color.System.Success,
		[CompactInlineBannerVariant.Alert] = v19.Color.System.Alert
	}
	local t4 = {
		[CompactInlineBannerVariant.Default] = "icons/actions/info_small",
		[CompactInlineBannerVariant.Success] = "icons/status/success_small",
		[CompactInlineBannerVariant.Alert] = "icons/status/alert_small"
	}

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = t2[variant],
		BackgroundColor3 = t1[variant].Color3,
		Visible = v21.visible,
		Size = UDim2.new(1, not v25 and 0 or -2 * margin, 0, 0),
		Position = UDim2.new(0, not v25 and 0 or margin, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UILayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v19.Gap.Medium)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, if not v25 then margin else v19.Padding.Medium),
			PaddingRight = UDim.new(0, if not v25 then margin else v19.Padding.Small),
			PaddingTop = UDim.new(0, v19.Padding.Small),
			PaddingBottom = UDim.new(0, v19.Padding.Small)
		}),
		UICorner = if not v25 then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v19.Radius.Medium)
		}),
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			style = t3[variant],
			name = v21.iconImage or t4[variant],
			size = IconSize.Small
		}),
		TextView = React.createElement(View, {
			tag = "auto-y grow padding-right-xsmall",
			LayoutOrder = 2,
			Size = UDim2.fromScale(0, 0)
		}, {
			ContentText = React.createElement(FoundationText, {
				TextWrapped = true,
				textStyle = v19.Color.Content.Emphasis,
				fontStyle = v19.Typography.CaptionLarge,
				Text = v21.contentText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 0, v19.Size.Size_800)
			})
		}),
		Button = v26 and React.createElement(Button, {
			LayoutOrder = 3,
			text = v21.actionText,
			onActivated = v21.onActivated,
			variant = ButtonVariant.Link,
			size = ButtonSize.XSmall
		})
	})
end

return CompactInlineBanner
