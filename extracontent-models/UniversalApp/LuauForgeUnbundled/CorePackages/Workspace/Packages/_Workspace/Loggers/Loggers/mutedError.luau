local RobloxAppEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/Loggers/RobloxAppEvents")
local fFlagDebugUnmuteLuaErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/Loggers/SharedFlags").Debug.FFlagDebugUnmuteLuaErrors

local function IsRunningInStudio()
	local RunService = game:GetService("RunService")
	return RunService:IsStudio()
end

return function(message, p2)
	if type(message) ~= "string" then
		warn("mutedError: errorMessage should be a string!")

		local success, result = pcall(function()
			message = tostring(message)
		end)

		if not success then
			message = "mutedError"
		end
	end

	if fFlagDebugUnmuteLuaErrors then
		error(message)
	else
		local RunService = game:GetService("RunService")

		if RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ then
			error(message)
		else
			if type(p2) == "table" and type(p2.stacks) == "table" then
				table.insert(p2.stacks, debug.traceback())
			end

			RobloxAppEvents.ReportMutedError:fire(message, debug.traceback(), script, p2)
		end
	end
end
