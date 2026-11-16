local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
local getSingleSignOnUrls = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/getSingleSignOnUrls")
local consoleAuthRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Utils.ConsoleAuthRequestWrapper
local HttpService = game:GetService("HttpService")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")

local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")

local getFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin

local getFFlagEnableLoginAccountSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableLoginAccountSelector
local fFlagEnableLuaAccountSwitch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLuaAccountSwitch
local FFlagClearAccountBlobForPioneerLogin = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagClearAccountBlobForPioneerLogin")
local isPioneerLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/PioneerUtils").isPioneerLaunch

local v5 = {}

function LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl()
	return string.format("%sv2/login", url.AUTH_URL)
end

local function getAccountBlobForLogin()
	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	return fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
end

function v5.logByPasskey(callback, p2, p3)
	local v7 = {
		ctype = "Passkey",
		cvalue = HttpService:JSONEncode(p2),
		password = p3,
		accountBlob = 0
	}

	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	v7.accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.logByUsername(callback, p2, p3, data, p4)
	local v8 = if data then data.captchaToken or nil else nil
	local v9 = if data then data.captchaProvider or nil else nil
	local v7 = {
		ctype = "Username",
		cvalue = p2,
		password = p3,
		captchaToken = v8,
		captchaProvider = v9,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		accountBlob = 0
	}
	local v10 = if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p4 then p4.sessionId or nil else nil
	v7.securityQuestionSessionId = v10

	v7.securityQuestionRedemptionToken = getFFlagLuaAppUsingSecurityQuestionsForLuaLogin()
		and p4
		and p4.redemptionToken
		or nil

	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	v7.accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.logByEmail(callback, p2, p3, data, p4, p5)
	local v8 = if data then data.captchaToken or nil else nil
	local v9 = if data then data.captchaProvider or nil else nil
	local v7 = {
		ctype = "Email",
		cvalue = p2,
		password = p3,
		captchaToken = v8,
		captchaProvider = v9,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		userId = 0,
		accountBlob = 0
	}
	local v10 = if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p4 then p4.sessionId or nil else nil
	v7.securityQuestionSessionId = v10

	v7.securityQuestionRedemptionToken = getFFlagLuaAppUsingSecurityQuestionsForLuaLogin()
		and p4
		and p4.redemptionToken
		or nil

	v7.userId = getFFlagEnableLoginAccountSelector() and p5 or nil

	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	v7.accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.logByPhone(callback, p2, p3, data, p4, p5)
	local v8 = if data then data.captchaToken or nil else nil
	local v9 = if data then data.captchaProvider or nil else nil
	local v7 = {
		ctype = "PhoneNumber",
		cvalue = p2,
		password = p3,
		captchaToken = v8,
		captchaProvider = v9,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		userId = 0,
		accountBlob = 0
	}
	local v10 = if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p4 then p4.sessionId or nil else nil
	v7.securityQuestionSessionId = v10

	v7.securityQuestionRedemptionToken = getFFlagLuaAppUsingSecurityQuestionsForLuaLogin()
		and p4
		and p4.redemptionToken
		or nil

	v7.userId = getFFlagEnableLoginAccountSelector() and p5 or nil

	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	v7.accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.loginWithCode(callback, p2, p3, data, p4)
	local v8 = if data then data.captchaToken or nil else nil
	local v9 = if data then data.captchaProvider or nil else nil
	local v7 = {
		ctype = "AuthToken",
		cvalue = p2,
		password = p3,
		captchaToken = v8,
		captchaProvider = v9,
		captchaId = data and data.captchaId or nil,
		securityQuestionSessionId = 0,
		securityQuestionRedemptionToken = 0,
		accountBlob = 0
	}
	local v10 = if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p4 then p4.sessionId or nil else nil
	v7.securityQuestionSessionId = v10

	v7.securityQuestionRedemptionToken = getFFlagLuaAppUsingSecurityQuestionsForLuaLogin()
		and p4
		and p4.redemptionToken
		or nil

	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	v7.accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.logByOtp(callback, p2, p3, p4, p5)
	local v8 = if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p4 then p4.sessionId or nil else nil
	local v7 = {
		ctype = "EmailOtpSessionToken",
		cvalue = p2,
		password = p3,
		securityQuestionSessionId = v8,
		securityQuestionRedemptionToken = getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and p4 and p4.redemptionToken or nil,
		userId = getFFlagEnableLoginAccountSelector() and p5 or nil,
		accountBlob = 0
	}

	if FFlagClearAccountBlobForPioneerLogin and isPioneerLaunch() then
		AppStorageUtilities.setAccountBlob("")
		AppStorageUtilities.flush()
	end

	v7.accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(LUAUFORGE_MODULE_GLOBALS_byp_getLoginUrl(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.singleSignOnLogin(p2)
	local v6 = getSingleSignOnUrls()
	local login = v6.login

	if not login then
		return Promise.reject({ errorCode = LoginErrorCodes.ServiceUnavailable })
	end

	return consoleAuthRequestWrapper(p2, login(), "POST", {
		postBody = not v6.linkingPlatform and "{}" or HttpService:JSONEncode({
			identityProvider = v6.linkingPlatform
		}),
		maxRetryCount = 0
	}, true)
end

function v5.singleSignOnConnectWithCode(p2, p3, p4)
	local v6 = getSingleSignOnUrls()
	local connect = v6.connect
	local jsonEncode = HttpService:JSONEncode({
		ctype = "AuthToken",
		cvalue = p3,
		password = p4,
		accountLinkParameters = v6.linkingPlatform and {
			LinkingPlatform = v6.linkingPlatform
		} or nil
	})

	if not connect then
		return Promise.reject({ errorCode = LoginErrorCodes.ServiceUnavailable })
	end

	return consoleAuthRequestWrapper(p2, connect(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

function v5.singleSignOnConnectWithCredential(p2, p3, p4, p5)
	local v6 = getSingleSignOnUrls()
	local connect = v6.connect
	local jsonEncode = HttpService:JSONEncode({
		ctype = p5,
		cvalue = p3,
		password = p4,
		accountLinkParameters = v6.linkingPlatform and {
			LinkingPlatform = v6.linkingPlatform
		} or nil
	})

	if not connect then
		return Promise.reject({ errorCode = LoginErrorCodes.ServiceUnavailable })
	end

	return consoleAuthRequestWrapper(p2, connect(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0
	})
end

return v5
