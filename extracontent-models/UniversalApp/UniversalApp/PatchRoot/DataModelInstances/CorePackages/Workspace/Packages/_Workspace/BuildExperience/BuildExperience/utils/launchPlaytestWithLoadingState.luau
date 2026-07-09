local BuildExperience = script:FindFirstAncestor("BuildExperience")
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)
local playtestExperience = require(script.Parent.playtestExperience)
local releaseAnyFocus = require(script.Parent.releaseAnyFocus)

local function launchPlaytestWithLoadingState(n1: number, s1: string, b1: boolean?) -- line: 7
	-- upvalues: GetPlaytestLoadingStore (copy), releaseAnyFocus (copy), playtestExperience (copy)
	local v9 = GetPlaytestLoadingStore()

	if v9.getIsPlaytestLoadingForPlaceId(n1)() then
		return
	end

	v9.setPlaytestStatusForPlaceId(n1, "Loading")
	task.defer(function() -- line: 16
		-- upvalues: releaseAnyFocus (copy), playtestExperience (copy), n1 (copy), s1 (copy), b1 (copy), v9 (copy)
		local trace = nil
		local s2 = "experience_launch"

		if not xpcall(function() -- line: 19
			-- upvalues: releaseAnyFocus (copy), s2 (ref), playtestExperience (copy), n1 (copy), s1 (copy), b1 (copy), v9 (copy)
			releaseAnyFocus()
			s2 = playtestExperience(n1, s1, {
				isTeamTest = b1,
				onTeleportFailed = function() -- line: 23
					-- upvalues: v9 (copy), n1 (copy)
					v9.setPlaytestStatusForPlaceId(n1, "Idle")
				end
			})
		end, function(err) -- line: 27
			-- upvalues: trace (ref)
			trace = debug.traceback(tostring(err), 2)
		end) then
			v9.setPlaytestStatusForPlaceId(n1, "Idle")
			error(trace or "Failed to launch playtest", 0)
		end

		if s2 == "teleport_pending" then
			return
		end

		v9.setPlaytestStatusForPlaceId(n1, "Completed")
	end)
end

return launchPlaytestWithLoadingState
