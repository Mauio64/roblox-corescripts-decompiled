local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fGf")
local module3 = require("@luauforge/bundled/fFl")
local constants = module2.Constants
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization

local button = module3.App.Button.Button
local buttonType = module3.App.Button.Enum.ButtonType
local standardButtonSize = module3.App.Button.Enum.StandardButtonSize

local module4 = require("@luauforge/bundled/fFp")
local button2 = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize
local module5 = require("@luauforge/bundled/fFs")
local fFlagEnableLoginV2Modalization = require("@luauforge/bundled/fFu").FFlagEnableLoginV2Modalization

local module6 = require("@luauforge/bundled/fCC")

local function ResendEmailOtpButton(props)
	local v5 = if fFlagEnableLoginV2Modalization then module5() else false

	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(constants.DEFAULT_TIMER_COOLDOWN)
	local state3, setState3 = module.useState(true)
	local state4, setState4 = module.useState(nil)
	local v6 = useLocalization({
		emailOtpWaitTimeButtonText = "Authentication.Login.Action.EmailOtpWaitTime",
		resendCodeButtonText = "Authentication.Login.Action.ResendCode"
	})

	module.useEffect(function()
		local function updateTimer()
			while state3 do
				task.wait(1)
				setState2(function(p2)
					local v7 = p2 - 1

					if v7 <= 0 then
						setState(true)
						setState3(false)
						return 0
					end

					return v7
				end)
			end
		end

		if state3 then
			setState4((task.spawn(updateTimer)))
		end

		return function()
			setState3(false)

			if state4 then
				task.cancel(state4)
			end
		end
	end, { state3 })

	local function resetTimer()
		setState(false)
		setState2(constants.DEFAULT_TIMER_COOLDOWN)

		if state3 then
			setState3(false)

			if state4 then
				task.cancel(state4)
			end
		end

		setState3(true)
	end

	local v7 = state2
		and state2 > 0
		and string.gsub(v6.emailOtpWaitTimeButtonText, "{.-}", (tostring(state2)))
		or v6.resendCodeButtonText

	local function onActivated()
		props.onPress()
		setState(false)
		setState2(constants.DEFAULT_TIMER_COOLDOWN)

		if state3 then
			setState3(false)

			if state4 then
				task.cancel(state4)
			end
		end

		setState3(true)
	end

	if v5 then
		return module.createElement(button2, {
			LayoutOrder = props.layoutOrder,
			text = v7,
			variant = buttonVariant.Standard,
			size = inputSize.Medium,
			width = UDim.new(1, 0),
			isDisabled = not state or props.isLoading,
			isLoading = props.isLoading,
			onActivated = onActivated
		})
	end

	return module.createElement(button, {
		layoutOrder = props.layoutOrder,
		text = v7,
		isDisabled = not state or props.isLoading,
		isLoading = props.isLoading,
		standardSize = standardButtonSize.Regular,
		buttonType = buttonType.Secondary,
		buttonTextOverride = module6.getButtonTextOverrideConfig(),
		onActivated = onActivated
	})
end

return ResendEmailOtpButton
