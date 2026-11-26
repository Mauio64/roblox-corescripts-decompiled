local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/UrlBuilder").UrlBase
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/Fetch")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/Promise")
local fetch = Fetch.fetch
local response = Fetch.Response

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/Cryo")

local UniversalFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/UniversalFeatureRestrictions")
local showFeatureRestriction = UniversalFeatureRestrictions.showFeatureRestriction
local abuseVector = UniversalFeatureRestrictions.AbuseVector

local buildAgeVerificationFeatureRestrictionOverrides = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Utils/buildAgeVerificationFeatureRestrictionOverrides")

local FFlagEnableFeatureRestrictionOnAgeVerificationAttempt = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Flags/FFlagEnableFeatureRestrictionOnAgeVerificationAttempt")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "age-verification-service/v1/persona-id-verification/verified-status",
	query = { token = "{token}" }
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "age-verification-service/v1/persona-id-verification/start-verification"
})

local v7 = urlBuilder.new({
	base = urlBase.APIS,
	path = "age-verification-service/v1/persona-id-verification/start-liveness-verification"
})()

local function getHttpStatusFromWrappedNetworkingError(data)
	if type(data) == "table" then
		return data.StatusCode or data.responseCode or data.status or data.statusCode
	end

	return nil
end

local function maybeShowAgeVerificationFeatureRestriction(p2)
	if not FFlagEnableFeatureRestrictionOnAgeVerificationAttempt or p2 ~= 403 then
		return
	end

	showFeatureRestriction(abuseVector.AgeVerification, buildAgeVerificationFeatureRestrictionOverrides())
end

local function startVerification(options, p2)
	local v8 = p2 or v6()
	local v9 = v8 ~= v7
	local v10 = fetch
	return Promise.new(function(callback, callback2)
		local expect = v10(v8, {
			method = "POST",
			body = HttpService:JSONEncode(Cryo.Dictionary.join({
				generatedLink = true
			}, options or {})),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):catch(function()
			return response.error()
		end):expect()

		if expect.ok then
			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback({
					emailSent = expect2.emailSent,
					sessionIdentifier = expect2.sessionIdentifier,
					daysUntilNextVerification = expect2.daysUntilNextVerification,
					verificationLink = expect2.verificationLink,
					sessionToken = expect2.sessionToken
				})
			else
				callback2("Failed to decode HTTP response as JSON for IDV Verification")
			end
		else
			if v9 then
				local status = expect.status

				if FFlagEnableFeatureRestrictionOnAgeVerificationAttempt and status == 403 then
					showFeatureRestriction(abuseVector.AgeVerification, buildAgeVerificationFeatureRestrictionOverrides())
				end
			end

			callback2(string.format("Got start-verification HTTP Response: %d", expect.status))
		end
	end)
end

return {
	startVerification = startVerification,
	startVerificationWithWrappedNetworking = function(callback, options)
		return Promise.new(function(callback2, callback3)
			callback(v6(), "POST", {
				postBody = HttpService:JSONEncode((Cryo.Dictionary.join(
					{ generatedLink = true },
					options or {}
				)))
			}):catch(function(data)
				local v9

				if type(data) == "table" then
					v9 = data.StatusCode or data.responseCode or data.status or data.statusCode
				end

				if FFlagEnableFeatureRestrictionOnAgeVerificationAttempt and v9 == 403 then
					showFeatureRestriction(abuseVector.AgeVerification, buildAgeVerificationFeatureRestrictionOverrides())
				end

				callback3("Got error on start-verificatin")
			end):andThen(function(list)
				if not (list and list[1]) then
					callback3("Got start-verification HTTP with no valid response")
					return
				end

				local item = list[1]

				if item then
					callback2({
						emailSent = item.emailSent,
						sessionIdentifier = item.sessionIdentifier,
						daysUntilNextVerification = item.daysUntilNextVerification,
						verificationLink = item.verificationLink,
						sessionToken = item.sessionToken
					})
				else
					callback3("Failed to decode HTTP response as JSON for IDV Verification")
				end
			end)
		end)
	end,
	startLivenessVerification = function(p2)
		return startVerification(p2, v7)
	end,
	getVerifiedStatus = function(p2)
		local v8 = fetch
		return Promise.new(function(callback, callback2)
			local expect = v8(v5({ token = p2 }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(string.format("Got verified-status verification HTTP Response: %d", expect.status))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback({
					isPending = expect2.isPending,
					sessionStatus = expect2.sessionStatus,
					sessionErrorCode = expect2.sessionErrorCode,
					isVerified = expect2.isVerified,
					ageEstimationNextStep = expect2.ageEstimationNextStep
				})
			else
				callback2("Failed to decode HTTP response as JSON for get IDV Verification status")
			end
		end)
	end
}
