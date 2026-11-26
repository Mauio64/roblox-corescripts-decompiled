local signal = require("@luauforge/bundled/hTe").Signal
local module = require("@luauforge/bundled/hTa")

local v5 = { OnLeaveConstrained = signal.new() }

function v5:BeginCheckXboxPrivilege(p3)
	return {
		CanJoinGame = true,
		PrivilegeCheckResult = module.PrivilegeCheckResults.NO_ISSUE,
		Success = true
	}
end

function v5.GetPlatformPartyMembers(p2)
	return {}
end

local v6 = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v6 = PlatformService
end)

return v6 or v5
