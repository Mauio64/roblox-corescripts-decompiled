local Parent = script:FindFirstAncestor("AppStoreAgeSignalsManager").Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local Fetch = require(Parent.Fetch)
local Promise = require(Parent.Promise)
local fetch = Fetch.fetch
local Response = Fetch.Response
local v10 = UrlBuilder.new({
	path = "app-signals-service/v1/app-signals/get-eligibility",
	base = UrlBase.APIS,
	query = {
		signalSource = "{signalSource}"
	}
})
local v11 = UrlBuilder.new({
	path = "app-signals-service/v1/app-signals/store-result",
	base = UrlBase.APIS
})

return {
	checkEligibility = function() -- line: 27
		-- upvalues: fetch (copy), UserInputService (copy), Promise (copy), v10 (copy), Response (copy)
		local v12 = fetch
		local Name = UserInputService:GetPlatform().Name

		return Promise.new(function(resolve, reject) -- line: 30
			-- upvalues: v10 (copy), Name (copy), v12 (copy), Response (copy)
			local v20 = v10({
				signalSource = Name
			})
			local v21 = v12(v20, {
				method = "GET"
			}):catch(function() -- line: 33
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if not v21.ok then
				reject(string.format("Eligibility check failed with HTTP status: %d", v21.status))

				return
			end

			local v22 = v21:json():catch(function() -- line: 45
				return nil
			end):expect()

			if not v22 then
				reject("Failed to decode eligibility response as JSON")

				return
			end

			resolve({
				eligible = v22.eligible,
				signalSource = Name
			})
		end)
	end,
	publishResult = function(s1: string, s2: string, s3: string) -- line: 62
		-- upvalues: fetch (copy), Promise (copy), v11 (copy), HttpService (copy), Response (copy)
		local v17 = fetch

		return Promise.new(function(resolve, reject) -- line: 64
			-- upvalues: v11 (copy), v17 (copy), HttpService (copy), s1 (copy), s2 (copy), s3 (copy), Response (copy)
			local v25 = v11()
			local v26 = v17(v25, {
				method = "POST",
				body = HttpService:JSONEncode({
					signalSource = s1,
					encodedSignals = s2,
					resultType = s3
				}),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function() -- line: 78
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if not v26.ok then
				reject(string.format("Publish result failed with HTTP status: %d", v26.status))

				return
			end

			resolve()
		end)
	end
}
