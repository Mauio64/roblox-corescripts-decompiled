local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Promise = dependencies.Promise
local UrlBuilder = dependencies.UrlBuilder
local UrlBase = dependencies.UrlBase
local Fetch = dependencies.Fetch
local fetch = Fetch.fetch
local Response = Fetch.Response
local ConsentName = require(ParentParent.Enums.ConsentName)
local v11 = UrlBuilder.new({
	path = "user-consents-api/v1/user-consents/one-time",
	base = UrlBase.APIS
})

return {
	grantOneTimeUserConsent = function(p1, n1: number?, s1: string) -- line: 18
		-- upvalues: ConsentName (copy), Promise (copy), v11 (copy), fetch (copy), HttpService (copy), Response (copy)
		local v15 = ConsentName[p1]

		if not v15 then
			return Promise.reject(`Invalid consent name type: { p1 }`)
		end

		local v16 = v11()

		return Promise.new(function(resolve, reject) -- line: 25
			-- upvalues: fetch (copy), v16 (copy), HttpService (copy), v15 (copy), n1 (copy), s1 (copy), Response (copy)
			local ok, result = pcall(function() -- line: 26
				-- upvalues: fetch (copy), v16 (copy), HttpService (copy), v15 (copy), n1 (copy), s1 (copy), Response (copy)
				return fetch(v16, {
					method = "POST",
					body = HttpService:JSONEncode({
						consentType = v15,
						ttlSeconds = n1
					}),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = s1
					}
				}):catch(function(_) -- line: 39
					-- upvalues: Response (copy)
					return Response.error()
				end):expect()
			end)

			if not ok then
				reject("Failed to make request: " .. tostring(result))

				return
			end

			if not result.ok then
				reject((string.format("Got grant one time user consent HTTP Response: %d - %s", result.status, result.statusText)))

				return
			end

			resolve()
		end)
	end
}
