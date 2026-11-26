local HttpService = game:GetService("HttpService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/dependencies")
local promise = dependencies.Promise
local urlBuilder = dependencies.UrlBuilder
local urlBase = dependencies.UrlBase
local fetch = dependencies.Fetch
local fetch2 = fetch.fetch
local response = fetch.Response
local ConsentName = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Enums/ConsentName")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "user-consents-api/v1/user-consents/one-time"
})

return {
	grantOneTimeUserConsent = function(p2, p3, p4)
		local v6 = ConsentName[p2]

		if not v6 then
			return promise.reject(`Invalid consent name type: {p2}`)
		end

		local v7 = v5()
		return promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetch2(v7, {
					method = "POST",
					body = HttpService:JSONEncode({ consentType = v6, ttlSeconds = p3 }),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = p4
					}
				}):catch(function(p5)
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
