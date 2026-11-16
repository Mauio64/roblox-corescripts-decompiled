local parent = script:FindFirstAncestor("GameJoinCard").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens

local function ViewProfileLink(props)
	local v = useTokens()
	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover)
	end, {})

	local createElement = React.createElement
	local v2 = {
		Name = "ViewProfileButton",
		Size = UDim2.new(1, 0, 0, v.Size.Size_600),
		tag = "row align-x-center align-y-center",
		onActivated = props.onActivated,
		onStateChanged = onStateChanged,
		stateLayer = { affordance = StateLayerAffordance.None },
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local text

	if state then
		text = `<u>{props.text}</u>`
	else
		text = props.text
	end

	return createElement(View, v2, {
		Label = createElement2(Text, {
			Text = text,
			RichText = true,
			tag = "auto-xy text-title-medium text-align-x-center content-emphasis"
		})
	})
end

return ViewProfileLink
