local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local promise = dependencies.Promise
local urlBuilder = dependencies.UrlBuilder
local urlBase = dependencies.UrlBase
local fetch = dependencies.Fetch
local fetch2 = fetch.fetch
local response = fetch.Response
local ConsentName = require(parent.Enums.ConsentName)

local v = urlBuilder.new({
	base = urlBase.APIS,
	path = "user-consents-api/v1/user-consents/one-time"
})

return {
	grantOneTimeUserConsent = function(p, ttlSeconds: number?, rbxauditdata: string)
		local consentType = ConsentName[p]

		if not consentType then
			return promise.reject(`Invalid consent name type: {p}`)
		end

		local v2 = v()
		return promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetch2(v2, {
					method = "POST",
					body = HttpService:JSONEncode({
						consentType = consentType,
						ttlSeconds = ttlSeconds
					}),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = rbxauditdata
					}
				}):catch(function(_)
					return response.error()
				end):expect()
			end)

			if not success then
				callback2("Failed to make request: " .. tostring(result))
			elseif result.ok then
				callback()
			else
				callback2((string.format(
					"Got grant one time user consent HTTP Response: %d - %s",
					result.status,
					result.statusText
				)))
			end
		end)
	end
}
