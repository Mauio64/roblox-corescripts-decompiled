local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStoreAgeSignalsManager/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStoreAgeSignalsManager/UrlBuilder").UrlBase
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStoreAgeSignalsManager/Fetch")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStoreAgeSignalsManager/Promise")
local fetch = Fetch.fetch
local response = Fetch.Response

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "app-signals-service/v1/app-signals/get-eligibility",
	query = { signalSource = "{signalSource}" }
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "app-signals-service/v1/app-signals/store-result"
})

return {
	checkEligibility = function()
		local v7 = fetch
		local name = UserInputService:GetPlatform().Name
		return Promise.new(function(callback, callback2)
			local expect = v7(v5({ signalSource = name }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(string.format("Eligibility check failed with HTTP status: %d", expect.status))
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback({ eligible = expect2.eligible, signalSource = name })
			else
				callback2("Failed to decode eligibility response as JSON")
			end
		end)
	end,
	publishResult = function(p2, p3, p4)
		local v7 = fetch
		return Promise.new(function(callback, callback2)
			local expect = v7(v6(), {
				method = "POST",
				body = HttpService:JSONEncode({
					signalSource = p2,
					encodedSignals = p3,
					resultType = p4
				}),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function()
				return response.error()
			end):expect()

			if expect.ok then
				callback()
			else
				callback2(string.format("Publish result failed with HTTP status: %d", expect.status))
			end
		end)
	end
}
