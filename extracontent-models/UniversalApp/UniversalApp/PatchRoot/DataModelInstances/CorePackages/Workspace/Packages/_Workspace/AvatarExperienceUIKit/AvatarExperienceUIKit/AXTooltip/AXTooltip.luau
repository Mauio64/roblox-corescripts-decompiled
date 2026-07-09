local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local EnumsRadius = Foundation.Enums.Radius
local t1 = {
	Top = UDim2.fromScale(0.5, 0),
	Bottom = UDim2.fromScale(0.5, 1),
	Left = UDim2.fromScale(0, 0.5),
	Right = UDim2.fromScale(1, 0.5)
}

return function(t2: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), React (copy), Popover (copy), t1 (copy), PopoverAlign (copy), EnumsRadius (copy), Foundation (copy)
	local v10 = useTokens()

	return React.createElement(Popover.Root, {
		isOpen = t2.isOpen
	}, {
		AXTooltipAnchor = React.createElement(Popover.Anchor, {
			Position = t1[t2.popoverSide]
		}),
		AXTooltipContent = React.createElement(Popover.Content, {
			align = PopoverAlign.Center,
			side = t2.popoverSide,
			backgroundStyle = v10.Color.System.Contrast,
			radius = EnumsRadius.Medium
		}, {
			AXTooltipTextFrame = React.createElement(Foundation.View, {
				tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
			}, {
				AXTooltipTitle = React.createElement(Foundation.Text, {
					Text = t2.tooltipText,
					Size = if not t2.maxWidth then nil else UDim2.new(0, t2.maxWidth, 0, 0),
					tag = not t2.maxWidth and "auto-xy text-title-medium content-inverse-emphasis" or "auto-y text-title-medium content-inverse-emphasis",
					TextWrapped = not not t2.maxWidth or nil
				})
			}),
			AXTooltipOverlayButton = React.createElement("TextButton", {
				Transparency = 1,
				[React.Event.Activated] = t2.onTooltipActivated,
				Size = UDim2.fromScale(1, 1)
			})
		})
	})
end
