local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useInspectAvatarTooltip = require(script.Parent.useInspectAvatarTooltip)

local FFlagProfileInspectAndBuyTooltipGamepadFocus = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyTooltipGamepadFocus)

local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Radius = Foundation.Enums.Radius
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ButtonVariant = Foundation.Enums.ButtonVariant

return (React.forwardRef(function(p, p2)
	local v = useTokens()
	local v2 = useInspectAvatarTooltip()
	local v3 = useLocalization({
		title = "Feature.Profile.Header.InspectAndBuy.Tooltip",
		body = "Feature.Profile.Description.InspectAndBuy"
	})

	React.useImperativeHandle(p2, function()
		return { onDismiss = v2.onDismiss }
	end, { v2.onDismiss })
	local ref

	if FFlagProfileInspectAndBuyTooltipGamepadFocus then
		ref = useAppFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isAutoFocusRoot = true,
			isFocusable = v2.showTooltip
		})
	end

	local createElement = React.createElement
	local root = Popover.Root
	local v4 = { isOpen = v2.showTooltip }
	local v5 = {
		Anchor = React.createElement(Popover.Anchor, { anchorRef = p.anchorRef }),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = Popover.Content
	local v6 = {
		side = PopoverSide.Right,
		align = PopoverAlign.Center,
		hasArrow = true,
		radius = Radius.Medium,
		backgroundStyle = v.Color.System.Contrast
	}

	local createElement3 = React.createElement
	local v7 = {
		tag = "col gap-xsmall auto-y padding-medium",
		Size = UDim2.fromOffset(160, 0),
		ref = 0
	}

	if not FFlagProfileInspectAndBuyTooltipGamepadFocus then
		ref = nil
	end

	v7.ref = ref
	v5.Content = createElement2(content, v6, {
		Layout = createElement3(View, v7, {
			Header = React.createElement(
				View,
				{ tag = "row flex-between align-y-center size-full-0 auto-y", LayoutOrder = 1 },
				{
					Title = React.createElement(Text, {
						Text = v3.title,
						tag = "auto-xy text-title-large content-inverse-emphasis"
					}),
					CloseButton = React.createElement(IconButton, {
						icon = IconName.X,
						size = IconSize.Small,
						onActivated = v2.onDismiss,
						variant = ButtonVariant.OverMedia
					})
				}
			),
			Body = React.createElement(Text, {
				Text = v3.body,
				tag = "size-full-0 auto-y text-body-medium content-inverse-default",
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			})
		})
	})
	return createElement(root, v4, v5)
end))
