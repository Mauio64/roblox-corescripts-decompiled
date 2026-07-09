local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useInspectAvatarTooltip = require(script.Parent.useInspectAvatarTooltip)
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local EnumsRadius = Foundation.Enums.Radius
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ButtonVariant = Foundation.Enums.ButtonVariant

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 32
	-- upvalues: useTokens (copy), useInspectAvatarTooltip (copy), useLocalization (copy), React (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), EnumsRadius (copy), View (copy), FoundationText (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy)
	local v19 = useTokens()
	local v20 = useInspectAvatarTooltip()
	local v21 = useLocalization({
		title = "Feature.Profile.Header.InspectAndBuy.Tooltip",
		body = "Feature.Profile.Description.InspectAndBuy"
	})

	React.useImperativeHandle(p1, function() -- line: 40
		-- upvalues: v20 (copy)
		return {
			onDismiss = v20.onDismiss
		}
	end, { v20.onDismiss })

	return React.createElement(Popover.Root, {
		isOpen = v20.showTooltip
	}, {
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = t1.anchorRef
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			side = PopoverSide.Right,
			align = PopoverAlign.Center,
			radius = EnumsRadius.Medium,
			backgroundStyle = v19.Color.System.Contrast
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-y padding-medium",
				Size = UDim2.fromOffset(160, 0)
			}, {
				Header = React.createElement(View, {
					tag = "row flex-between align-y-center size-full-0 auto-y",
					LayoutOrder = 1
				}, {
					Title = React.createElement(FoundationText, {
						tag = "auto-xy text-title-large content-inverse-emphasis",
						Text = v21.title
					}),
					CloseButton = React.createElement(IconButton, {
						icon = IconName.X,
						size = IconSize.Small,
						onActivated = v20.onDismiss,
						variant = ButtonVariant.OverMedia
					})
				}),
				Body = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium content-inverse-default",
					TextWrapped = true,
					LayoutOrder = 2,
					Text = v21.body,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
		})
	})
end))
