local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local TextArea = Foundation.TextArea

local TextKeys = require(EditProfile.Common.TextKeys)
local Constants = require(EditProfile.Common.Constants)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

return function(props)
	local v = useLocalization({
		AboutModalCaption = TextKeys.AboutModalCaption,
		AboutPlaceholder = TextKeys.AboutPlaceholder,
		PinLocked = TextKeys.PinLocked,
		ThrottleError = TextKeys.TooManyAttemptsTryAgainLater
	})

	local state, setState = React.useState(props.bioText)
	local state2, setState2 = React.useState(string.len(props.bioText) >= 1000)

	local function textChanged(value: string) -- 1 equivalent call inferred from this helper
		local v2 = string.len(value)

		setState(value)
		setState2(v2 > 1000)

		if props.onDataChange then
			props.onDataChange((string.sub(value, 1, 1000)))
		end
	end

	local hint

	if props.errorCode == Constants.DescriptionErrorCodes.PinLocked then
		hint = v.PinLocked
	else
		hint = v.ThrottleError
	end

	local createElement = React.createElement

	local v2 = {
		Caption = React.createElement(Text, {
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left",
			Text = v.AboutModalCaption
		}),
		BioTextArea = 0
	}

	local createElement2 = React.createElement
	local v3 = {
		text = state,
		width = UDim.new(1, 0),
		onChanged = function(value)
			textChanged(value) -- inferred equivalent call
		end,
		hint = 0,
		placeholder = 0,
		label = "",
		hasError = 0,
		numLines = 4,
		textBoxRef = 0
	}

	if not props.errorCode then
		hint = string.format("%d/%d", string.len(state), 1000)
	end

	v3.hint = hint

	v3.placeholder = v.AboutPlaceholder

	v3.hasError = state2 or props.errorCode ~= nil

	v3.textBoxRef = props.textBoxRef
	v2.BioTextArea = createElement2(TextArea, v3)
	return createElement(View, { tag = "col size-full-0 auto-y gap-large" }, v2)
end
