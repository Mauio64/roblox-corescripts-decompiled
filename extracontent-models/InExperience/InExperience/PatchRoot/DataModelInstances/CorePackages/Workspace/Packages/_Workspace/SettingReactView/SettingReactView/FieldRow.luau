local parent = script.Parent
local parent2 = parent.Parent

require(parent2.SettingsService)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)
local Field = require(parent.Field)
local ReactUtils = require(parent2.ReactUtils)
local SignalsReact = require(parent2.SignalsReact)
local View = Foundation.View
local Text = Foundation.Text
local createNextOrder = ReactUtils.createNextOrder
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local ControlState = Enums.ControlState
local StateLayerAffordance = Enums.StateLayerAffordance

return function(props)
	local v = useTokens()
	local nextOrder = createNextOrder()

	local udim = UDim2.fromScale(0.5, 1)
	local udim2 = UDim2.fromScale(0.5, 1)
	local v2 = { Color3 = v.Color.Extended.Gray.Gray_700.Color3, Transparency = 0.9 }
	local v3 = { Color3 = v2.Color3, Transparency = 1 }

	local backgroundStyle, v4 = React.useBinding(v3)
	local onStateChanged = React.useCallback(function(p)
		local v5 = if p == ControlState.Default then v3 else v2
		v4(v5)
	end, { v4 })

	local visible = SignalsReact.useSignalBinding(props.subscribeVisible)

	local createElement = React.createElement
	local v5 = {
		tag = "auto-y row size-full-1300 radius-medium",
		backgroundStyle = backgroundStyle,
		onStateChanged = onStateChanged,
		stateLayer = { affordance = StateLayerAffordance.None },
		Visible = visible,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v6 = {
		tag = "auto-y gui-object-defaults col padding-left-small padding-y-large",
		Size = udim2,
		LayoutOrder = nextOrder()
	}
	local v7 = {
		Label = React.createElement(Text, {
			LayoutOrder = nextOrder(),
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap text-label-large",
			textStyle = v.Color.Extended.White.White_100,
			Text = props.label
		}),
		Padding = 0,
		Description = 0
	}
	local padding

	if props.description then
		padding = React.createElement(View, { tag = "size-full-200", LayoutOrder = nextOrder() })
	end

	v7.Padding = padding
	local description

	if props.description then
		description = React.createElement(Text, {
			LayoutOrder = nextOrder(),
			tag = "auto-y size-full-0 text-align-x-left text-wrap text-label-small",
			textStyle = v.Color.Extended.White.White_80,
			Text = props.description
		})
	end

	v7.Description = description
	return createElement(View, v5, {
		LabelContainer = createElement2(View, v6, v7),
		FieldContainer = React.createElement(
			View,
			{ Size = udim, tag = "row align-x-right align-y-center", LayoutOrder = nextOrder() },
			{ React.createElement(
					View,
					{
						tag = "row align-x-center align-y-center auto-xy padding-right-small padding-y-medium"
					},
					React.createElement(Field, props)
				) }
		)
	})
end
