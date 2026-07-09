local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local React = require(LoginV2Parent.React)
local OtpLogin = require(LoginV2Parent.OtpLogin)
local UIBlox = require(LoginV2Parent.UIBlox)
local Constants = OtpLogin.Constants
local useLocalization = require(LoginV2Parent.Localization).Hooks.useLocalization
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local Constants2 = require(LoginV2.Components.Constants)

local function ResendEmailOtpButton(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), Constants (copy), useLocalization (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy), Constants2 (copy)
	local v14, v15 = React.useState(false)
	local v16, v17 = React.useState(Constants.DEFAULT_TIMER_COOLDOWN)
	local v18, v19 = React.useState(true)
	local v20, v21 = React.useState(nil)
	local v22 = useLocalization({
		emailOtpWaitTimeButtonText = "Authentication.Login.Action.EmailOtpWaitTime",
		resendCodeButtonText = "Authentication.Login.Action.ResendCode"
	})

	React.useEffect(function() -- line: 32
		-- upvalues: v18 (copy), v17 (copy), v15 (copy), v19 (copy), v21 (copy), v20 (copy)
		local function updateTimer() -- line: 33
			-- upvalues: v18 (copy), v17 (copy), v15 (copy), v19 (copy)
			while v18 do
				task.wait(1)
				v17(function(p1) -- line: 36
					-- upvalues: v15 (copy), v19 (copy)
					local v27 = p1 - 1

					if v27 <= 0 then
						v15(true)
						v19(false)

						return 0
					end

					return v27
				end)
			end
		end

		if v18 then
			local thread = task.spawn(updateTimer)

			v21(thread)
		end

		return function() -- line: 54
			-- upvalues: v19 (copy), v20 (copy)
			v19(false)

			if v20 then
				task.cancel(v20)
			end
		end
	end, { v18 })

	local function resetTimer() -- line: 62
		-- upvalues: v15 (copy), v17 (copy), Constants (copy), v18 (copy), v19 (copy), v20 (copy)
		v15(false)
		v17(Constants.DEFAULT_TIMER_COOLDOWN)

		if v18 then
			v19(false)

			if v20 then
				task.cancel(v20)
			end
		end

		v19(true)
	end

	return React.createElement(Button, {
		layoutOrder = t1.layoutOrder,
		text = v16 and (v16 > 0 and string.gsub(v22.emailOtpWaitTimeButtonText, "{.-}", (tostring(v16)))) or v22.resendCodeButtonText,
		isDisabled = not v14 or t1.isLoading,
		isLoading = t1.isLoading,
		standardSize = StandardButtonSize.Regular,
		buttonType = ButtonType.Secondary,
		buttonTextOverride = Constants2.getButtonTextOverrideConfig(),
		onActivated = function() -- line: 86
			-- upvalues: t1 (copy), v15 (copy), v17 (copy), Constants (copy), v18 (copy), v19 (copy), v20 (copy)
			t1.onPress()
			v15(false)
			v17(Constants.DEFAULT_TIMER_COOLDOWN)

			if v18 then
				v19(false)

				if v20 then
					task.cancel(v20)
				end
			end

			v19(true)
		end
	})
end

return ResendEmailOtpButton
