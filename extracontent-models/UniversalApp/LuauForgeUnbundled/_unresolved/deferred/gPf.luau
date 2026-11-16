local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local itemCardFooter = require("@luauforge/deferred/gkN").ItemCardComponents.ItemCardFooter
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local useTokens = Foundation.Hooks.useTokens
require("@luauforge/deferred/gPg")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module2 = require("@luauforge/bundled/dMx")

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function OutfitSwitcherSettingsTile(props, p2)
	local v5 = useTokens()
	local v6 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait

	local v7 = useLocalization({ label = "Feature.Avatar.Label.AddEdit" })

	local createElement = React.createElement
	local view = Foundation.View

	local v9 = if props.squareAspectRatio then UDim2.fromOffset(props.itemWidth, props.itemWidth) else UDim2.fromOffset(props.itemWidth, props.itemWidth * 2)

	local v11 = if props.squareAspectRatio then module2.ItemTileSquareAspectRatio else module2.ItemTileTallAspectRatio
	local v8 = {
		tag = "col align-x-left gap-small auto-xy clip",
		Size = v9,
		aspectRatio = {
			AspectRatio = v11,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v12 = {
		tag = "size-full-full auto-xy radius-medium clip",
		Size = UDim2.fromOffset(props.itemWidth, props.itemWidth),
		onActivated = props.onTileActivated,
		backgroundStyle = v5.Color.Common.Shimmer,
		ref = p2,
		LayoutOrder = 1
	}

	local createElement3 = React.createElement
	local icon = Foundation.Icon
	local v13 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		name = Foundation.Enums.IconName.PlusLarge,
		style = v5.Color.Content.Muted,
		size = 0
	}
	local v14 = if v6 then Foundation.Enums.IconSize.Medium else Foundation.Enums.IconSize.Large
	v13.size = v14
	local children2 = { SettingsTileIcon = createElement3(icon, v13), Menu = 0 }

	local createElement4 = React.createElement
	local menu = Foundation.Menu
	local v15 = {
		isOpen = props.isOpen,
		items = props.items,
		size = 0,
		onPressedOutside = 0,
		onActivated = 0,
		side = 0,
		AnchorPoint = 0,
		Position = 0,
		ref = 0
	}
	local v16 = if v6 then Foundation.Enums.InputSize.Medium else Foundation.Enums.InputSize.Large
	v15.size = v16
	v15.onPressedOutside = props.onPressedOutside
	v15.onActivated = props.onMenuItemActivated
	v15.side = Foundation.Enums.PopoverSide.Right
	v15.AnchorPoint = Vector2.new(0.5, 0.5)
	v15.Position = UDim2.fromScale(0.5, 0.3)
	v15.ref = props.menuRef
	children2.Menu = createElement4(menu, v15, {})
	local children = {
		SettingsTileContent = createElement2(view2, v12, children2),
		FooterSlot = 0
	}

	local createElement5 = React.createElement
	local v18 = { title = v7.label, titleTextSize = 0, LayoutOrder = 2 }
	local v19 = if v6 then v5.Typography.BodySmall else nil
	v18.titleTextSize = v19
	children.FooterSlot = createElement5(itemCardFooter, v18)
	return createElement(view, v8, children)
end

return React.forwardRef(OutfitSwitcherSettingsTile)
