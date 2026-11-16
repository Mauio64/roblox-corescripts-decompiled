local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local Radius = Foundation.Enums.Radius

local v = {
	["Top"] = UDim2.fromScale(0.5, 0),
	Bottom = UDim2.fromScale(0.5, 1),
	Left = UDim2.fromScale(0, 0.5),
	Right = UDim2.fromScale(1, 0.5)
}

return function(props)
	local v2 = useTokens()

	local createElement = React.createElement
	local root = Popover.Root
	local v3 = { isOpen = props.isOpen }
	local v4 = {
		AXTooltipAnchor = React.createElement(Popover.Anchor, { Position = v[props.popoverSide] }),
		AXTooltipContent = 0
	}

	local createElement2 = React.createElement
	local content = Popover.Content
	local v5 = {
		align = PopoverAlign.Center,
		side = props.popoverSide,
		backgroundStyle = v2.Color.System.Contrast,
		radius = Radius.Medium
	}

	local createElement3 = React.createElement
	local view = Foundation.View

	local createElement4 = React.createElement
	local text = Foundation.Text
	local v6 = { Text = props.tooltipText, Size = 0, tag = 0, TextWrapped = 0 }
	local size

	if props.maxWidth then
		size = UDim2.new(0, props.maxWidth, 0, 0)
	end

	v6.Size = size
	v6.tag = props.maxWidth and "auto-y text-title-medium content-inverse-emphasis"
		or "auto-xy text-title-medium content-inverse-emphasis"

	v6.TextWrapped = props.maxWidth and true or nil
	v4.AXTooltipContent = createElement2(content, v5, {
		AXTooltipTextFrame = createElement3(view, {
			tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
		}, {
			AXTooltipTitle = createElement4(text, v6)
		}),
		AXTooltipOverlayButton = React.createElement("TextButton", {
			Transparency = 1,
			[React.Event.Activated] = props.onTooltipActivated,
			Size = UDim2.fromScale(1, 1)
		})
	})
	return createElement(root, v3, v4)
end
