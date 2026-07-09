local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local getAppFeaturePolicies = require(AuthCommonParent.UniversalAppPolicy).getAppFeaturePolicies
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginErrorCodeSSO = require(AuthCommon.Enums.LoginErrorCodeSSO)
local v6 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnSSO", false)
local v7 = getAppFeaturePolicies().getPlatformAccountName()
local t1 = {
	[LoginErrorCodeSSO.AuthError] = "Authentication.Login.Response.SomethingWentWrong",
	[LoginErrorCodeSSO.ExternalIdentityAlreadyConnected] = {
		"Authentication.Login.Response.AlreadyLinked",
		platform = v7
	},
	[LoginErrorCodeSSO.IncorrectCValueOrPassword] = "Authentication.Login.Response.IncorrectUsernamePassword",
	[LoginErrorCodeSSO.FloodedPS] = "Authentication.TwoStepVerification.Response.TooManyAttempts",
	[LoginErrorCodeSSO.Require2FA] = "Authentication.Login.Response.Require2FAGeneric",
	[LoginErrorCodeSSO.RelinkingCooldown] = {
		"Authentication.Login.Response.RelinkingFreeze",
		platform = v7
	},
	[LoginErrorCodes.IncorrectCValueOrPassword] = "Authentication.Login.Response.IncorrectUsernamePassword",
	[LoginErrorCodeSSO.FloodedXbox] = "Authentication.TwoStepVerification.Response.TooManyAttempts",
	[LoginErrorCodeSSO.RobloxAccountAlreadyConnectedXbox] = {
		"Authentication.Login.Response.AlreadyLinked",
		platform = v7
	},
	[LoginErrorCodeSSO.ExternalIdentityAlreadyConnectedXbox] = {
		"Authentication.Login.Response.AlreadyLinked",
		platform = v7
	}
}

if v6 then
	t1[LoginErrorCodes.IllegalChildAccountLinking] = "Authentication.Login.LinkIllegalChildAccountLinking"
end

local function GetLoginByUsernameErrorMessage(p1) -- line: 44
	-- upvalues: t1 (copy)
	if t1[p1] then
		return t1[p1]
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return GetLoginByUsernameErrorMessage
