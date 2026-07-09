local Parent = script:FindFirstAncestor("IdentityVerification").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local Fetch = require(Parent.Fetch)
local Promise = require(Parent.Promise)
local fetch = Fetch.fetch
local Response = Fetch.Response
local Cryo = require(Parent.Cryo)
local v10 = UrlBuilder.new({
	path = "age-verification-service/v1/persona-id-verification/verified-status",
	base = UrlBase.APIS,
	query = {
		token = "{token}"
	}
})
local v11 = UrlBuilder.new({
	path = "age-verification-service/v1/persona-id-verification/start-verification",
	base = UrlBase.APIS
})
local v12 = UrlBuilder.new({
	path = "age-verification-service/v1/persona-id-verification/start-liveness-verification",
	base = UrlBase.APIS
})

local function startVerification(t1: {[any]: any}?, s1: string?) -- line: 113
	-- upvalues: fetch (copy), Promise (copy), v11 (copy), HttpService (copy), Cryo (copy), Response (copy)
	local v20 = fetch

	return Promise.new(function(resolve, reject) -- line: 115
		-- upvalues: s1 (copy), v11 (copy), v20 (copy), HttpService (copy), Cryo (copy), t1 (copy), Response (copy)
		local v33 = s1 or v11()
		local v34 = v20(v33, {
			method = "POST",
			body = HttpService:JSONEncode(Cryo.Dictionary.join({
				generatedLink = true
			}, t1 or {})),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):catch(function() -- line: 125
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v34.ok then
			reject(string.format("Got start-verification HTTP Response: %d", v34.status))

			return
		end

		local v35 = v34:json():catch(function() -- line: 137
			return nil
		end):expect()

		if not v35 then
			reject("Failed to decode HTTP response as JSON for IDV Verification")

			return
		end

		resolve({
			emailSent = v35.emailSent,
			sessionIdentifier = v35.sessionIdentifier,
			daysUntilNextVerification = v35.daysUntilNextVerification,
			verificationLink = v35.verificationLink,
			sessionToken = v35.sessionToken
		})
	end)
end

return {
	startVerification = startVerification,
	startVerificationWithWrappedNetworking = function(p1, t2: {[any]: any}?) -- line: 77
		-- upvalues: Promise (copy), v11 (copy), Cryo (copy), HttpService (copy)
		return Promise.new(function(resolve, reject) -- line: 78
			-- upvalues: v11 (copy), Cryo (copy), t2 (copy), p1 (copy), HttpService (copy)
			local v29 = v11()
			local v30 = Cryo.Dictionary.join({
				generatedLink = true
			}, t2 or {})

			p1(v29, "POST", {
				postBody = HttpService:JSONEncode(v30)
			}):catch(function(_) -- line: 86
				-- upvalues: reject (copy)
				reject("Got error on start-verificatin")
			end):andThen(function(p3) -- line: 90
				-- upvalues: reject (copy), resolve (copy)
				if not p3 or not p3[1] then
					reject("Got start-verification HTTP with no valid response")

					return
				end

				local v38 = p3[1]

				if not v38 then
					reject("Failed to decode HTTP response as JSON for IDV Verification")

					return
				end

				resolve({
					emailSent = v38.emailSent,
					sessionIdentifier = v38.sessionIdentifier,
					daysUntilNextVerification = v38.daysUntilNextVerification,
					verificationLink = v38.verificationLink,
					sessionToken = v38.sessionToken
				})
			end)
		end)
	end,
	startLivenessVerification = function(t3: {[any]: any}?) -- line: 158
		-- upvalues: startVerification (copy), v12 (copy)
		return startVerification(t3, v12())
	end,
	getVerifiedStatus = function(p4) -- line: 34
		-- upvalues: fetch (copy), Promise (copy), v10 (copy), Response (copy)
		local v15 = fetch

		return Promise.new(function(resolve, reject) -- line: 36
			-- upvalues: v10 (copy), p4 (copy), v15 (copy), Response (copy)
			local v24 = v10({
				token = p4
			})
			local v25 = v15(v24, {
				method = "GET"
			}):catch(function() -- line: 39
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if not v25.ok then
				reject(string.format("Got verified-status verification HTTP Response: %d", v25.status))

				return
			end

			local v26 = v25:json():catch(function() -- line: 53
				return nil
			end):expect()

			if not v26 then
				reject("Failed to decode HTTP response as JSON for get IDV Verification status")

				return
			end

			resolve({
				isPending = v26.isPending,
				sessionStatus = v26.sessionStatus,
				sessionErrorCode = v26.sessionErrorCode,
				isVerified = v26.isVerified,
				ageEstimationNextStep = v26.ageEstimationNextStep
			})
		end)
	end
}
