local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/fuY")
local module3 = require("@luauforge/bundled/dyM")

return function(p2, value, p3)
	if type(value) ~= "string" then
		error("ApiFetchEconomyCurrency thunk expects userId to be a string")
	end

	return performFetch.Single("com.roblox.economy.users." .. value .. ".currency", function(object)
		local v5 = object:getState().UserRobux[value]

		if p3 or v5 == nil then
			return module2(p2, value):andThen(function(p4)
				local responseBody = p4.responseBody

				if responseBody == nil or responseBody.robux == nil then
					logging.warn("Response from EconomyGetCurrency is malformed!")
					return module.reject({ HttpError = Enum.HttpError.OK })
				end

				object:dispatch(module3(value, responseBody.robux))
				return p4
			end):catch(function(p4)
				logging.warn("Failed to fetch user currency: " .. tostring(p4))
				return module.reject({ HttpError = Enum.HttpError.OK })
			end)
		end

		return module.resolve()
	end)
end
