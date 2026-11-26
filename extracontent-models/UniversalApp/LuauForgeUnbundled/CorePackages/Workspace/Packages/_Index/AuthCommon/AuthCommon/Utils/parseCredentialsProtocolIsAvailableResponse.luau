local getFFlagLuaAppSignupPasskeyAvailabilityPreflight = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppSignupPasskeyAvailabilityPreflight

return function(data)
	local v5 = true
	local v6 = false
	local v7 = false
	local isAvailable, supportsDeviceBoundOnly

	if data.FIDO2 == nil then
		isAvailable = data.isAvailable or false
		supportsDeviceBoundOnly = data.supportsDeviceBoundOnly or false
	else
		isAvailable = data.FIDO2.isAvailable
		supportsDeviceBoundOnly = data.FIDO2.supportsDeviceBoundOnly

		if getFFlagLuaAppSignupPasskeyAvailabilityPreflight() then
			v5 = data.FIDO2.supportsPasskeyCreationOnDevice ~= false
		end

		v7 = true
	end

	if data.password ~= nil then
		v6 = data.password.isAvailable
	end

	return {
		fido2Available = isAvailable,
		fido2SupportsDeviceBoundOnly = supportsDeviceBoundOnly,
		fido2SupportsPasskeyCreationOnDevice = v5,
		passwordsAvailable = v6,
		v2InterfaceSupported = v7
	}
end
