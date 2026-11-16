local HttpService = game:GetService("HttpService")

local urlBuilder = require("@luauforge/bundled/gve").UrlBuilder
local urlBase = require("@luauforge/bundled/gve").UrlBase
local module = require("@luauforge/bundled/gvf")
local module2 = require("@luauforge/bundled/gvg")

require("@luauforge/bundled/gvW")

local fetch = module.fetch
local response = module.Response

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "age-verification-service/v1/age-verification/start-odp-verification"
})

return {
	startOdpVerification = function(p2)
		return module2.new(function(callback, callback2)
			local expect = fetch(v5(), {
				method = "POST",
				body = HttpService:JSONEncode({
					sessionId = p2.sessionId,
					verificationType = p2.verificationType
				}),
				headers = { ["Content-Type"] = "application/json" }
			}):catch(function()
				return response.error()
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
