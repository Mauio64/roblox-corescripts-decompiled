local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Fetch = require(parent.Fetch)
local Promise = require(parent.Promise)

require(AmpV2Wizard.OdpVerification.Types)

local fetch = Fetch.fetch
local Response = Fetch.Response

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "age-verification-service/v1/age-verification/start-odp-verification"
})

return {
	startOdpVerification = function(p)
		return Promise.new(function(callback, callback2)
			local expect = fetch(v(), {
				method = "POST",
				body = HttpService:JSONEncode({
					sessionId = p.sessionId,
					verificationType = p.verificationType
				}),
				headers = { ["Content-Type"] = "application/json" }
			}):catch(function()
				return Response.error()
			end):expect()

			if not expect.ok then
				callback2(`start-odp-verification failed with status: {expect.status}`)
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback({
					sessionIdentifier = expect2.sessionIdentifier,
					verificationLink = expect2.verificationLink
				})
			else
				callback2("Failed to decode start-odp-verification response")
			end
		end)
	end
}
