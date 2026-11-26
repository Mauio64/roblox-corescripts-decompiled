local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module2 = require("@luauforge/deferred/eaj")

local icon = module2.Icon
local iconSize = module2.Enums.IconSize
local view = module2.View

local useTokens = module2.Hooks.useTokens

return function(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		Position = props.position,
		tag = "align-x-center align-y-center anchor-center-left auto-xy bg-action-subtle col gap-medium items-center"
	}

	local createElement2 = React.createElement
	local v9 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		isDisabled = props.isTerminalInitialPost,
		onActivated = props.onNavigateUp,
		Position = UDim2.fromScale(0.5, 0.5),
		tag = {
			["auto-xy bg-action-standard padding-medium radius-circle"] = true,
			["bg-action-subtle"] = props.isTerminalInitialPost
		},
		LayoutOrder = 1
	}

	local createElement3 = React.createElement
	local v12 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		IconSize = iconSize.Small,
		name = "icons/actions/truncationCollapse",
		Position = UDim2.fromScale(0.5, 0.5),
		style = 0,
		ZIndex = 2
	}
	local v13 = if props.isTerminalInitialPost then v5.Color.None else v5.Color.ActionEmphasis.Foreground
	v12.style = v13
	local children = {
		PreviousButton = createElement2(view, v9, {
			CycleUpIcon = createElement3(icon, v12)
		}),
		NextButton = 0
	}

	local createElement4 = React.createElement
	local v15 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		isDisabled = props.isTerminalFinalPost,
		onActivated = props.onNavigateDown,
		Position = UDim2.fromScale(0.5, 0.5),
		tag = {
			["auto-xy bg-action-standard padding-medium radius-circle"] = true,
			["bg-action-subtle"] = props.isTerminalFinalPost
		},
		LayoutOrder = 2
	}

	local createElement5 = React.createElement
	local v18 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		IconSize = iconSize.Small,
		name = "icons/actions/truncationExpand",
		Position = UDim2.fromScale(0.5, 0.5),
		style = 0,
		ZIndex = 2
	}
	local v19 = if props.isTerminalFinalPost then v5.Color.None else v5.Color.ActionEmphasis.Foreground
	v18.style = v19
	children.NextButton = createElement4(view, v15, {
		CycleDownIcon = createElement5(icon, v18)
	})
	return createElement(view, v7, children)
end
