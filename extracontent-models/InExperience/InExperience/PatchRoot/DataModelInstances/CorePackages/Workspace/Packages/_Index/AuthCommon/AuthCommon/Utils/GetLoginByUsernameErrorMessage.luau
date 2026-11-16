local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginErrorCodeSSO = require(AuthCommon.Enums.LoginErrorCodeSSO)

local FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO = require(AuthCommon.Flags.FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO)

local platformAccountName = getAppFeaturePolicies().getPlatformAccountName()

local v = {
	[LoginErrorCodeSSO.AuthError] = "Authentication.Login.Response.SomethingWentWrong",
	[LoginErrorCodeSSO.ExternalIdentityAlreadyConnected] = {
		"Authentication.Login.Response.PlatformAlreadyLinked",
		platform = platformAccountName
	},
	[LoginErrorCodeSSO.IncorrectCValueOrPassword] = "Authentication.Login.Response.IncorrectUsernamePassword",
	[LoginErrorCodeSSO.FloodedPS] = "Authentication.TwoStepVerification.Response.TooManyAttempts",
	[LoginErrorCodeSSO.Require2FA] = "Authentication.Login.Response.Require2FAGeneric",
	[LoginErrorCodeSSO.RelinkingCooldown] = {
		"Authentication.Login.Response.RelinkingFreeze",
		platform = platformAccountName
	},
	[LoginErrorCodes.IncorrectCValueOrPassword] = "Authentication.Login.Response.IncorrectUsernamePassword",
	[LoginErrorCodeSSO.FloodedXbox] = "Authentication.TwoStepVerification.Response.TooManyAttempts",
	[LoginErrorCodeSSO.RobloxAccountAlreadyConnectedXbox] = {
		"Authentication.Login.Response.AlreadyLinked",
		platform = platformAccountName
	},
	[LoginErrorCodeSSO.ExternalIdentityAlreadyConnectedXbox] = {
		"Authentication.Login.Response.PlatformAlreadyLinked",
		platform = platformAccountName
	}
}

if FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO then
	v[LoginErrorCodes.IllegalChildAccountLinking] = "Authentication.Login.LinkIllegalChildAccountLinking"
end

local function GetLoginByUsernameErrorMessage(p)
	if v[p] then
		return v[p]
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return GetLoginByUsernameErrorMessage
