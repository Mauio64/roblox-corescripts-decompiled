local IdentityVerification = script:FindFirstAncestor("IdentityVerification")
local parent = IdentityVerification.Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Fetch = require(parent.Fetch)
local Promise = require(parent.Promise)
local fetch = Fetch.fetch
local Response = Fetch.Response

local Cryo = require(parent.Cryo)

local UniversalFeatureRestrictions = require(parent.UniversalFeatureRestrictions)
local showFeatureRestriction = UniversalFeatureRestrictions.showFeatureRestriction
local AbuseVector = UniversalFeatureRestrictions.AbuseVector

local buildAgeVerificationFeatureRestrictionOverrides = require(IdentityVerification.Utils.buildAgeVerificationFeatureRestrictionOverrides)

local FFlagEnableFeatureRestrictionOnAgeVerificationAttempt = require(IdentityVerification.Flags.FFlagEnableFeatureRestrictionOnAgeVerificationAttempt)

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "age-verification-service/v1/persona-id-verification/verified-status",
	query = { token = "{token}" }
})

local v2 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "age-verification-service/v1/persona-id-verification/start-verification"
})

local v3 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "age-verification-service/v1/persona-id-verification/start-liveness-verification"
})()

local function getHttpStatusFromWrappedNetworkingError(data) -- 1 equivalent call inferred from this helper
	if type(data) == "table" then
		return data.StatusCode or data.responseCode or data.status or data.statusCode
	end

	return nil
end

local function maybeShowAgeVerificationFeatureRestriction(p: number?) -- 2 equivalent calls inferred from this helper
	if not FFlagEnableFeatureRestrictionOnAgeVerificationAttempt or p ~= 403 then
		return
	end

	showFeatureRestriction(AbuseVector.AgeVerification, buildAgeVerificationFeatureRestrictionOverrides())
end

local function startVerification(options, p: string?)
	local v4 = p or v2()
	local v5 = v4 ~= v3
	local fetch2 = fetch
	return Promise.new(function(callback, callback2)
		local expect = fetch2(v4, {
			method = "POST",
			body = HttpService:JSONEncode(Cryo.Dictionary.join({ generatedLink = true }, options or {})),
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
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
			if v5 then
				maybeShowAgeVerificationFeatureRestriction(expect.status) -- inferred equivalent call
			end

			callback2(string.format("Got start-verification HTTP Response: %d", expect.status))
		end
	end)
end

local IDVApiProvider = {}
IDVApiProvider.startVerification = startVerification

function IDVApiProvider.startVerificationWithWrappedNetworking(callback, options)
	return Promise.new(function(callback2, callback3)
		callback(v2(), "POST", {
			postBody = HttpService:JSONEncode((Cryo.Dictionary.join({ generatedLink = true }, options or {})))
		}):catch(function(data)
			maybeShowAgeVerificationFeatureRestriction(getHttpStatusFromWrappedNetworkingError(data)) -- inferred equivalent call
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
end

function IDVApiProvider.startLivenessVerification(p)
	return startVerification(p, v3)
end

function IDVApiProvider.getVerifiedStatus(token)
	local fetch2 = fetch
	return Promise.new(function(callback, callback2)
		local expect = fetch2(v({ token = token }), { method = "GET" }):catch(function()
			return Response.error()
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

return IDVApiProvider
