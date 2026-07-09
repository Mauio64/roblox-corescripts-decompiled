local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetUserRobux = require(Modules.LuaApp.Actions.SetUserRobux)
local EconomyGetCurrency = require(Modules.LuaApp.Http.Requests.EconomyGetCurrency)
local v7 = game:DefineFastInt("LuaAppPollRobuxBalanceAttempts", 7)
local v8 = game:DefineFastInt("LuaAppPollRobuxBalanceIntervalSec", 2)

local function PollRobuxBalance(p1, p2: ((...any) -> ...any), s1: string, n1: number, p3: ((...any) -> ...any), n2: number) -- line: 12
	-- upvalues: EconomyGetCurrency (copy), Logging (copy), SetUserRobux (copy), v8 (copy), PollRobuxBalance (copy)
	return EconomyGetCurrency(p2, s1):andThen(function(p4) -- line: 20
		-- upvalues: Logging (copy), p3 (copy), n1 (copy), p1 (copy), SetUserRobux (copy), s1 (copy), n2 (copy), v8 (copy), PollRobuxBalance (copy), p2 (copy)
		local responseBody = p4.responseBody

		if responseBody == nil or responseBody.robux == nil then
			Logging.warn("Response from EconomyGetCurrency is malformed!")
			p3(n1)

			return
		end

		local robux = responseBody.robux

		if robux ~= n1 then
			p1:dispatch(SetUserRobux(s1, robux))
			p3(robux)

			return
		end

		if n2 > 0 then
			delay(v8, function() -- line: 36
				-- upvalues: PollRobuxBalance (copy), p1 (copy), p2 (copy), s1 (copy), n1 (copy), p3 (copy), n2 (copy)
				PollRobuxBalance(p1, p2, s1, n1, p3, n2 - 1)
			end)

			return
		end

		p3(n1)
	end):catch(function() -- line: 42
		-- upvalues: p3 (copy), n1 (copy)
		p3(n1)
	end)
end

return function(p5: ((...any) -> ...any), s2: string, n3: number, p6: ((...any) -> ...any)) -- line: 47
	-- upvalues: PerformFetch (copy), PollRobuxBalance (copy), v7 (copy)
	return PerformFetch.Single("com.roblox.economy.users." .. s2 .. ".currency.poll", function(p7) -- line: 48
		-- upvalues: PollRobuxBalance (copy), p5 (copy), s2 (copy), n3 (copy), p6 (copy), v7 (copy)
		return PollRobuxBalance(p7, p5, s2, n3, p6, v7)
	end)
end
