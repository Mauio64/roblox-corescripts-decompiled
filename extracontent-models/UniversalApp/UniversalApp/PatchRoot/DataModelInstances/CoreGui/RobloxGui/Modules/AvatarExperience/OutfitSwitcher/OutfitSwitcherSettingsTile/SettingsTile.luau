local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local ItemCardFooter = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardFooter
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useTokens = Foundation.Hooks.useTokens

require(script.Parent.useSettingsTileProps)

local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function selectDeviceOrientation(p1) -- line: 23
	return p1.DeviceOrientation
end
local function OutfitSwitcherSettingsTile(p2, p3) -- line: 27
	-- upvalues: useTokens (copy), useSelector (copy), selectDeviceOrientation (copy), Responsive (copy), useLocalization (copy), React (copy), Foundation (copy), Constants (copy), ItemCardFooter (copy)
	local v16 = useTokens()
	local v17 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait
	local v18 = useLocalization({
		label = "Feature.Avatar.Label.AddEdit"
	})

	return React.createElement(Foundation.View, {
		tag = "col align-x-left gap-small auto-xy clip",
		Size = if not p2.squareAspectRatio then UDim2.fromOffset(p2.itemWidth, p2.itemWidth * 2) else UDim2.fromOffset(p2.itemWidth, p2.itemWidth),
		aspectRatio = {
			AspectRatio = if not p2.squareAspectRatio then Constants.ItemTileTallAspectRatio else Constants.ItemTileSquareAspectRatio,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	}, {
		SettingsTileContent = React.createElement(Foundation.View, {
			tag = "size-full-full auto-xy radius-medium clip",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(p2.itemWidth, p2.itemWidth),
			onActivated = p2.onTileActivated,
			backgroundStyle = v16.Color.Common.Shimmer,
			ref = p3
		}, {
			SettingsTileIcon = React.createElement(Foundation.Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				name = Foundation.Enums.IconName.PlusLarge,
				style = v16.Color.Content.Muted,
				size = if not v17 then Foundation.Enums.IconSize.Large else Foundation.Enums.IconSize.Medium
			}),
			Menu = React.createElement(Foundation.Menu, {
				isOpen = p2.isOpen,
				items = p2.items,
				size = if not v17 then Foundation.Enums.InputSize.Large else Foundation.Enums.InputSize.Medium,
				onPressedOutside = p2.onPressedOutside,
				onActivated = p2.onMenuItemActivated,
				side = Foundation.Enums.PopoverSide.Right,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.3)
			})
		}),
		FooterSlot = React.createElement(ItemCardFooter, {
			LayoutOrder = 2,
			title = v18.label,
			titleTextSize = if not v17 then nil else v16.Typography.BodySmall
		})
	})
end

return React.forwardRef(OutfitSwitcherSettingsTile)
