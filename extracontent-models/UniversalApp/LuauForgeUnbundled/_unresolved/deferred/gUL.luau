local CoreGui = game:GetService("CoreGui")

local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")

local module2 = require("@luauforge/deferred/gUM")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigationFocus = RoactNavigation.withNavigationFocus
local module3 = require("@luauforge/bundled/gTh")
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local iconSize = UIBlox.App.Constant.IconSize
local module4 = require("@luauforge/deferred/gKK")

local module5 = require("@luauforge/deferred/gUO")
local module6 = require("@luauforge/bundled/fCe")

local iconsactionsadjust = images["icons/actions/adjust"]

local function isVisible(data)
	return (module6.isAvatarSceneButtonsVisible(
		data.avatarRoute,
		data.isFocused,
		data.isUIFullView,
		data.isSceneFullView,
		data.navigation
	))
end

local function RefinementEntryButton(props)
	local v5 = useDispatch()
	local theme = useStyle().Theme
	local forwardRef = props.forwardRef
	local v6 = module(module4)
	local v7 = useIsSpatial()
	local v8 = useSelectionCursor(cursorKind.RoundedRect)

	local v9 = useLocalization({
		headRefinementTooltip = "Feature.Avatar.Label.HeadRefinement.Adjust.Tooltip"
	})
	local v10, v11 = module2({
		avatarRoute = props.avatarRoute,
		shouldBeVisible = module6.isAvatarSceneButtonsVisible(
			props.avatarRoute,
			props.isFocused,
			props.isUIFullView,
			props.isSceneFullView,
			props.navigation
		)
	})

	local v12 = React.useCallback(function()
		if v10 and v11 then
			v11({ saveDismissTime = true })
		end

		v5(module5(props.navigation, props.avatarRoute, v6))
	end, { props.navigation, props.avatarRoute, v6, v11, v10 })

	local function renderImageSetButton(p2, p3)
		return React.createElement(imageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize.Regular, iconSize.Regular),
			BackgroundTransparency = 1,
			Image = iconsactionsadjust,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = 0,
			[React.Event.Activated] = v12,
			[Roact.Change.AbsoluteSize] = p2,
			[Roact.Change.AbsolutePosition] = p3,
			SelectionImageObject = v8
		})
	end

	local function renderImageSetButtonWithHeadRefinementTooltip()
		return withTooltip(
			{ bodyText = v9.headRefinementTooltip, useLargeDropShadow = true },
			{
				preferredOrientation = tooltipOrientation.Right,
				guiTarget = CoreGui,
				active = v10
			},
			function(p2)
				return renderImageSetButton(p2, p2)
			end
		)
	end

	local createElement = React.createElement
	local forwardRefsByRef = {
		Size = UDim2.fromOffset(44, 44),
		Visible = module6.isAvatarSceneButtonsVisible(
			props.avatarRoute,
			props.isFocused,
			props.isUIFullView,
			props.isSceneFullView,
			props.navigation
		),
		BackgroundColor3 = theme.BackgroundMuted.Color,
		BackgroundTransparency = theme.BackgroundMuted.Transparency,
		LayoutOrder = props.layoutOrder,
		[Roact.Ref] = forwardRef
	}
	local v14 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Image = 0
	}
	local v15

	if v7 then
		v15 = React.createElement(imageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize.Regular, iconSize.Regular),
			BackgroundTransparency = 1,
			Image = iconsactionsadjust,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = 0,
			ZIndex = 2,
			[React.Event.Activated] = v12,
			SelectionImageObject = v8
		})
	else
		v15 = renderImageSetButtonWithHeadRefinementTooltip()
	end

	v14.Image = v15
	return createElement("Frame", forwardRefsByRef, v14)
end

local v5 = withNavigationFocus((module3(RefinementEntryButton)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
