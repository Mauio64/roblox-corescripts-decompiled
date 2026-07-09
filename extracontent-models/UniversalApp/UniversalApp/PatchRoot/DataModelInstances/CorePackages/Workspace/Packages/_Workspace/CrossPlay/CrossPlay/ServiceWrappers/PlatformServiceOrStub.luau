local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local Signal = require(CrossPlayParent.AppCommonLib).Signal
local Constants = require(CrossPlay.Hooks.Constants)
local t2 = {
	OnLeaveConstrained = Signal.new(),
	BeginCheckXboxPrivilege = function(_: {[any]: any}, _: number) -- line: 10
		-- upvalues: Constants (copy)
		return {
			CanJoinGame = true,
			Success = true,
			PrivilegeCheckResult = Constants.PrivilegeCheckResults.NO_ISSUE
		}
	end,
	GetPlatformPartyMembers = function(_) -- line: 18
		return {}
	end
}
local PlatformService = nil

pcall(function() -- line: 24
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

return PlatformService or t2
