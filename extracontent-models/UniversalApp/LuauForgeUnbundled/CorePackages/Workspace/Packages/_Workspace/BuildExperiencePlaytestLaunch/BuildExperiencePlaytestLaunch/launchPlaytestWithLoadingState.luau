local GetPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore")
local playtestExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/playtestExperience")
local releaseAnyFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/releaseAnyFocus")

local function launchPlaytestWithLoadingState(p2, p3, p4, callback, p5): boolean
	local v5 = GetPlaytestLoadingStore()

	if v5.getIsPlaytestLoadingForPlaceId(p2)() then
		return false
	end

	v5.setPlaytestStatusForPlaceId(p2, "Loading")

	task.defer(function()
		local traceback = nil
		local v6 = "experience_launch"

		if not xpcall(function()
			releaseAnyFocus()
			v6 = playtestExperience(p2, p3, {
				isTeamTest = p4,
				isEarlyTesting = p5,
				onTeleportFailed = function()
					v5.setPlaytestStatusForPlaceId(p2, "Idle")

					if callback ~= nil then
						callback()
					end
				end
			})
		end, function(p6)
			traceback = debug.traceback(tostring(p6), 2)
		end) then
			v5.setPlaytestStatusForPlaceId(p2, "Idle")

			if callback ~= nil then
				callback()
			end

			error(traceback or "Failed to launch playtest", 0)
		end

		if v6 == "teleport_pending" then
			return
		end

		v5.setPlaytestStatusForPlaceId(p2, "Completed")
	end)
	return true
end

return launchPlaytestWithLoadingState
