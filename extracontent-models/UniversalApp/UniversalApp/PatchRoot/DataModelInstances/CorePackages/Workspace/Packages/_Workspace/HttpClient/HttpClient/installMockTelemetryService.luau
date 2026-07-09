local Parent = script:FindFirstAncestor("HttpClient").Parent
local jest = require(Parent.Dev.JestGlobals).jest

local function installMockTelemetryService() -- line: 17
	-- upvalues: jest (copy)
	local v4 = jest.fn()
	local v5 = jest.fn()
	local v6 = jest.fn()
	local GetService = game.GetService

	jest.spyOn(game, "GetService").mockImplementation(function(_, s1: string) -- line: 23
		-- upvalues: v4 (copy), v5 (copy), v6 (copy), GetService (copy)
		if s1 == "TelemetryService" then
			return {
				LogEvent = function(_, p3, p4) -- line: 26
					-- upvalues: v4 (copy)
					v4(p3, p4)
				end,
				LogCounter = function(_, p6, p7) -- line: 29
					-- upvalues: v5 (copy)
					v5(p6, p7)
				end,
				LogStat = function(_, p9, p10, n1: number) -- line: 32
					-- upvalues: v6 (copy)
					v6(p9, p10, n1)
				end
			}
		end

		return GetService(game, s1)
	end)

	return {
		logEvent = v4,
		logCounter = v5,
		logStat = v6
	}
end

return installMockTelemetryService
