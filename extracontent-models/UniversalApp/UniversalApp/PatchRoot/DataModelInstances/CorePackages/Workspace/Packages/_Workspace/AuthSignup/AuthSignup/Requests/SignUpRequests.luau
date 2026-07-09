local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(AuthSignupParent.Promise)

require(AuthSignupParent.Http)

local Url = require(AuthSignupParent.Http).Url
local AuthCommon = require(AuthSignupParent.AuthCommon)
local getSingleSignOnUrls = AuthCommon.Utils.getSingleSignOnUrls
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local ConsoleAuthRequestWrapper = require(AuthSignupParent.Http).Utils.ConsoleAuthRequestWrapper
local SharedFlags = require(AuthSignupParent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local FFlagEnableKoreaKISACompliance = SharedFlags.FFlagEnableKoreaKISACompliance
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagEnableAuditForSso = SharedFlags.GetFFlagEnableAuditForSso
local SignUpV2ErrorCodes = require(AuthSignup.Enums.SignUpV2ErrorCodes)
local t = require(AuthSignupParent.t)
local t1 = {
	signUp = function(p1, p2, p3, p4, p5, p6) -- line: 40
		-- upvalues: Url (copy), HttpService (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
		assert(type(p2) == "string", "invalid username has been passed into SignUpRequests.signUp")
		assert(type(p3) == "string", "invalid password has been passed into SignUpRequests.signUp")
		assert(type(p4) == "string", "invalid birthdate has been passed into SignUpRequests.signUp")
		assert(tonumber(p5) and type(p5) == "string", "invalid bundleId has been passed into SignUpRequests.signUp")

		local v26 = string.format("%sv3/signup", Url.AUTH_URL)
		local json = HttpService:JSONEncode({
			username = p2,
			password = p3,
			birthdate = p4,
			bundleId = p5,
			captchaId = p6 and p6.captchaId or nil,
			captchaToken = p6 and p6.captchaToken or nil,
			captchaProvider = p6 and p6.captchaProvider or nil,
			accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
		})

		return p1(v26, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end
}
local v18 = t.interface({
	username = t.string,
	password = t.string,
	gender = t.string,
	birthday = t.string,
	displayName = t.optional(t.string),
	locale = t.optional(t.string),
	email = t.optional(t.string)
})

function t1.signUpV2(p7, p8, p9) -- line: 114
	-- upvalues: v18 (copy), Url (copy), HttpService (copy), FFlagEnableKoreaKISACompliance (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy), GetFFlagEnableAuditForSinglePageSignUp (copy)
	assert(v18(p8))

	local v31 = p9 and p9.captchaId or nil
	local v32 = p9 and p9.captchaToken or nil
	local v33 = p9 and p9.captchaProvider or nil
	local v34 = string.format("%sv2/signup", Url.AUTH_URL)
	local json = HttpService:JSONEncode({
		isTosAgreementBoxChecked = true,
		username = p8.username,
		password = p8.password,
		gender = p8.gender,
		birthday = p8.birthday,
		locale = p8.locale,
		email = p8.email,
		otpSession = if not FFlagEnableKoreaKISACompliance then nil else p8.otpSession,
		agreementIds = p8.agreementIds,
		displayName = p8.displayName,
		captchaId = v31,
		captchaToken = v32,
		captchaProvider = v33,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil,
		passkeySessionId = p8.passkeySessionId,
		passkeyRegistrationResponse = p8.passkeyRegistrationResponse,
		auditSystemContent = if not GetFFlagEnableAuditForSinglePageSignUp() or (not p8.capturedAuditContent or next(p8.capturedAuditContent) == nil) then nil else {
			capturedAuditContent = p8.capturedAuditContent,
			additionalAuditContent = p8.additionalAuditContent
		}
	})

	return p7(v34, "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end

local v19 = t.interface({
	username = t.string,
	password = t.string,
	gender = t.string,
	birthday = t.string,
	verifiedSignupVoucher = t.string
})

function t1.verifiedSignup(p10, p11, p12) -- line: 161
	-- upvalues: v19 (copy), Url (copy), HttpService (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	assert(v19(p11))

	local v39 = p12 and p12.captchaId or nil
	local v40 = p12 and p12.captchaToken or nil
	local v41 = p12 and p12.captchaProvider or nil
	local v42 = string.format("%sv1/verified-signup", Url.AUTH_URL)
	local json = HttpService:JSONEncode({
		isTosAgreementBoxChecked = true,
		username = p11.username,
		password = p11.password,
		gender = p11.gender,
		birthday = p11.birthday,
		voucher = p11.verifiedSignupVoucher,
		agreementIds = p11.agreementIds,
		captchaId = v39,
		captchaToken = v40,
		captchaProvider = v41,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p10(v42, "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.singleSignOnSignup(p13, p14) -- line: 186
	-- upvalues: getSingleSignOnUrls (copy), GetFFlagEnableAuditForSso (copy), HttpService (copy), ConsoleAuthRequestWrapper (copy), Promise (copy), SignUpV2ErrorCodes (copy)
	local v46 = getSingleSignOnUrls()
	local signup = v46.signup
	local t2 = {
		isTosAgreementBoxChecked = true,
		username = p14.username,
		password = p14.password,
		gender = p14.gender,
		birthday = p14.birthday,
		locale = p14.locale,
		email = p14.email,
		agreementIds = p14.agreementIds,
		accountLinkParameters = if not v46.linkingPlatform then nil else {
			LinkingPlatform = v46.linkingPlatform
		},
		auditSystemContent = if not GetFFlagEnableAuditForSso() or (not p14.capturedAuditContent or next(p14.capturedAuditContent) == nil) then nil else {
			capturedAuditContent = p14.capturedAuditContent,
			additionalAuditContent = p14.additionalAuditContent
		}
	}
	local json = HttpService:JSONEncode(t2)

	if signup then
		local v50 = signup()

		return ConsoleAuthRequestWrapper(p13, v50, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end

	return Promise.reject(SignUpV2ErrorCodes.TokenValidationFailed)
end

return t1
