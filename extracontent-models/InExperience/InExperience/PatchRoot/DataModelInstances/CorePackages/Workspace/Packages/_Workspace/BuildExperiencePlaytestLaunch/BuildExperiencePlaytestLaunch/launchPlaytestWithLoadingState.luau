local BuildExperiencePlaytestLaunch = script:FindFirstAncestor("BuildExperiencePlaytestLaunch")

local GetPlaytestLoadingStore = require(BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)
local playtestExperience = require(script.Parent.playtestExperience)
local releaseAnyFocus = require(script.Parent.releaseAnyFocus)

local function launchPlaytestWithLoadingState(p: number, p2: string, isTeamTest: boolean?, callback, isEarlyTesting: boolean?): boolean
	local playtestLoadingStore = GetPlaytestLoadingStore()

	if playtestLoadingStore.getIsPlaytestLoadingForPlaceId(p)() then
		return false
	end

	playtestLoadingStore.setPlaytestStatusForPlaceId(p, "Loading")

	task.defer(function()
		local traceback = nil
		local v = "experience_launch"

		if not xpcall(function()
			releaseAnyFocus()
			v = playtestExperience(p, p2, {
				isTeamTest = isTeamTest,
				isEarlyTesting = isEarlyTesting,
				onTeleportFailed = function()
					playtestLoadingStore.setPlaytestStatusForPlaceId(p, "Idle")

					if callback ~= nil then
						callback()
					end
				end
			})
		end, function(p3)
			traceback = debug.traceback(tostring(p3), 2)
		end) then
			playtestLoadingStore.setPlaytestStatusForPlaceId(p, "Idle")

			if callback ~= nil then
				callback()
			end

			error(traceback or "Failed to launch playtest", 0)
		end

		if v == "teleport_pending" then
			return
		end

		playtestLoadingStore.setPlaytestStatusForPlaceId(p, "Completed")
	end)
	return true
end

return launchPlaytestWithLoadingState
