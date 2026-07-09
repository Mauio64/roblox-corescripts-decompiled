local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ItemCardFooter = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardFooter
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useTokens = Foundation.Hooks.useTokens

require(script.Parent.useSettingsTileProps)

local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag

local function selectDeviceOrientation(p1) -- line: 28
	return p1.DeviceOrientation
end
local function AvatarSwitcherSettingsTile(p2, p3) -- line: 32
	-- upvalues: useTokens (copy), useSelector (copy), selectDeviceOrientation (copy), Responsive (copy), FFlagAXRootSlotBasedEditorFlag (copy), useLocalization (copy), React (copy), Foundation (copy), Constants (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ItemCardFooter (copy)
	local v18 = useTokens()
	local v19 = useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait
	local v20 = nil

	if FFlagAXRootSlotBasedEditorFlag then
		v20 = useLocalization({
			label = "Feature.Avatar.Label.AddEdit"
		})
	end

	return React.createElement(Foundation.View, {
		tag = "auto-xy clip",
		Size = if not p2.squareAspectRatio then UDim2.fromOffset(p2.itemWidth, p2.itemWidth * 2) else UDim2.fromOffset(p2.itemWidth, p2.itemWidth)
	}, {
		AspectRatio = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = if not p2.squareAspectRatio then Constants.ItemTileTallAspectRatio else Constants.ItemTileSquareAspectRatio,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v18.Gap.Small)
		}),
		SettingsTileContent = React.createElement(Foundation.View, {
			tag = "clip auto-xy size-full-full",
			Size = UDim2.fromOffset(p2.itemWidth, p2.itemWidth),
			cornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v18.Semantic.Radius.Medium else v18.Radius.Medium),
			onActivated = p2.onActivated,
			backgroundStyle = if not FFlagRenameDeprecatedUIBloxTokens then v18.Semantic.Color.Common.Placeholder else v18.Color.Common.Shimmer,
			ref = p3,
			LayoutOrder = if not FFlagAXRootSlotBasedEditorFlag then nil else 1
		}, {
			SettingsTileIcon = React.createElement(Foundation.Icon, {
				name = "icons/common/plus",
				style = v18.Color.Content.Muted,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		}),
		FooterSlot = if not FFlagAXRootSlotBasedEditorFlag then nil else React.createElement(ItemCardFooter, {
			LayoutOrder = 2,
			title = v20.label,
			titleTextSize = if not v19 then nil else v18.Typography.BodySmall
		})
	})
end

return React.forwardRef(AvatarSwitcherSettingsTile)
