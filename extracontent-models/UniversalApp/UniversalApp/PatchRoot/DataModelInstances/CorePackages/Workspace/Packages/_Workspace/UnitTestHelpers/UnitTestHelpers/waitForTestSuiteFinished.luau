local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")

local function waitUntil(p1, p2) -- line: 6
	-- upvalues: RunService (copy)
	local v7 = p2 or 1
	local n1 = 0

	while n1 < v7 and not p1() do
		n1 += RunService.Heartbeat:Wait()
	end
end
local function waitForTestSuiteFinished() -- line: 14
	-- upvalues: waitUntil (copy), LogService (copy)
	waitUntil(function() -- line: 15
		-- upvalues: LogService (copy)
		local LogHistory = LogService:GetLogHistory()

		for _, v in ipairs(LogHistory) do
			if string.match(v.message, "%d+ passed, %d+ failed, %d+ skipped") then
				return true
			end
		end

		return false
	end, 300)
end

return waitForTestSuiteFinished
