local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local getSingleSignOnUrls = require(AuthCommon.Utils.getSingleSignOnUrls)
local Http2 = require(parent.Http)
local ConsoleAuthRequestWrapper = Http2.Utils.ConsoleAuthRequestWrapper
local HttpService = game:GetService("HttpService")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = SharedFlags.GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableLoginAccountSelector = SharedFlags2.GetFFlagEnableLoginAccountSelector
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags3.FFlagEnableLuaAccountSwitch
local FFlagClearAccountBlobForPioneerLogin = require(AuthCommon.Flags.FFlagClearAccountBlobForPioneerLogin)
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local LoginRequests = {}

function getLoginUrl()
	return string.format("%sv2/login", Url.AUTH_URL)
end

local function getAccountBlobForLogin() -- 6 equivalent calls inferred from this helper
	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	return FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
end

function LoginRequests.logByPasskey(callback, p, password)
	local jsonEncode = HttpService:JSONEncode({
		ctype = "Passkey",
		cvalue = HttpService:JSONEncode(p),
		password = password,
		accountBlob = getAccountBlobForLogin() -- inferred equivalent call
	})

	return callback(getLoginUrl(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

function LoginRequests.logByUsername(callback, cvalue, password, data, p)
	local captchaToken

	if data then
		captchaToken = data.captchaToken or nil
	end

	local captchaProvider

	if data then
		captchaProvider = data.captchaProvider or nil
	end

	local v = {
		ctype = "Username",
		cvalue = cvalue,
		password = password,
		captchaToken = captchaToken,
		captchaProvider = captchaProvider,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		accountBlob = 0
	}
	local securityQuestionSessionId

	if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p then
		securityQuestionSessionId = p.sessionId or nil
	end

	v.securityQuestionSessionId = securityQuestionSessionId

	v.securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p and p.redemptionToken
		or nil

	v.accountBlob = getAccountBlobForLogin() -- inferred equivalent call
	local jsonEncode = HttpService:JSONEncode(v)

	return callback(getLoginUrl(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

function LoginRequests.logByEmail(callback, cvalue, password, data, p, p2)
	local captchaToken

	if data then
		captchaToken = data.captchaToken or nil
	end

	local captchaProvider

	if data then
		captchaProvider = data.captchaProvider or nil
	end

	local v = {
		ctype = "Email",
		cvalue = cvalue,
		password = password,
		captchaToken = captchaToken,
		captchaProvider = captchaProvider,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		userId = 0,
		accountBlob = 0
	}
	local securityQuestionSessionId

	if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p then
		securityQuestionSessionId = p.sessionId or nil
	end

	v.securityQuestionSessionId = securityQuestionSessionId

	v.securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p and p.redemptionToken
		or nil

	v.userId = GetFFlagEnableLoginAccountSelector() and p2 or nil
	v.accountBlob = getAccountBlobForLogin() -- inferred equivalent call
	local jsonEncode = HttpService:JSONEncode(v)

	return callback(getLoginUrl(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

function LoginRequests.logByPhone(callback, cvalue, password, data, p, p2)
	local captchaToken

	if data then
		captchaToken = data.captchaToken or nil
	end

	local captchaProvider

	if data then
		captchaProvider = data.captchaProvider or nil
	end

	local v = {
		ctype = "PhoneNumber",
		cvalue = cvalue,
		password = password,
		captchaToken = captchaToken,
		captchaProvider = captchaProvider,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		userId = 0,
		accountBlob = 0
	}
	local securityQuestionSessionId

	if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p then
		securityQuestionSessionId = p.sessionId or nil
	end

	v.securityQuestionSessionId = securityQuestionSessionId

	v.securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p and p.redemptionToken
		or nil

	v.userId = GetFFlagEnableLoginAccountSelector() and p2 or nil
	v.accountBlob = getAccountBlobForLogin() -- inferred equivalent call
	local jsonEncode = HttpService:JSONEncode(v)

	return callback(getLoginUrl(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

function LoginRequests.loginWithCode(callback, cvalue, password, data, p)
	local captchaToken

	if data then
		captchaToken = data.captchaToken or nil
	end

	local captchaProvider

	if data then
		captchaProvider = data.captchaProvider or nil
	end

	local v = {
		ctype = "AuthToken",
		cvalue = cvalue,
		password = password,
		captchaToken = captchaToken,
		captchaProvider = captchaProvider,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		accountBlob = 0
	}
	local securityQuestionSessionId

	if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p then
		securityQuestionSessionId = p.sessionId or nil
	end

	v.securityQuestionSessionId = securityQuestionSessionId

	v.securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p and p.redemptionToken
		or nil

	v.accountBlob = getAccountBlobForLogin() -- inferred equivalent call
	local jsonEncode = HttpService:JSONEncode(v)

	return callback(getLoginUrl(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

function LoginRequests.logByOtp(callback, cvalue, password, p, p2)
	local securityQuestionSessionId

	if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p then
		securityQuestionSessionId = p.sessionId or nil
	end

	local jsonEncode = HttpService:JSONEncode({
		ctype = "EmailOtpSessionToken",
		cvalue = cvalue,
		password = password,
		securityQuestionSessionId = securityQuestionSessionId,
		securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p and p.redemptionToken or nil,
		userId = GetFFlagEnableLoginAccountSelector() and p2 or nil,
		accountBlob = getAccountBlobForLogin() -- inferred equivalent call
	})

	return callback(getLoginUrl(), "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

function LoginRequests.singleSignOnLogin(p)
	local singleSignOnUrls = getSingleSignOnUrls()
	local login = singleSignOnUrls.login

	if not login then
		return Promise.reject({ errorCode = LoginErrorCodes.ServiceUnavailable })
	end

	return ConsoleAuthRequestWrapper(p, login(), "POST", {
		postBody = not singleSignOnUrls.linkingPlatform and "{}" or HttpService:JSONEncode({
			identityProvider = singleSignOnUrls.linkingPlatform
		}),
		maxRetryCount = 0
	}, true)
end

function LoginRequests.singleSignOnConnectWithCode(p, cvalue, password)
	local singleSignOnUrls = getSingleSignOnUrls()
	local connect = singleSignOnUrls.connect
	local jsonEncode = HttpService:JSONEncode({
		ctype = "AuthToken",
		cvalue = cvalue,
		password = password,
		accountLinkParameters = singleSignOnUrls.linkingPlatform and {
			LinkingPlatform = singleSignOnUrls.linkingPlatform
		} or nil
	})

	if not connect then
		return Promise.reject({ errorCode = LoginErrorCodes.ServiceUnavailable })
	end

	return ConsoleAuthRequestWrapper(p, connect(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function LoginRequests.singleSignOnConnectWithCredential(p, cvalue, password, ctype)
	local singleSignOnUrls = getSingleSignOnUrls()
	local connect = singleSignOnUrls.connect
	local jsonEncode = HttpService:JSONEncode({
		ctype = ctype,
		cvalue = cvalue,
		password = password,
		accountLinkParameters = singleSignOnUrls.linkingPlatform and {
			LinkingPlatform = singleSignOnUrls.linkingPlatform
		} or nil
	})

	if not connect then
		return Promise.reject({ errorCode = LoginErrorCodes.ServiceUnavailable })
	end

	return ConsoleAuthRequestWrapper(p, connect(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

return LoginRequests
