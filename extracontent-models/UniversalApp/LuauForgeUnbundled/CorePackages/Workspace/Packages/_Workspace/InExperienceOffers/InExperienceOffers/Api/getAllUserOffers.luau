local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Http").Url
local Errors = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Api/Errors")
local OffersDebugLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Internal/OffersDebugLogger")
local logCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Internal/logCounter")
local GetAllUserOffersFailedCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Events/GetAllUserOffersFailedCounter")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local v5 = url.APIS_URL .. "checkout/v1/offers"

local function buildUserOffersUrl(list)
	return `{v5}?{url:makeQueryString({ featureKeys = table.concat(list, ",") })}`
end

local function getAllUserOffers(p2)
	return Promise.new(function(callback, callback2)
		local function rejectFetch(p3)
			logCounter(GetAllUserOffersFailedCounter, 1, { errorKind = p3.kind })
			callback2(p3)
		end

		task.spawn(function()
			local formatted = `{v5}?{url:makeQueryString({ featureKeys = table.concat(p2, ",") })}`

			OffersDebugLogger.logLazy(function()
				return "getAllUserOffers: GET " .. formatted
			end)

			local v7 = OffersDebugLogger.startTimer()

			local success, result = pcall(function()
				return HttpRbxApiService:GetAsyncFullUrl(formatted)
			end)

			if success then
				OffersDebugLogger.logElapsed("getAllUserOffers: HTTP response received", v7)

				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(result)
				end)

				if success2 then
					if typeof(result2) == "table" and typeof(result2.offers) == "table" then
						callback(result2)
						return
					end

					OffersDebugLogger.log("getAllUserOffers: schema error, missing offers")

					local schemaError = Errors.schemaError(
						"getAllUserOffers: malformed response, expected { offers = ... }",
						result2
					)
					logCounter(GetAllUserOffersFailedCounter, 1, { errorKind = schemaError.kind })
					callback2(schemaError)
				else
					OffersDebugLogger.logLazy(function()
						return "getAllUserOffers: JSON parse error=" .. tostring(result2)
					end)

					local err = Errors.parseError(
						"getAllUserOffers: response body is not valid JSON",
						result2
					)
					logCounter(GetAllUserOffersFailedCounter, 1, { errorKind = err.kind })
					callback2(err)
				end
			else
				OffersDebugLogger.logElapsed("getAllUserOffers: HTTP error", v7)
				OffersDebugLogger.logLazy(function()
					return "getAllUserOffers: HTTP error detail=" .. tostring(result)
				end)

				local networkError = Errors.networkError("getAllUserOffers: HTTP request failed", result)
				logCounter(GetAllUserOffersFailedCounter, 1, { errorKind = networkError.kind })
				callback2(networkError)
			end
		end)
	end)
end

return getAllUserOffers
