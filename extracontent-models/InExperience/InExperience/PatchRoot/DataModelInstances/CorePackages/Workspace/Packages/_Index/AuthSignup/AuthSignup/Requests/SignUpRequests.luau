local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)

require(parent.Http)
local Http = require(parent.Http)
local Url = Http.Url

local AuthCommon = require(parent.AuthCommon)
local getSingleSignOnUrls = AuthCommon.Utils.getSingleSignOnUrls
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities

local Http2 = require(parent.Http)
local ConsoleAuthRequestWrapper = Http2.Utils.ConsoleAuthRequestWrapper

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local FFlagEnableKoreaKISACompliance = SharedFlags.FFlagEnableKoreaKISACompliance
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagEnableAuditForSso = SharedFlags.GetFFlagEnableAuditForSso

local SignUpV2ErrorCodes = require(AuthSignup.Enums.SignUpV2ErrorCodes)

local t = require(parent.t)

local SignUpRequests = {
	["signUp"] = nil,
	["signUp"] = nil,
	["signUp"] = nil,
	["signUp"] = nil,
	signUp = function(callback, username, value, value2, value3, data)
		assert(type(username) == "string", "invalid username has been passed into SignUpRequests.signUp")
		assert(type(value) == "string", "invalid password has been passed into SignUpRequests.signUp")
		assert(type(value2) == "string", "invalid birthdate has been passed into SignUpRequests.signUp")
		assert(
			tonumber(value3) and type(value3) == "string",
			"invalid bundleId has been passed into SignUpRequests.signUp"
		)

		local v = string.format("%sv3/signup", Url.AUTH_URL)
		local captchaId

		if data then
			captchaId = data.captchaId or nil
		end

		local captchaToken

		if data then
			captchaToken = data.captchaToken or nil
		end

		return callback(v, "POST", {
			postBody = HttpService:JSONEncode({
				username = username,
				password = value,
				birthdate = value2,
				bundleId = value3,
				captchaId = captchaId,
				captchaToken = captchaToken,
				captchaProvider = data and data.captchaProvider or nil,
				accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
			}),
			maxRetryCount = 0
		})
	end
}

local interface = t.interface({
	username = t.string,
	password = t.string,
	gender = t.string,
	birthday = t.string,
	displayName = t.optional(t.string),
	locale = t.optional(t.string),
	email = t.optional(t.string)
})

local interface2 = t.interface({ username = t.string, isExpressSignup = t.literal(true) })

local union = t.union(interface, interface2)

function SignUpRequests.signUpV2(callback, data, data2)
	assert(union(data))
	local captchaId

	if data2 then
		captchaId = data2.captchaId or nil
	end

	local captchaToken

	if data2 then
		captchaToken = data2.captchaToken or nil
	end

	local captchaProvider = data2 and data2.captchaProvider or nil

	local v = string.format("%sv2/signup", Url.AUTH_URL)

	local v2 = {
		username = data.username,
		password = data.password,
		gender = data.gender,
		birthday = data.birthday,
		locale = data.locale,
		email = data.email,
		otpSession = 0,
		agreementIds = 0,
		displayName = 0,
		isTosAgreementBoxChecked = true,
		captchaId = 0,
		captchaToken = 0,
		captchaProvider = 0,
		accountBlob = 0,
		passkeySessionId = 0,
		passkeyRegistrationResponse = 0,
		isExpressSignup = 0,
		auditSystemContent = 0
	}
	local otpSession

	if FFlagEnableKoreaKISACompliance then
		otpSession = data.otpSession
	end

	v2.otpSession = otpSession
	v2.agreementIds = data.agreementIds
	v2.displayName = data.displayName

	v2.captchaId = captchaId
	v2.captchaToken = captchaToken
	v2.captchaProvider = captchaProvider
	v2.accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	v2.passkeySessionId = data.passkeySessionId
	v2.passkeyRegistrationResponse = data.passkeyRegistrationResponse
	v2.isExpressSignup = data.isExpressSignup
	v2.auditSystemContent = GetFFlagEnableAuditForSinglePageSignUp()
		and data.capturedAuditContent
		and next(data.capturedAuditContent) ~= nil
		and {
			capturedAuditContent = data.capturedAuditContent,
			additionalAuditContent = data.additionalAuditContent
		}
		or nil
	return callback(v, "POST", { postBody = HttpService:JSONEncode(v2), maxRetryCount = 0 })
end

local interface3 = t.interface({
	username = t.string,
	password = t.string,
	gender = t.string,
	birthday = t.string,
	verifiedSignupVoucher = t.string
})

function SignUpRequests.verifiedSignup(callback, data, data2)
	assert(interface3(data))
	local captchaId

	if data2 then
		captchaId = data2.captchaId or nil
	end

	local captchaToken

	if data2 then
		captchaToken = data2.captchaToken or nil
	end

	local captchaProvider = data2 and data2.captchaProvider or nil

	return callback(string.format("%sv1/verified-signup", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			username = data.username,
			password = data.password,
			gender = data.gender,
			birthday = data.birthday,
			voucher = data.verifiedSignupVoucher,
			agreementIds = data.agreementIds,
			isTosAgreementBoxChecked = true,
			captchaId = captchaId,
			captchaToken = captchaToken,
			captchaProvider = captchaProvider,
			accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
		}),
		maxRetryCount = 0
	})
end

function SignUpRequests.singleSignOnSignup(p, data)
	local singleSignOnUrls = getSingleSignOnUrls()
	local signup = singleSignOnUrls.signup
	local jsonEncode = HttpService:JSONEncode({
		username = data.username,
		password = data.password,
		gender = data.gender,
		birthday = data.birthday,
		locale = data.locale,
		email = data.email,
		agreementIds = data.agreementIds,
		isTosAgreementBoxChecked = true,
		isExpressSignup = data.isExpressSignup,
		accountLinkParameters = singleSignOnUrls.linkingPlatform and {
			LinkingPlatform = singleSignOnUrls.linkingPlatform
		} or nil,
		auditSystemContent = GetFFlagEnableAuditForSso() and data.capturedAuditContent and next(data.capturedAuditContent) ~= nil and {
			capturedAuditContent = data.capturedAuditContent,
			additionalAuditContent = data.additionalAuditContent
		} or nil
	})

	if not signup then
		return Promise.reject(SignUpV2ErrorCodes.TokenValidationFailed)
	end

	return ConsoleAuthRequestWrapper(p, signup(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function SignUpRequests.expressLinkedSignup(p, locale, agreementIds)
	local singleSignOnUrls = getSingleSignOnUrls()
	local signup = singleSignOnUrls.signup
	local linkingPlatform = singleSignOnUrls.linkingPlatform

	if not signup or linkingPlatform == nil or type(locale) ~= "string" then
		return Promise.reject(SignUpV2ErrorCodes.TokenValidationFailed)
	end

	local jsonEncode = HttpService:JSONEncode({
		signupType = "Express",
		locale = locale,
		agreementIds = agreementIds,
		accountLinkParameters = { LinkingPlatform = linkingPlatform }
	})

	return ConsoleAuthRequestWrapper(p, signup(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	}, true)
end

return SignUpRequests
