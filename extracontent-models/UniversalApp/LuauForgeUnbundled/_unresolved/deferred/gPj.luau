local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local itemCardFooter = require("@luauforge/deferred/gkN").ItemCardComponents.ItemCardFooter
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local useTokens = Foundation.Hooks.useTokens
require("@luauforge/deferred/gPk")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module2 = require("@luauforge/bundled/dMx")

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function AvatarSwitcherSettingsTile(props, p2)
	local v5 = useTokens()
	local v6 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait

	local v7 = useLocalization({ label = "Feature.Avatar.Label.AddEdit" })

	local createElement = React.createElement
	local view = Foundation.View

	local v9 = if props.squareAspectRatio then UDim2.fromOffset(props.itemWidth, props.itemWidth) else UDim2.fromOffset(props.itemWidth, props.itemWidth * 2)

	local createElement2 = React.createElement
	local v12 = if props.squareAspectRatio then module2.ItemTileSquareAspectRatio else module2.ItemTileTallAspectRatio
	local children = {
		AspectRatio = createElement2("UIAspectRatioConstraint", {
			AspectRatio = v12,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v5.Gap.Small)
		}),
		SettingsTileContent = React.createElement(Foundation.View, {
			tag = "clip auto-xy size-full-full",
			Size = UDim2.fromOffset(props.itemWidth, props.itemWidth),
			cornerRadius = UDim.new(0, v5.Radius.Medium),
			onActivated = props.onActivated,
			backgroundStyle = v5.Color.Common.Shimmer,
			ref = p2,
			LayoutOrder = 1
		}, {
			SettingsTileIcon = React.createElement(Foundation.Icon, {
				name = "icons/common/plus",
				style = v5.Color.Content.Muted,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		}),
		FooterSlot = 0
	}

	local createElement3 = React.createElement
	local v14 = { title = v7.label, titleTextSize = 0, LayoutOrder = 2 }
	local v15 = if v6 then v5.Typography.BodySmall else nil
	v14.titleTextSize = v15
	children.FooterSlot = createElement3(itemCardFooter, v14)
	return createElement(view, { tag = "auto-xy clip", Size = v9 }, children)
end

return React.forwardRef(AvatarSwitcherSettingsTile)
