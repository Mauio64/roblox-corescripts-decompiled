local parent = script:FindFirstAncestor("AuthCommon").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppSignupPasskeyAvailabilityPreflight = SharedFlags.GetFFlagLuaAppSignupPasskeyAvailabilityPreflight

return function(data)
	local fido2SupportsPasskeyCreationOnDevice = true
	local passwordsAvailable = false
	local v2InterfaceSupported = false
	local isAvailable, supportsDeviceBoundOnly

	if data.FIDO2 == nil then
		isAvailable = data.isAvailable or false
		supportsDeviceBoundOnly = data.supportsDeviceBoundOnly or false
	else
		isAvailable = data.FIDO2.isAvailable
		supportsDeviceBoundOnly = data.FIDO2.supportsDeviceBoundOnly

		if GetFFlagLuaAppSignupPasskeyAvailabilityPreflight() then
			fido2SupportsPasskeyCreationOnDevice = data.FIDO2.supportsPasskeyCreationOnDevice ~= false
		end

		v2InterfaceSupported = true
	end

	if data.password ~= nil then
		passwordsAvailable = data.password.isAvailable
	end

	return {
		fido2Available = isAvailable,
		fido2SupportsDeviceBoundOnly = supportsDeviceBoundOnly,
		fido2SupportsPasskeyCreationOnDevice = fido2SupportsPasskeyCreationOnDevice,
		passwordsAvailable = passwordsAvailable,
		v2InterfaceSupported = v2InterfaceSupported
	}
end
