require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/Types")
local joinGamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppUpdate/DiscoveryAnalytics").Points.joinGamePlayButton
local UpdateMessageType = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/UpdateMessageType")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppUpdate/Promise")

local v5 = {
	[Enum.AppUpdateStatus.Available] = UpdateMessageType.Default,
	[Enum.AppUpdateStatus.AvailableBoundChannel] = UpdateMessageType.InternalChannel,
	[Enum.AppUpdateStatus.AvailableBetaProgram] = UpdateMessageType.BetaProgram
}

return function(object, p2, p3, p4)
	return function(p5)
		if p2 and not object:canPerformBinaryUpdate() then
			return Promise.resolve(nil)
		end

		return object:checkForUpdate():andThen(function(p6)
			local appUpdateStatus = p6.appUpdateStatus
			joinGamePlayButton(p3.InfluxDb, "checkForUpdate", {
				ctx = p4,
				appUpdateStatus = appUpdateStatus
			})

			if p6.errorMessage then
				return Promise.reject(p6.errorMessage)
			end

			return Promise.resolve(v5[appUpdateStatus])
		end)
	end
end
