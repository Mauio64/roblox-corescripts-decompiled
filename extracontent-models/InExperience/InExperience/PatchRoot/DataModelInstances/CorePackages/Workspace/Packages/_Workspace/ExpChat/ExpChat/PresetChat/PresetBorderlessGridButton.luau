local parent = script:FindFirstAncestor("ExpChat").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local function PresetBorderlessGridButton(props)
	local v = Foundation.Hooks.useTokens()
	local unicode = props.unicode

	local onActivated = React.useCallback(function()
		props.onActivated(unicode)
	end, { props.onActivated, unicode })

	return React.createElement(Foundation.View, {
		LayoutOrder = props.layoutOrder or 0,
		tag = "size-900-900"
	}, {
		Button = React.createElement(Foundation.View, {
			tag = "position-center-center anchor-center-center size-1100-1100 radius-medium",
			backgroundStyle = v.Color.None,
			onActivated = onActivated,
			selection = { Selectable = true },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.Background },
			ref = props.buttonRef,
			testId = "PresetBorderlessGridButton"
		}, {
			Emoji = React.createElement(Foundation.Text, {
				Text = unicode,
				tag = "position-center-center anchor-center-center size-800-800 text-heading-medium text-align-x-center text-align-y-center content-default"
			})
		})
	})
end

return React.memo(PresetBorderlessGridButton)
