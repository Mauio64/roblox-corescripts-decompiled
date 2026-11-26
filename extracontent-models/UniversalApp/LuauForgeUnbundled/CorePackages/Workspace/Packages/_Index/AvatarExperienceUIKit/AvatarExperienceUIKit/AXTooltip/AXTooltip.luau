local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local useTokens = Foundation.Hooks.useTokens
local popover = Foundation.Popover
local popoverAlign = Foundation.Enums.PopoverAlign
local radius = Foundation.Enums.Radius

local v5 = {
	["Top"] = UDim2.fromScale(0.5, 0),
	Bottom = UDim2.fromScale(0.5, 1),
	Left = UDim2.fromScale(0, 0.5),
	Right = UDim2.fromScale(1, 0.5)
}

return function(props)
	local v6 = useTokens()

	local createElement = React.createElement
	local root = popover.Root
	local v7 = { isOpen = props.isOpen }
	local v8 = {
		AXTooltipAnchor = React.createElement(popover.Anchor, {
			Position = v5[props.popoverSide]
		}),
		AXTooltipContent = 0
	}

	local createElement2 = React.createElement
	local content = popover.Content
	local v9 = {
		align = popoverAlign.Center,
		side = props.popoverSide,
		backgroundStyle = v6.Color.System.Contrast,
		radius = radius.Medium
	}

	local createElement3 = React.createElement
	local view = Foundation.View

	local createElement4 = React.createElement
	local text = Foundation.Text
	local v12 = { Text = props.tooltipText, Size = 0, tag = 0, TextWrapped = 0 }
	local v13 = if props.maxWidth then UDim2.new(0, props.maxWidth, 0, 0) else nil
	v12.Size = v13
	v12.tag = props.maxWidth and "auto-y text-title-medium content-inverse-emphasis"
		or "auto-xy text-title-medium content-inverse-emphasis"

	v12.TextWrapped = props.maxWidth and true or nil
	v8.AXTooltipContent = createElement2(content, v9, {
		AXTooltipTextFrame = createElement3(
			view,
			{ tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy" },
			{ AXTooltipTitle = createElement4(text, v12) }
		),
		AXTooltipOverlayButton = React.createElement("TextButton", {
			Transparency = 1,
			[React.Event.Activated] = props.onTooltipActivated,
			Size = UDim2.fromScale(1, 1)
		})
	})
	return createElement(root, v7, v8)
end
