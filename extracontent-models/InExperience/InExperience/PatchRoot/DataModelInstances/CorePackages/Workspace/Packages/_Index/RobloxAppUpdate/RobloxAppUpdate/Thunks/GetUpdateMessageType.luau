local RobloxAppUpdate = script:FindFirstAncestor("RobloxAppUpdate")
local RobloxAppUpdateParent = RobloxAppUpdate.Parent

require(RobloxAppUpdate.Types)

local joinGamePlayButton = require(RobloxAppUpdateParent.DiscoveryAnalytics).Points.joinGamePlayButton
local UpdateMessageType = require(RobloxAppUpdate.UpdateMessageType)
local Promise = require(RobloxAppUpdateParent.Promise)
local t1 = {
	[Enum.AppUpdateStatus.Available] = UpdateMessageType.Default,
	[Enum.AppUpdateStatus.AvailableBoundChannel] = UpdateMessageType.InternalChannel,
	[Enum.AppUpdateStatus.AvailableBetaProgram] = UpdateMessageType.BetaProgram
}

return function(p1, b1: boolean, p2, s1: string) -- line: 15
	-- upvalues: Promise (copy), joinGamePlayButton (copy), t1 (copy)
	return function(_: {[any]: any}) -- line: 21
		-- upvalues: b1 (copy), p1 (copy), Promise (copy), joinGamePlayButton (copy), p2 (copy), s1 (copy), t1 (copy)
		if b1 and not p1:canPerformBinaryUpdate() then
			return Promise.resolve(nil)
		end

		return p1:checkForUpdate():andThen(function(p3) -- line: 26
			-- upvalues: joinGamePlayButton (copy), p2 (copy), s1 (copy), Promise (copy), t1 (copy)
			local appUpdateStatus = p3.appUpdateStatus

			joinGamePlayButton(p2.InfluxDb, "checkForUpdate", {
				ctx = s1,
				appUpdateStatus = appUpdateStatus
			})

			if p3.errorMessage then
				return Promise.reject(p3.errorMessage)
			end

			return Promise.resolve(t1[appUpdateStatus])
		end)
	end
end
