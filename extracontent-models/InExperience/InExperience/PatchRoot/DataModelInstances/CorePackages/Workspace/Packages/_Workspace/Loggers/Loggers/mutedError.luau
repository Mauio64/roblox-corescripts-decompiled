local Parent = script:FindFirstAncestor("Loggers").Parent
local RobloxAppEvents = require(Parent.RobloxAppEvents)
local FFlagDebugUnmuteLuaErrors = require(Parent.SharedFlags).Debug.FFlagDebugUnmuteLuaErrors

local function IsRunningInStudio() -- line: 20
	return game:GetService("RunService"):IsStudio()
end

return function(s1: string, p1) -- line: 24
	-- upvalues: FFlagDebugUnmuteLuaErrors (copy), RobloxAppEvents (copy)
	if type(s1) ~= "string" then
		warn("mutedError: errorMessage should be a string!")

		local ok, _ = pcall(function() -- line: 28
			-- upvalues: s1 (ref)
			s1 = tostring(s1)
		end)

		if not ok then
			s1 = "mutedError"
		end
	end

	if FFlagDebugUnmuteLuaErrors or game:GetService("RunService"):IsStudio() or _G.__TESTEZ_RUNNING_TEST__ then
		error(s1)
	else
		if type(p1) == "table" and type(p1.stacks) == "table" then
			table.insert(p1.stacks, debug.traceback())
		end

		RobloxAppEvents.ReportMutedError:fire(s1, debug.traceback(), script, p1)
	end
end
