local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Signals = require(Parent.Signals)

return function() -- line: 17
	-- upvalues: Signals (copy)
	local v3, v4 = Signals.createSignal(false)
	local v5, v6 = Signals.createSignal(false)
	local v7, v8 = Signals.createSignal(false)
	local v9, v10 = Signals.createSignal(false)

	return {
		getFido2Available = v3,
		setFido2Available = v4,
		getFido2SupportsDeviceBoundOnly = v5,
		setFido2SupportsDeviceBoundOnly = v6,
		getPasswordsAvailable = v7,
		setPasswordsAvailable = v8,
		getV2InterfaceSupported = v9,
		setV2InterfaceSupported = v10
	}
end
