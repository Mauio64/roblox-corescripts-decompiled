local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjJ")

local controlState = module2.Enums.ControlState
local icon = module2.Icon
local iconSize = module2.Enums.IconSize
local stateLayerAffordance = module2.Enums.StateLayerAffordance
local text = module2.Text
local view = module2.View
local useTokens = module2.Hooks.useTokens

local function NavigationItem(props)
	local v5 = useTokens()
	local scale = v5.Config.UI.Scale
	local state, setState = module.useState(false)

	local v6 = module.useCallback(function(p2)
		setState(p2 == controlState.Selected or p2 == controlState.SelectedPressed)
	end, {})

	return module.createElement(view, {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 48 * scale),
		onActivated = props.onActivated,
		selection = props.nextSelectionDown ~= nil and {
			Selectable = true,
			NextSelectionDown = props.nextSelectionDown
		} or nil,
		onStateChanged = v6,
		ref = props.selectionRef,
		stateLayer = { affordance = stateLayerAffordance.None },
		tag = {
			["row align-y-center padding-left-xsmall radius-medium"] = true,
			["bg-shift-200"] = state
		},
		testId = props.testId
	}, {
		Leading = module.createElement(view, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(40 * scale, 40 * scale),
			tag = "row align-x-center align-y-center"
		}, {
			Icon = module.createElement(icon, {
				name = props.icon,
				size = iconSize.Large,
				style = v5.Color.Content.Emphasis
			})
		}),
		Label = module.createElement(view, {
			LayoutOrder = 2,
			tag = "fill auto-y padding-x-small"
		}, {
			Text = module.createElement(text, {
				Text = props.text,
				tag = "size-full-0 auto-y text-label-medium text-align-x-left text-truncate-end content-emphasis"
			})
		})
	})
end

return NavigationItem
