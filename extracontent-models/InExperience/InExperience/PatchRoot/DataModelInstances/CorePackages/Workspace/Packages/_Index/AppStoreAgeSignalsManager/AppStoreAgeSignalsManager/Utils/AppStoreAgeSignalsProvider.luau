local parent = script:FindFirstAncestor("AppStoreAgeSignalsManager").Parent

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Fetch = require(parent.Fetch)
local Promise = require(parent.Promise)
local fetch = Fetch.fetch
local Response = Fetch.Response

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "app-signals-service/v1/app-signals/get-eligibility",
	query = { signalSource = "{signalSource}" }
})

local v2 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "app-signals-service/v1/app-signals/store-result"
})
local AppStoreAgeSignalsProvider = {}

function AppStoreAgeSignalsProvider.checkEligibility()
	local fetch2 = fetch
	local name = UserInputService:GetPlatform().Name
	return Promise.new(function(callback, callback2)
		local expect = fetch2(v({ signalSource = name }), { method = "GET" }):catch(function()
			return Response.error()
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
end

function AppStoreAgeSignalsProvider.publishResult(signalSource: string, encodedSignals: string, resultType: string)
	local fetch2 = fetch
	return Promise.new(function(callback, callback2)
		local expect = fetch2(v2(), {
			method = "POST",
			body = HttpService:JSONEncode({
				signalSource = signalSource,
				encodedSignals = encodedSignals,
				resultType = resultType
			}),
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
		end):expect()

		if expect.ok then
			callback()
		else
			callback2(string.format("Publish result failed with HTTP status: %d", expect.status))
		end
	end)
end

return AppStoreAgeSignalsProvider
