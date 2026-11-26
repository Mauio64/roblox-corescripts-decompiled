local TeleportService = game:GetService("TeleportService")

local engineFeature = game:GetEngineFeature("UseTeleportedPlacesBackHistory2")

local isRunningInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/AppCommonLib").isRunningInStudio

local fFlagUseLocalTraversalHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Flags").FFlagUseLocalTraversalHistory
local defineFastInt = game:DefineFastInt("TeleportBackAttemptLimit", 5)
local defineFastInt2 = game:DefineFastInt("TeleportBackRetryDelay", 1)

local function TeleportBack(p2)
	if isRunningInStudio() then
		warn("Teleporting is not supported in Studio")
		return
	end

	local count = 0
	local success, result

	repeat
		success, result = pcall(function()
			if (fFlagUseLocalTraversalHistory or engineFeature) and p2 then
				return TeleportService:TeleportTrustedBackHistory(p2)
			end

			return TeleportService:TeleportTrustedBackForth(false)
		end)

		count += 1

		if not success then
			task.wait(defineFastInt2)
		end
	until success or count == defineFastInt

	if not success then
		warn(result)
	end

	return success, result
end

return TeleportBack
