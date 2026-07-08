local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local FFlagProfilePlatformEnableCurrencyTransfer = require(Parent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer

return function() -- line: 9
	-- upvalues: useAppPolicy (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy)
	return useAppPolicy(function(p1) -- line: 10
		-- upvalues: FFlagProfilePlatformEnableCurrencyTransfer (copy)
		if FFlagProfilePlatformEnableCurrencyTransfer then
			return (p1.getCanRenderTransferOnProfile())
		end

		return false
	end)
end
