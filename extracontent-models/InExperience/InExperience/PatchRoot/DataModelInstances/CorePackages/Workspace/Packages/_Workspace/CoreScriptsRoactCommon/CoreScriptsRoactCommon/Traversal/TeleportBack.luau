local TeleportService = game:GetService("TeleportService")

local engineFeature = game:GetEngineFeature("UseTeleportedPlacesBackHistory2")

local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local AppCommonLib = require(parent.AppCommonLib)

local isRunningInStudio = AppCommonLib.isRunningInStudio

local Flags = require(script.Parent.Flags)
local FFlagUseLocalTraversalHistory = Flags.FFlagUseLocalTraversalHistory
local defineFastInt = game:DefineFastInt("TeleportBackAttemptLimit", 5)
local defineFastInt2 = game:DefineFastInt("TeleportBackRetryDelay", 1)

local function TeleportBack(p: number?)
	if isRunningInStudio() then
		warn("Teleporting is not supported in Studio")
		return
	end

	local count = 0
	local success, result

	repeat
		success, result = pcall(function()
			if (FFlagUseLocalTraversalHistory or engineFeature) and p then
				return TeleportService:TeleportTrustedBackHistory(p)
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
