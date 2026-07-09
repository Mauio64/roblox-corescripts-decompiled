local Parent = script:FindFirstAncestor("AuthCommon").Parent
local GetFFlagLuaAppSignupPasskeyAvailabilityPreflight = require(Parent.SharedFlags).GetFFlagLuaAppSignupPasskeyAvailabilityPreflight

return function(p1) -- line: 6
	-- upvalues: GetFFlagLuaAppSignupPasskeyAvailabilityPreflight (copy)
	local v4 = true
	local v5 = false
	local v6 = false
	local isAvailable, supportsDeviceBoundOnly

	if p1.FIDO2 ~= nil then
		isAvailable = p1.FIDO2.isAvailable
		supportsDeviceBoundOnly = p1.FIDO2.supportsDeviceBoundOnly

		if GetFFlagLuaAppSignupPasskeyAvailabilityPreflight() then
			v4 = p1.FIDO2.supportsPasskeyCreationOnDevice ~= false
		end

		v6 = true
	else
		isAvailable = p1.isAvailable or false
		supportsDeviceBoundOnly = p1.supportsDeviceBoundOnly or false
	end

	if p1.password ~= nil then
		v5 = p1.password.isAvailable
	end

	return {
		fido2Available = isAvailable,
		fido2SupportsDeviceBoundOnly = supportsDeviceBoundOnly,
		fido2SupportsPasskeyCreationOnDevice = v4,
		passwordsAvailable = v5,
		v2InterfaceSupported = v6
	}
end
