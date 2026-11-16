local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local view = Foundation.View
local text = Foundation.Text
local textArea = Foundation.TextArea

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization

return function(props)
	local v5 = useLocalization({
		AboutModalCaption = TextKeys.AboutModalCaption,
		AboutPlaceholder = TextKeys.AboutPlaceholder,
		PinLocked = TextKeys.PinLocked,
		ThrottleError = TextKeys.TooManyAttemptsTryAgainLater
	})

	local state, setState = React.useState(props.bioText)
	local state2, setState2 = React.useState(string.len(props.bioText) >= 1000)

	local function textChanged(value)
		local v6 = string.len(value)

		setState(value)
		setState2(v6 > 1000)

		if props.onDataChange then
			props.onDataChange((string.sub(value, 1, 1000)))
		end
	end

	local v6

	if props.errorCode == Constants.DescriptionErrorCodes.PinLocked then
		v6 = v5.PinLocked
	else
		v6 = v5.ThrottleError
	end

	local createElement = React.createElement

	local v9 = {
		Caption = React.createElement(text, {
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left",
			Text = v5.AboutModalCaption
		}),
		BioTextArea = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		text = state,
		width = UDim.new(1, 0),
		onChanged = function(value)
			local v12 = string.len(value)

			setState(value)
			setState2(v12 > 1000)

			if props.onDataChange then
				props.onDataChange((string.sub(value, 1, 1000)))
			end
		end,
		hint = 0,
		placeholder = 0,
		label = "",
		hasError = 0,
		numLines = 4,
		textBoxRef = 0
	}

	if not props.errorCode then
		v6 = string.format("%d/%d", string.len(state), 1000)
	end

	v11.hint = v6

	v11.placeholder = v5.AboutPlaceholder

	v11.hasError = state2 or props.errorCode ~= nil

	v11.textBoxRef = props.textBoxRef
	v9.BioTextArea = createElement2(textArea, v11)
	return createElement(view, { tag = "col size-full-0 auto-y gap-large" }, v9)
end
