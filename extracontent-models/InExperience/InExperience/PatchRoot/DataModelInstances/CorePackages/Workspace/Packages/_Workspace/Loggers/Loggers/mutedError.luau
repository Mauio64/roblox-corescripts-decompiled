local parent = script:FindFirstAncestor("Loggers").Parent

local RobloxAppEvents = require(parent.RobloxAppEvents)
local SharedFlags = require(parent.SharedFlags)
local FFlagDebugUnmuteLuaErrors = SharedFlags.Debug.FFlagDebugUnmuteLuaErrors

local function IsRunningInStudio() -- 1 equivalent call inferred from this helper
	local RunService = game:GetService("RunService")
	return RunService:IsStudio()
end

return function(message: string, p)
	if type(message) ~= "string" then
		warn("mutedError: errorMessage should be a string!")

		local success, _ = pcall(function()
			message = tostring(message)
		end)

		if not success then
			message = "mutedError"
		end
	end

	if FFlagDebugUnmuteLuaErrors then
		error(message)
	elseif IsRunningInStudio() or _G.__TESTEZ_RUNNING_TEST__ then -- inferred equivalent call
		error(message)
	else
		if type(p) == "table" and type(p.stacks) == "table" then
			table.insert(p.stacks, debug.traceback())
		end

		RobloxAppEvents.ReportMutedError:fire(message, debug.traceback(), script, p)
	end
end
