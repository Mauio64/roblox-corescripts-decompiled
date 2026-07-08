local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.SettingsService)

local Foundation = require(scriptParentParent.Foundation)
local React = require(scriptParentParent.React)
local Field = require(scriptParent.Field)
local ReactUtils = require(scriptParentParent.ReactUtils)
local SignalsReact = require(scriptParentParent.SignalsReact)
local View = Foundation.View
local FoundationText = Foundation.Text
local createNextOrder = ReactUtils.createNextOrder
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local ControlState = Enums.ControlState
local StateLayerAffordance = Enums.StateLayerAffordance

return function(p1) -- line: 26
	-- upvalues: useTokens (copy), createNextOrder (copy), React (copy), ControlState (copy), SignalsReact (copy), View (copy), StateLayerAffordance (copy), FoundationText (copy), Field (copy)
	local v16 = useTokens()
	local v17 = createNextOrder()
	local uDim2 = UDim2.fromScale(0.5, 1)
	local uDim2_2 = UDim2.fromScale(0.5, 1)
	local t1 = {
		Transparency = 0.9,
		Color3 = v16.Color.Extended.Gray.Gray_700.Color3
	}
	local t2 = {
		Transparency = 1,
		Color3 = t1.Color3
	}
	local v22, v23 = React.useBinding(t2)
	local v24 = React.useCallback(function(p2) -- line: 36
		-- upvalues: v23 (copy), ControlState (copy), t2 (copy), t1 (copy)
		v23(if p2 ~= ControlState.Default then t1 else t2)
	end, { v23 })
	local v25 = SignalsReact.useSignalBinding(p1.subscribeVisible)

	return React.createElement(View, {
		tag = "auto-y row size-full-1300 radius-medium",
		backgroundStyle = v22,
		onStateChanged = v24,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		Visible = v25,
		LayoutOrder = p1.layoutOrder
	}, {
		LabelContainer = React.createElement(View, {
			tag = "auto-y gui-object-defaults col padding-left-small padding-y-large",
			Size = uDim2_2,
			LayoutOrder = v17()
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap text-label-large",
				LayoutOrder = v17(),
				textStyle = v16.Color.Extended.White.White_100,
				Text = p1.label
			}),
			Padding = if not p1.description then nil else React.createElement(View, {
				tag = "size-full-200",
				LayoutOrder = v17()
			}),
			Description = if not p1.description then nil else React.createElement(FoundationText, {
				tag = "auto-y size-full-0 text-align-x-left text-wrap text-label-small",
				LayoutOrder = v17(),
				textStyle = v16.Color.Extended.White.White_80,
				Text = p1.description
			})
		}),
		FieldContainer = React.createElement(View, {
			tag = "row align-x-right align-y-center",
			Size = uDim2,
			LayoutOrder = v17()
		}, { React.createElement(View, {
			tag = "row align-x-center align-y-center auto-xy padding-right-small padding-y-medium"
		}, React.createElement(Field, p1)) })
	})
end
