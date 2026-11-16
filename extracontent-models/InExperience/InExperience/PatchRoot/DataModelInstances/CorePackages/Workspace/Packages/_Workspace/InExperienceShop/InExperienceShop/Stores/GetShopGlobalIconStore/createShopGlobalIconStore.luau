local parent = script:FindFirstAncestor("InExperienceShop").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, setEnabled = createSignal(false)

	local signal2, setStatusIndicatorEnabled = createSignal(false)
	local signal3, setFreeTrialStatusIndicatorEnabled = createSignal(false)
	local signal4, setIconInstance = createSignal(nil)

	return {
		getEnabled = signal,
		setEnabled = setEnabled,
		getStatusIndicatorEnabled = function(p)
			return signal2(p) or signal3(p)
		end,
		setStatusIndicatorEnabled = setStatusIndicatorEnabled,
		setFreeTrialStatusIndicatorEnabled = setFreeTrialStatusIndicatorEnabled,
		getIconInstance = signal4,
		setIconInstance = setIconInstance
	}
end
