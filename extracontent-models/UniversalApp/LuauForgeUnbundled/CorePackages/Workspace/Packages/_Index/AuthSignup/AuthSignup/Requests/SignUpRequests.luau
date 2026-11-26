local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Promise")

require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http").Url

local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local getSingleSignOnUrls = AuthCommon.Utils.getSingleSignOnUrls
local appStorageUtilities = AuthCommon.Utils.AppStorageUtilities

local consoleAuthRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http").Utils.ConsoleAuthRequestWrapper

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags")
local fFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local fFlagEnableKoreaKISACompliance = SharedFlags.FFlagEnableKoreaKISACompliance
local getFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local getFFlagEnableAuditForSso = SharedFlags.GetFFlagEnableAuditForSso

local SignUpV2ErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Enums/SignUpV2ErrorCodes")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/t")

local v5 = {}

function v5.signUp(callback, value, value2, value3, value4, data)
	assert(type(value) == "string", "invalid username has been passed into SignUpRequests.signUp")
	assert(type(value2) == "string", "invalid password has been passed into SignUpRequests.signUp")
	assert(type(value3) == "string", "invalid birthdate has been passed into SignUpRequests.signUp")
	assert(
		tonumber(value4) and type(value4) == "string",
		"invalid bundleId has been passed into SignUpRequests.signUp"
	)

	local v6 = string.format("%sv3/signup", url.AUTH_URL)

	local v9 = if data then data.captchaId or nil else nil
	local v10 = if data then data.captchaToken or nil else nil
	return callback(v6, "POST", {
		postBody = HttpService:JSONEncode({
			username = value,
			password = value2,
			birthdate = value3,
			bundleId = value4,
			captchaId = v9,
			captchaToken = v10,
			captchaProvider = data and data.captchaProvider or nil,
			accountBlob = fFlagEnableLuaAccountSwitch and appStorageUtilities.getAccountBlob() or nil
		}),
		maxRetryCount = 0
	})
end

local interface = t.interface({
	username = t.string,
	password = t.string,
	gender = t.string,
	birthday = t.string,
	displayName = t.optional(t.string),
	locale = t.optional(t.string),
	email = t.optional(t.string)
})

local interface2 = t.interface({
	username = t.string,
	isExpressSignup = t.literal(true)
})

local union = t.union(interface, interface2)

function v5.signUpV2(callback, data, data2)
	assert(union(data))

	local captchaId = if data2 then data2.captchaId or nil else nil
	local captchaToken = if data2 then data2.captchaToken or nil else nil
	local captchaProvider = data2 and data2.captchaProvider or nil

	local v6 = string.format("%sv2/signup", url.AUTH_URL)

	local v8 = {
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
	local v9 = if fFlagEnableKoreaKISACompliance then data.otpSession else nil
	v8.otpSession = v9
	v8.agreementIds = data.agreementIds
	v8.displayName = data.displayName

	v8.captchaId = captchaId
	v8.captchaToken = captchaToken
	v8.captchaProvider = captchaProvider
	v8.accountBlob = fFlagEnableLuaAccountSwitch and appStorageUtilities.getAccountBlob() or nil
	v8.passkeySessionId = data.passkeySessionId
	v8.passkeyRegistrationResponse = data.passkeyRegistrationResponse
	v8.isExpressSignup = data.isExpressSignup
	v8.auditSystemContent = getFFlagEnableAuditForSinglePageSignUp()
		and data.capturedAuditContent
		and next(data.capturedAuditContent) ~= nil
		and {
			capturedAuditContent = data.capturedAuditContent,
			additionalAuditContent = data.additionalAuditContent
		}
		or nil
	return callback(v6, "POST", {
		postBody = HttpService:JSONEncode(v8),
		maxRetryCount = 0
	})
end

local interface3 = t.interface({
	username = t.string,
	password = t.string,
	gender = t.string,
	birthday = t.string,
	verifiedSignupVoucher = t.string
})

function v5.verifiedSignup(callback, data, data2)
	assert(interface3(data))

	local captchaId = if data2 then data2.captchaId or nil else nil
	local captchaToken = if data2 then data2.captchaToken or nil else nil
	local captchaProvider = data2 and data2.captchaProvider or nil

	return callback(string.format("%sv1/verified-signup", url.AUTH_URL), "POST", {
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
			accountBlob = fFlagEnableLuaAccountSwitch and appStorageUtilities.getAccountBlob() or nil
		}),
		maxRetryCount = 0
	})
end

function v5.singleSignOnSignup(p2, data)
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
		auditSystemContent = getFFlagEnableAuditForSso() and data.capturedAuditContent and next(data.capturedAuditContent) ~= nil and {
			capturedAuditContent = data.capturedAuditContent,
			additionalAuditContent = data.additionalAuditContent
		} or nil
	})

	if not signup then
		return Promise.reject(SignUpV2ErrorCodes.TokenValidationFailed)
	end

	return consoleAuthRequestWrapper(p2, signup(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.expressLinkedSignup(p2, value, p3)
	local singleSignOnUrls = getSingleSignOnUrls()
	local signup = singleSignOnUrls.signup
	local linkingPlatform = singleSignOnUrls.linkingPlatform

	if not signup or linkingPlatform == nil or type(value) ~= "string" then
		return Promise.reject(SignUpV2ErrorCodes.TokenValidationFailed)
	end

	local jsonEncode = HttpService:JSONEncode({
		signupType = "Express",
		locale = value,
		agreementIds = p3,
		accountLinkParameters = { LinkingPlatform = linkingPlatform }
	})

	return consoleAuthRequestWrapper(
		p2,
		signup(),
		"POST",
		{ postBody = jsonEncode, maxRetryCount = 0 },
		true
	)
end

return v5
