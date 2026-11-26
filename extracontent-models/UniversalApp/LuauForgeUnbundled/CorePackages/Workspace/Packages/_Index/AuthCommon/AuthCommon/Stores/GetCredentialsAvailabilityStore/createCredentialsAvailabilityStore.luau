local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Signals")

return function()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(false)
	local signal3, v7 = Signals.createSignal(false)
	local signal4, v8 = Signals.createSignal(false)

	return {
		getFido2Available = signal,
		setFido2Available = v5,
		getFido2SupportsDeviceBoundOnly = signal2,
		setFido2SupportsDeviceBoundOnly = v6,
		getPasswordsAvailable = signal3,
		setPasswordsAvailable = v7,
		getV2InterfaceSupported = signal4,
		setV2InterfaceSupported = v8
	}
end
