local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UniversalAppPolicy").useAppPolicy

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer

return function()
	return useAppPolicy(function(p2)
		if fFlagProfilePlatformEnableCurrencyTransfer then
			return (p2.getCanRenderTransferOnProfile())
		end

		return false
	end)
end
