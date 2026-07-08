local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local Signals = require(Parent.Signals)
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local function CoreButton(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), useSignalState (copy), Signals (copy), React (copy), View (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	local v14 = useTokens()
	local v15 = useSignalState(t1.animatedIcon or Signals.createSignal(""))
	local v16 = useSignalState(t1.buttonState or Signals.createSignal(false))
	local v17 = React.useMemo(function() -- line: 36
		-- upvalues: t1 (copy), v16 (copy)
		if t1.icon.off and t1.buttonState then
			return v16 and t1.icon.off or t1.icon.on
		end

		return t1.icon.on
	end, {
		v16,
		t1.icon
	})
	local v18 = React.useMemo(function() -- line: 46
		-- upvalues: t1 (copy), v15 (copy), v17 (copy)
		if t1.animatedIcon then
			return v15
		end

		return v17
	end, {
		v15,
		v17
	})

	return React.createElement(View, {
		tag = "size-0-1200 flex-x-fill grow radius-medium padding-x-small align-y-center row gap-xsmall bg-surface-200",
		onActivated = t1.onActivated,
		LayoutOrder = t1.LayoutOrder,
		ref = t1.onMount
	}, {
		IconContainer = React.createElement(View, {
			tag = "size-1100 align-y-center align-x-center row",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Icon, {
				name = v18,
				size = if not t1.isNewIcon then IconSize.Medium else IconSize.Large
			})
		}),
		Text = React.createElement(FoundationText, {
			tag = "text-label-medium size-full text-align-x-left",
			LayoutOrder = 2,
			Text = t1.text,
			textStyle = {
				Color3 = v14.Color.Content.Default.Color3
			},
			TextTruncate = Enum.TextTruncate.SplitWord
		})
	})
end

return CoreButton
