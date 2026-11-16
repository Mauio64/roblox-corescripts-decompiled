local RobloxAppUpdate = script:FindFirstAncestor("RobloxAppUpdate")
local parent = RobloxAppUpdate.Parent
require(RobloxAppUpdate.Types)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local joinGamePlayButton = DiscoveryAnalytics.Points.joinGamePlayButton
local UpdateMessageType = require(RobloxAppUpdate.UpdateMessageType)
local Promise = require(parent.Promise)

local v = {
	[Enum.AppUpdateStatus.Available] = UpdateMessageType.Default,
	[Enum.AppUpdateStatus.AvailableBoundChannel] = UpdateMessageType.InternalChannel,
	[Enum.AppUpdateStatus.AvailableBetaProgram] = UpdateMessageType.BetaProgram
}

return function(object, flag: boolean, p, ctx: string)
	return function(_)
		if flag and not object:canPerformBinaryUpdate() then
			return Promise.resolve(nil)
		end

		return object:checkForUpdate():andThen(function(p2)
			local appUpdateStatus = p2.appUpdateStatus
			joinGamePlayButton(p.InfluxDb, "checkForUpdate", {
				ctx = ctx,
				appUpdateStatus = appUpdateStatus
			})

			if p2.errorMessage then
				return Promise.reject(p2.errorMessage)
			end

			return Promise.resolve(v[appUpdateStatus])
		end)
	end
end
