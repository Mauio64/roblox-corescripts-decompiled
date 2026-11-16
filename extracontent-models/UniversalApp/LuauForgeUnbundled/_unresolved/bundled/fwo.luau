local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module = require("@luauforge/bundled/dyM")
local module2 = require("@luauforge/bundled/fuY")

local defineFastInt = game:DefineFastInt("LuaAppPollRobuxBalanceAttempts", 7)
local defineFastInt2 = game:DefineFastInt("LuaAppPollRobuxBalanceIntervalSec", 2)
local function PollRobuxBalance(object, p2, p3, p4, callback, defineFastInt3)
	return module2(p2, p3):andThen(function(p5)
		local responseBody = p5.responseBody

		if responseBody == nil or responseBody.robux == nil then
			logging.warn("Response from EconomyGetCurrency is malformed!")
			callback(p4)
		else
			local robux = responseBody.robux

			if robux == p4 then
				if defineFastInt3 > 0 then
					delay(defineFastInt2, function()
						PollRobuxBalance(object, p2, p3, p4, callback, defineFastInt3 - 1)
					end)
				else
					callback(p4)
				end
			else
				object:dispatch(module(p3, robux))
				callback(robux)
			end
		end
	end):catch(function()
		callback(p4)
	end)
end

return function(p2, p3, p4, p5)
	return performFetch.Single("com.roblox.economy.users." .. p3 .. ".currency.poll", function(p6)
		return PollRobuxBalance(p6, p2, p3, p4, p5, defineFastInt)
	end)
end
