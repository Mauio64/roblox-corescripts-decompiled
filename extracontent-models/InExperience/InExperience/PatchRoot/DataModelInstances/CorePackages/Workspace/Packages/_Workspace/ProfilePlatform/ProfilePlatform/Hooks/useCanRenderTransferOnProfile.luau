local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer

return function()
	return useAppPolicy(function(p)
		if FFlagProfilePlatformEnableCurrencyTransfer then
			return (p.getCanRenderTransferOnProfile())
		end

		return false
	end)
end
