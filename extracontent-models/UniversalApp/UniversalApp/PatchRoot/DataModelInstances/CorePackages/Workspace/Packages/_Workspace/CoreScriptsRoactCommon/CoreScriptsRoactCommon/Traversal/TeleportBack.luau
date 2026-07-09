local TeleportService = game:GetService("TeleportService")
local EngineFeature = game:GetEngineFeature("UseTeleportedPlacesBackHistory2")
local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local isRunningInStudio = require(Parent.AppCommonLib).isRunningInStudio
local FFlagUseLocalTraversalHistory = require(script.Parent.Flags).FFlagUseLocalTraversalHistory
local v6 = game:DefineFastInt("TeleportBackAttemptLimit", 5)
local v7 = game:DefineFastInt("TeleportBackRetryDelay", 1)

local function TeleportBack(n1: number?) -- line: 17
	-- upvalues: isRunningInStudio (copy), FFlagUseLocalTraversalHistory (copy), EngineFeature (copy), TeleportService (copy), v7 (copy), v6 (copy)
	if isRunningInStudio() then
		warn("Teleporting is not supported in Studio")

		return
	end

	local n2 = 0
	local ok, result

	repeat
		ok, result = pcall(function() -- line: 27
			-- upvalues: FFlagUseLocalTraversalHistory (copy), EngineFeature (copy), n1 (copy), TeleportService (copy)
			if (FFlagUseLocalTraversalHistory or EngineFeature) and n1 then
				return TeleportService:TeleportTrustedBackHistory(n1)
			end

			return TeleportService:TeleportTrustedBackForth(false)
		end)
		n2 += 1

		if not ok then
			task.wait(v7)
		end
	until ok or n2 == v6

	if not ok then
		warn(result)
	end

	return ok, result
end

return TeleportBack
