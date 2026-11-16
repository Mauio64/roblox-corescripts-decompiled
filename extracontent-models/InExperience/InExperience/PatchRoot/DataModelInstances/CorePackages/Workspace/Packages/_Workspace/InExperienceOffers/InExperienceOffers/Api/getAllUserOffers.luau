local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local Errors = require(script.Parent.Errors)
local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)
local logCounter = require(InExperienceOffers.Internal.logCounter)
local GetAllUserOffersFailedCounter = require(InExperienceOffers.Events.GetAllUserOffersFailedCounter)
require(InExperienceOffers.Types)

local v = Url.APIS_URL .. "checkout/v1/offers"

local function buildUserOffersUrl(list) -- 1 equivalent call inferred from this helper
	return `{v}?{Url:makeQueryString({ featureKeys = table.concat(list, ",") })}`
end

local function getAllUserOffers(list)
	return Promise.new(function(callback, callback2)
		local function rejectFetch(p) -- 3 equivalent calls inferred from this helper
			logCounter(GetAllUserOffersFailedCounter, 1, { errorKind = p.kind })
			callback2(p)
		end

		task.spawn(function()
			local userOffersUrl = buildUserOffersUrl(list) -- inferred equivalent call
			OffersDebugLogger.logLazy(function()
				return "getAllUserOffers: GET " .. userOffersUrl
			end)

			local v2 = OffersDebugLogger.startTimer()

			local success, result = pcall(function()
				return HttpRbxApiService:GetAsyncFullUrl(userOffersUrl)
			end)

			if success then
				OffersDebugLogger.logElapsed("getAllUserOffers: HTTP response received", v2)

				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(result)
				end)

				if success2 then
					if typeof(result2) == "table" and typeof(result2.offers) == "table" then
						callback(result2)
						return
					end

					OffersDebugLogger.log("getAllUserOffers: schema error, missing offers")

					rejectFetch(Errors.schemaError( -- inferred equivalent call
						"getAllUserOffers: malformed response, expected { offers = ... }",
						result2
					))
				else
					OffersDebugLogger.logLazy(function()
						return "getAllUserOffers: JSON parse error=" .. tostring(result2)
					end)

					rejectFetch(Errors.parseError("getAllUserOffers: response body is not valid JSON", result2)) -- inferred equivalent call
				end
			else
				OffersDebugLogger.logElapsed("getAllUserOffers: HTTP error", v2)
				OffersDebugLogger.logLazy(function()
					return "getAllUserOffers: HTTP error detail=" .. tostring(result)
				end)

				rejectFetch(Errors.networkError("getAllUserOffers: HTTP request failed", result)) -- inferred equivalent call
			end
		end)
	end)
end

return getAllUserOffers
