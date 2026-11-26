local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies

local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoginErrorCodeSSO = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodeSSO")

local FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO")

local set = {
	[LoginErrorCodes.AccountLocked] = true,
	[LoginErrorCodes.EmptyAccountSwitchBlobRequired] = true,
	[LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired] = true
}

local function isXboxPlatform(value): boolean
	return string.find(value or "", "Xbox", 1, true) ~= nil
end

local function withPlatform(p2, p3)
	return {
		p2,
		platform = p3
	}
end

local function xboxErrorMessage(p2, platformAccountName, p3, p4)
	if p2 == LoginErrorCodes.IncorrectCValueOrPassword then
		return p3
	end

	if p2 == LoginErrorCodes.MoreThanOneUsername or p2 == LoginErrorCodes.MultipleUsersPerCredential then
		return "Authentication.Login.Response.MoreThanOneUsername"
	end

	if p2 == LoginErrorCodes.AccountNotVerified then
		return p4
	end

	if p2 == LoginErrorCodes.ServiceUnavailable then
		return "Authentication.Login.Response.ServiceUnavailable"
	end

	if p2 == LoginErrorCodeSSO.FloodedXbox then
		return "Authentication.TwoStepVerification.Response.TooManyAttempts"
	end

	if p2 == LoginErrorCodeSSO.RobloxAccountAlreadyConnectedXbox then
		return {
			"Authentication.Login.Response.AlreadyLinked",
			platform = platformAccountName
		}
	end

	if p2 == LoginErrorCodeSSO.ExternalIdentityAlreadyConnectedXbox then
		return {
			"Authentication.Login.Response.PlatformAlreadyLinked",
			platform = platformAccountName
		}
	end

	if FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO and p2 == LoginErrorCodes.IllegalChildAccountLinking then
		return "Authentication.Login.LinkIllegalChildAccountLinking"
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

local function playstationErrorMessage(p2, p3, p4)
	if p2 == LoginErrorCodeSSO.IncorrectCValueOrPassword then
		return p4
	end

	if p2 == LoginErrorCodeSSO.ExternalIdentityAlreadyConnected then
		return {
			"Authentication.Login.Response.PlatformAlreadyLinked",
			platform = p3
		}
	end

	if p2 == LoginErrorCodeSSO.FloodedPS then
		return "Authentication.TwoStepVerification.Response.TooManyAttempts"
	end

	if p2 == LoginErrorCodeSSO.Require2FA then
		return "Authentication.Login.Response.Require2FAGeneric"
	end

	if p2 == LoginErrorCodeSSO.RelinkingCooldown then
		return {
			"Authentication.Login.Response.RelinkingFreeze",
			platform = p3
		}
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

local function GetLoginByCredentialSsoErrorMessage(p2, p3, p4)
	local platformAccountName = getAppFeaturePolicies().getPlatformAccountName()

	if string.find(platformAccountName or "", "Xbox", 1, true) ~= nil then
		return xboxErrorMessage(p2, platformAccountName, p3, p4)
	end

	if p2 == LoginErrorCodeSSO.IncorrectCValueOrPassword then
		return p3
	end

	if p2 == LoginErrorCodeSSO.ExternalIdentityAlreadyConnected then
		return {
			"Authentication.Login.Response.PlatformAlreadyLinked",
			platform = platformAccountName
		}
	end

	if p2 == LoginErrorCodeSSO.FloodedPS then
		return "Authentication.TwoStepVerification.Response.TooManyAttempts"
	end

	if p2 == LoginErrorCodeSSO.Require2FA then
		return "Authentication.Login.Response.Require2FAGeneric"
	end

	if p2 == LoginErrorCodeSSO.RelinkingCooldown then
		return {
			"Authentication.Login.Response.RelinkingFreeze",
			platform = platformAccountName
		}
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return {
	getMessage = GetLoginByCredentialSsoErrorMessage,
	getUiErrorCode = function(p2)
		local platformAccountName = getAppFeaturePolicies().getPlatformAccountName()

		if string.find(platformAccountName or "", "Xbox", 1, true) ~= nil and set[p2] then
			return p2
		end

		return nil
	end
}
