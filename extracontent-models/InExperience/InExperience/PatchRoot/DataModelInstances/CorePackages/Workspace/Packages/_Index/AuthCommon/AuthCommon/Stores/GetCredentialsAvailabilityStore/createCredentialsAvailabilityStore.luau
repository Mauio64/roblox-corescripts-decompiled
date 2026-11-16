local parent = script:FindFirstAncestor("AuthCommon").Parent

local Signals = require(parent.Signals)

return function()
	local signal, setFido2Available = Signals.createSignal(false)
	local signal2, setFido2SupportsDeviceBoundOnly = Signals.createSignal(false)
	local signal3, setPasswordsAvailable = Signals.createSignal(false)
	local signal4, setV2InterfaceSupported = Signals.createSignal(false)

	return {
		getFido2Available = signal,
		setFido2Available = setFido2Available,
		getFido2SupportsDeviceBoundOnly = signal2,
		setFido2SupportsDeviceBoundOnly = setFido2SupportsDeviceBoundOnly,
		getPasswordsAvailable = signal3,
		setPasswordsAvailable = setPasswordsAvailable,
		getV2InterfaceSupported = signal4,
		setV2InterfaceSupported = setV2InterfaceSupported
	}
end
