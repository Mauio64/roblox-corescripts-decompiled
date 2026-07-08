local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local FFlagProfilePlatformEnableTransferTooltipContrast = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTransferTooltipContrast)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local EnumsRadius = Foundation.Enums.Radius
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function PlusMoreMenuTooltip(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), React (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), EnumsRadius (copy), FFlagProfilePlatformEnableTransferTooltipContrast (copy), View (copy), FoundationText (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy)
	local v19 = useTokens()

	if not t1.isOpen or (not t1.text or t1.text == "") then
		return nil
	end

	local v20 = if not t1.title or t1.title == "" then nil else t1.title
	local isOpen = t1.isOpen

	return React.createElement(Popover.Root, {
		isOpen = isOpen
	}, {
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = t1.anchorRef
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			side = {
				position = PopoverSide.Top,
				offset = v19.Padding.Medium
			},
			align = PopoverAlign.End,
			radius = EnumsRadius.Medium,
			backgroundStyle = if not FFlagProfilePlatformEnableTransferTooltipContrast then nil else v19.Color.System.Contrast,
			onPressedOutside = t1.onPressedOutside
		}, {
			Layout = if v20 == nil or v20 == "" then React.createElement(View, {
				tag = "row align-y-center flex-between gap-x-small padding-x-small padding-y-small auto-xy"
			}, {
				TooltipText = React.createElement(FoundationText, {
					Text = t1.text,
					tag = {
						["auto-xy text-body-small content-inverse-default"] = FFlagProfilePlatformEnableTransferTooltipContrast,
						["auto-xy text-body-small content-default"] = not FFlagProfilePlatformEnableTransferTooltipContrast
					}
				}),
				CloseButton = React.createElement(IconButton, {
					icon = IconName.X,
					size = IconSize.XSmall,
					onActivated = t1.onClose,
					variant = if not FFlagProfilePlatformEnableTransferTooltipContrast then nil else ButtonVariant.OverMedia
				})
			}) else React.createElement(View, {
				tag = "col gap-xxsmall padding-x-small padding-y-small auto-xy"
			}, {
				Header = React.createElement(View, {
					tag = "row align-y-center flex-between size-full-0 auto-y"
				}, {
					Title = React.createElement(FoundationText, {
						Text = v20,
						tag = {
							["auto-xy text-title-small content-inverse-emphasis"] = FFlagProfilePlatformEnableTransferTooltipContrast,
							["auto-xy text-title-small content-emphasis"] = not FFlagProfilePlatformEnableTransferTooltipContrast
						}
					}),
					CloseButton = React.createElement(IconButton, {
						icon = IconName.X,
						size = IconSize.XSmall,
						onActivated = t1.onClose,
						variant = if not FFlagProfilePlatformEnableTransferTooltipContrast then nil else ButtonVariant.OverMedia
					})
				}),
				Body = React.createElement(FoundationText, {
					Text = t1.text,
					tag = {
						["auto-xy text-body-small content-inverse-default"] = FFlagProfilePlatformEnableTransferTooltipContrast,
						["auto-xy text-body-small content-default"] = not FFlagProfilePlatformEnableTransferTooltipContrast
					}
				})
			})
		})
	})
end

return PlusMoreMenuTooltip
