local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local Url = require(AuthCommonParent.Http).Url
local getSingleSignOnUrls = require(AuthCommon.Utils.getSingleSignOnUrls)
local ConsoleAuthRequestWrapper = require(AuthCommonParent.Http).Utils.ConsoleAuthRequestWrapper
local HttpService = game:GetService("HttpService")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local GetFFlagEnableLoginAccountSelector = require(AuthCommonParent.SharedFlags).GetFFlagEnableLoginAccountSelector
local FFlagEnableLuaAccountSwitch = require(AuthCommonParent.SharedFlags).FFlagEnableLuaAccountSwitch
local t1 = {}

function getLoginUrl() -- line: 28
	-- upvalues: Url (copy)
	return string.format("%sv2/login", Url.AUTH_URL)
end
function t1.logByPasskey(p1, p2, p3) -- line: 32
	-- upvalues: HttpService (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	local json = HttpService:JSONEncode({
		ctype = "Passkey",
		cvalue = HttpService:JSONEncode(p2),
		password = p3,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p1(getLoginUrl(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.logByUsername(p4, p5, p6, p7, p8) -- line: 42
	-- upvalues: HttpService (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	local json = HttpService:JSONEncode({
		ctype = "Username",
		cvalue = p5,
		password = p6,
		captchaToken = p7 and p7.captchaToken or nil,
		captchaProvider = p7 and p7.captchaProvider or nil,
		captchaId = p7 and p7.captchaId or nil,
		securityQuestionSessionId = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p8 and p8.sessionId) or nil,
		securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p8 and p8.redemptionToken) or nil,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p4(getLoginUrl(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.logByEmail(p9, p10, p11, p12, p13, p14) -- line: 63
	-- upvalues: HttpService (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	local json = HttpService:JSONEncode({
		ctype = "Email",
		cvalue = p10,
		password = p11,
		captchaToken = p12 and p12.captchaToken or nil,
		captchaProvider = p12 and p12.captchaProvider or nil,
		captchaId = p12 and p12.captchaId or nil,
		securityQuestionSessionId = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p13 and p13.sessionId) or nil,
		securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p13 and p13.redemptionToken) or nil,
		userId = GetFFlagEnableLoginAccountSelector() and p14 or nil,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p9(getLoginUrl(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.logByPhone(p15, p16, p17, p18, p19, p20) -- line: 85
	-- upvalues: HttpService (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	local json = HttpService:JSONEncode({
		ctype = "PhoneNumber",
		cvalue = p16,
		password = p17,
		captchaToken = p18 and p18.captchaToken or nil,
		captchaProvider = p18 and p18.captchaProvider or nil,
		captchaId = p18 and p18.captchaId or nil,
		securityQuestionSessionId = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p19 and p19.sessionId) or nil,
		securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p19 and p19.redemptionToken) or nil,
		userId = GetFFlagEnableLoginAccountSelector() and p20 or nil,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p15(getLoginUrl(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.loginWithCode(p21, p22, p23, p24, p25) -- line: 107
	-- upvalues: HttpService (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	local json = HttpService:JSONEncode({
		ctype = "AuthToken",
		cvalue = p22,
		password = p23,
		captchaToken = p24 and p24.captchaToken or nil,
		captchaProvider = p24 and p24.captchaProvider or nil,
		captchaId = p24 and p24.captchaId or nil,
		securityQuestionSessionId = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p25 and p25.sessionId) or nil,
		securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p25 and p25.redemptionToken) or nil,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p21(getLoginUrl(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.logByOtp(p26, p27, p28, p29, p30) -- line: 128
	-- upvalues: HttpService (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy)
	local json = HttpService:JSONEncode({
		ctype = "EmailOtpSessionToken",
		cvalue = p27,
		password = p28,
		securityQuestionSessionId = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p29 and p29.sessionId) or nil,
		securityQuestionRedemptionToken = GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and (not not p29 and p29.redemptionToken) or nil,
		userId = GetFFlagEnableLoginAccountSelector() and p30 or nil,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil
	})

	return p26(getLoginUrl(), "POST", {
		maxRetryCount = 0,
		postBody = json
	})
end
function t1.singleSignOnLogin(p31) -- line: 147
	-- upvalues: getSingleSignOnUrls (copy), HttpService (copy), ConsoleAuthRequestWrapper (copy), Promise (copy), LoginErrorCodes (copy)
	local v51 = getSingleSignOnUrls()
	local login = v51.login

	if login then
		local v53 = login()
		local v54 = not v51.linkingPlatform and "{}" or HttpService:JSONEncode({
			identityProvider = v51.linkingPlatform
		})

		return ConsoleAuthRequestWrapper(p31, v53, "POST", {
			maxRetryCount = 0,
			postBody = v54
		})
	end

	return Promise.reject({
		errorCode = LoginErrorCodes.ServiceUnavailable
	})
end
function t1.singleSignOnConnectWithCode(p32, p33, p34) -- line: 165
	-- upvalues: getSingleSignOnUrls (copy), HttpService (copy), ConsoleAuthRequestWrapper (copy), Promise (copy), LoginErrorCodes (copy)
	local v58 = getSingleSignOnUrls()
	local connect = v58.connect
	local json = HttpService:JSONEncode({
		ctype = "AuthToken",
		cvalue = p33,
		password = p34,
		accountLinkParameters = if not v58.linkingPlatform then nil else {
			LinkingPlatform = v58.linkingPlatform
		}
	})

	if connect then
		local v61 = connect()

		return ConsoleAuthRequestWrapper(p32, v61, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end

	return Promise.reject({
		errorCode = LoginErrorCodes.ServiceUnavailable
	})
end
function t1.singleSignOnConnectWithCredential(p35, p36, p37, p38) -- line: 194
	-- upvalues: getSingleSignOnUrls (copy), HttpService (copy), ConsoleAuthRequestWrapper (copy), Promise (copy), LoginErrorCodes (copy)
	local v66 = getSingleSignOnUrls()
	local connect = v66.connect
	local json = HttpService:JSONEncode({
		ctype = p38,
		cvalue = p36,
		password = p37,
		accountLinkParameters = if not v66.linkingPlatform then nil else {
			LinkingPlatform = v66.linkingPlatform
		}
	})

	if connect then
		local v69 = connect()

		return ConsoleAuthRequestWrapper(p35, v69, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end

	return Promise.reject({
		errorCode = LoginErrorCodes.ServiceUnavailable
	})
end

return t1
