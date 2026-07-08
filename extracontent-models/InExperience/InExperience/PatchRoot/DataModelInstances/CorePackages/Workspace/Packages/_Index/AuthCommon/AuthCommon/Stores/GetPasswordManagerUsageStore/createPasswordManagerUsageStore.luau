local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Signals = require(Parent.Signals)

return function() -- line: 16
	-- upvalues: Signals (copy)
	local v3, v4 = Signals.createSignal(false)
	local v5, v6 = Signals.createSignal(false)
	local v7, v8 = Signals.createSignal(false)

	return {
		getLoggedinUsingSavedPassword = v3,
		setLoggedinUsingSavedPassword = v4,
		getSavedPasswordAfterLogin = v5,
		setSavedPasswordAfterLogin = v6,
		getPasswordManagerMediatedSignup = v7,
		setPasswordManagerMediatedSignup = v8,
		resetAll = function() -- line: 21
			-- upvalues: v4 (copy), v6 (copy), v8 (copy)
			v4(false)
			v6(false)
			v8(false)
		end
	}
end
