local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ActionText = require(script.Parent.ActionText)

local function ControlActionRow(props)
	local v = Foundation.Hooks.useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "row align-y-center gap-small size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId .. "Row"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v3 = {
		Size = UDim2.new(1, -props.iconWidth - v.Gap.Small, 0, 0),
		tag = "auto-y",
		LayoutOrder = props.layoutOrderReversed and 2 or 1,
		testId = props.testId .. "Container"
	}

	local createElement3 = React.createElement
	local v4 = {
		actionLabels = props.actionLabels,
		textVariant = props.textVariant,
		textXAlignment = 0,
		testId = 0
	}
	local textXAlignment

	if props.layoutOrderReversed then
		textXAlignment = Enum.TextXAlignment.Left
	else
		textXAlignment = Enum.TextXAlignment.Right
	end

	v4.textXAlignment = textXAlignment

	v4.testId = props.testId
	return createElement(view, v2, {
		ActionTextContainer = createElement2(view2, v3, {
			ActionText = createElement3(ActionText, v4)
		}),
		IconRow = props.icon
	})
end

return React.memo(ControlActionRow)
