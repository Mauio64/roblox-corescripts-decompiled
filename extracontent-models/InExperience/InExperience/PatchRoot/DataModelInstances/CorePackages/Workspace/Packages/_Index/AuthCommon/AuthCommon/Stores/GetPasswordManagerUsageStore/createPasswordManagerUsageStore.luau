local parent = script:FindFirstAncestor("AuthCommon").Parent

local Signals = require(parent.Signals)

return function()
	local signal, setLoggedinUsingSavedPassword = Signals.createSignal(false)
	local signal2, setSavedPasswordAfterLogin = Signals.createSignal(false)
	local signal3, setPasswordManagerMediatedSignup = Signals.createSignal(false)

	return {
		getLoggedinUsingSavedPassword = signal,
		setLoggedinUsingSavedPassword = setLoggedinUsingSavedPassword,
		getSavedPasswordAfterLogin = signal2,
		setSavedPasswordAfterLogin = setSavedPasswordAfterLogin,
		getPasswordManagerMediatedSignup = signal3,
		setPasswordManagerMediatedSignup = setPasswordManagerMediatedSignup,
		resetAll = function()
			setLoggedinUsingSavedPassword(false)
			setSavedPasswordAfterLogin(false)
			setPasswordManagerMediatedSignup(false)
		end
	}
end
