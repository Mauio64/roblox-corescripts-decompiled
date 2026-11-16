local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local useInspectAvatarTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/useInspectAvatarTooltip")

local FFlagProfileInspectAndBuyTooltipGamepadFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyTooltipGamepadFocus")

local popover = Foundation.Popover
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local radius = Foundation.Enums.Radius
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local buttonVariant = Foundation.Enums.ButtonVariant

return (React.forwardRef(function(p2, p3)
	local v5 = useTokens()
	local v6 = useInspectAvatarTooltip()
	local v7 = useLocalization({
		title = "Feature.Profile.Header.InspectAndBuy.Tooltip",
		body = "Feature.Profile.Description.InspectAndBuy"
	})

	React.useImperativeHandle(p3, function()
		return { onDismiss = v6.onDismiss }
	end, { v6.onDismiss })
	local v8

	if FFlagProfileInspectAndBuyTooltipGamepadFocus then
		v8 = useAppFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isAutoFocusRoot = true,
			isFocusable = v6.showTooltip
		})
	end

	local createElement = React.createElement
	local root = popover.Root
	local v9 = { isOpen = v6.showTooltip }
	local v10 = {
		Anchor = React.createElement(popover.Anchor, { anchorRef = p2.anchorRef }),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = popover.Content
	local v11 = {
		side = popoverSide.Right,
		align = popoverAlign.Center,
		hasArrow = true,
		radius = radius.Medium,
		backgroundStyle = v5.Color.System.Contrast
	}

	local createElement3 = React.createElement
	local v14 = {
		tag = "col gap-xsmall auto-y padding-medium",
		Size = UDim2.fromOffset(160, 0),
		ref = 0
	}

	if not FFlagProfileInspectAndBuyTooltipGamepadFocus then
		v8 = nil
	end

	v14.ref = v8
	v10.Content = createElement2(content, v11, {
		Layout = createElement3(view, v14, {
			Header = React.createElement(
				view,
				{
					tag = "row flex-between align-y-center size-full-0 auto-y",
					LayoutOrder = 1
				},
				{
					Title = React.createElement(text, {
						Text = v7.title,
						tag = "auto-xy text-title-large content-inverse-emphasis"
					}),
					CloseButton = React.createElement(iconButton, {
						icon = iconName.X,
						size = iconSize.Small,
						onActivated = v6.onDismiss,
						variant = buttonVariant.OverMedia
					})
				}
			),
			Body = React.createElement(text, {
				Text = v7.body,
				tag = "size-full-0 auto-y text-body-medium content-inverse-default",
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			})
		})
	})
	return createElement(root, v9, v10)
end))
