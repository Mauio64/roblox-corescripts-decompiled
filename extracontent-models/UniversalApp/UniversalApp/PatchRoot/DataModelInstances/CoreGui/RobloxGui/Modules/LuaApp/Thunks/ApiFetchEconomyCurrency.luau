local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local EconomyGetCurrency = require(Modules.LuaApp.Http.Requests.EconomyGetCurrency)
local SetUserRobux = require(Modules.LuaApp.Actions.SetUserRobux)

return function(p1, p2, p3) -- line: 10
	-- upvalues: PerformFetch (copy), Promise (copy), EconomyGetCurrency (copy), SetUserRobux (copy), Logging (copy)
	if type(p2) ~= "string" then
		error("ApiFetchEconomyCurrency thunk expects userId to be a string")
	end

	return PerformFetch.Single("com.roblox.economy.users." .. p2 .. ".currency", function(p4) -- line: 15
		-- upvalues: p2 (copy), p3 (copy), Promise (copy), EconomyGetCurrency (copy), p1 (copy), SetUserRobux (copy), Logging (copy)
		local v12 = p4:getState().UserRobux[p2]

		if not p3 and v12 ~= nil then
			return Promise.resolve()
		end

		return EconomyGetCurrency(p1, p2):andThen(function(p5) -- line: 20
			-- upvalues: p4 (copy), SetUserRobux (copy), p2 (copy), Logging (copy), Promise (copy)
			local responseBody = p5.responseBody

			if responseBody ~= nil and responseBody.robux ~= nil then
				p4:dispatch(SetUserRobux(p2, responseBody.robux))

				return p5
			end

			Logging.warn("Response from EconomyGetCurrency is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end):catch(function(p6) -- line: 30
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("Failed to fetch user currency: " .. tostring(p6))

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end)
end
