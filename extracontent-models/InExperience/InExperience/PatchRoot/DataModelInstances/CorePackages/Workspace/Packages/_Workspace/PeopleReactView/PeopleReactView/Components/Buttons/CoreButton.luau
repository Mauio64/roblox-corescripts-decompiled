local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local function CoreButton(props)
	local v = useTokens()

	local v2 = useSignalState(props.animatedIcon or Signals.createSignal(""))
	local v3 = useSignalState(props.buttonState or Signals.createSignal(false))

	local v4 = React.useMemo(function()
		if props.icon.off and props.buttonState then
			return v3 and props.icon.off or props.icon.on
		end

		return props.icon.on
	end, { v3, props.icon })

	local name = React.useMemo(function()
		return if props.animatedIcon then v2 else v4
	end, { v2, v4 })

	local createElement = React.createElement
	local v5 = {
		tag = "size-0-1200 flex-x-fill grow radius-medium padding-x-small align-y-center row gap-xsmall bg-surface-200",
		onActivated = props.onActivated,
		LayoutOrder = props.LayoutOrder,
		ref = props.onMount
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local size

	if props.isNewIcon then
		size = IconSize.Large
	else
		size = IconSize.Medium
	end

	return createElement(View, v5, {
		IconContainer = createElement2(View, {
			tag = "size-1100 align-y-center align-x-center row",
			LayoutOrder = 1
		}, {
			Icon = createElement3(Icon, { name = name, size = size })
		}),
		Text = React.createElement(Text, {
			Text = props.text,
			textStyle = { Color3 = v.Color.Content.Default.Color3 },
			TextTruncate = Enum.TextTruncate.SplitWord,
			tag = "text-label-medium size-full text-align-x-left",
			LayoutOrder = 2
		})
	})
end

return CoreButton
