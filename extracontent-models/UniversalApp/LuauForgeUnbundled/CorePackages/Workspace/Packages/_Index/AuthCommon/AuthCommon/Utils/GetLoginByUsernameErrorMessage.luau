local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies

local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoginErrorCodeSSO = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodeSSO")

local FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO")

local platformAccountName = getAppFeaturePolicies().getPlatformAccountName()

local v5 = {
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
	v5[LoginErrorCodes.IllegalChildAccountLinking] = "Authentication.Login.LinkIllegalChildAccountLinking"
end

local function GetLoginByUsernameErrorMessage(p2)
	if v5[p2] then
		return v5[p2]
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return GetLoginByUsernameErrorMessage
