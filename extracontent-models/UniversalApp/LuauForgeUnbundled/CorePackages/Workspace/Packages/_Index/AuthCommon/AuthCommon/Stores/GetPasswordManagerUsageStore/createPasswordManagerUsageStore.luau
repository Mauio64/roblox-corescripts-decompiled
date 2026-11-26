local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Signals")

return function()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(false)
	local signal3, v7 = Signals.createSignal(false)

	return {
		getLoggedinUsingSavedPassword = signal,
		setLoggedinUsingSavedPassword = v5,
		getSavedPasswordAfterLogin = signal2,
		setSavedPasswordAfterLogin = v6,
		getPasswordManagerMediatedSignup = signal3,
		setPasswordManagerMediatedSignup = v7,
		resetAll = function()
			v5(false)
			v6(false)
			v7(false)
		end
	}
end
