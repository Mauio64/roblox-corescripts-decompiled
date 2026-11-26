local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local text = Foundation.Text
local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local function ViewProfileLink(props)
	local v5 = useTokens()
	local state, setState = React.useState(false)
	local v6 = React.useCallback(function(p2)
		setState(p2 == controlState.Hover)
	end, {})

	local createElement = React.createElement
	local v8 = {
		Name = "ViewProfileButton",
		Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
		tag = "row align-x-center align-y-center",
		onActivated = props.onActivated,
		onStateChanged = v6,
		stateLayer = { affordance = stateLayerAffordance.None },
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v12 = if state then `<u>{props.text}</u>` else props.text
	return createElement(view, v8, {
		Label = createElement2(text, {
			Text = v12,
			RichText = true,
			tag = "auto-xy text-title-medium text-align-x-center content-emphasis"
		})
	})
end

return ViewProfileLink
