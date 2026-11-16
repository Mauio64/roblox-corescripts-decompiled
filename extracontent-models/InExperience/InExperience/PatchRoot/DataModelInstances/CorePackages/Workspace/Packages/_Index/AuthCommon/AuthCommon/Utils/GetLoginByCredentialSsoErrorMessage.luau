local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginErrorCodeSSO = require(AuthCommon.Enums.LoginErrorCodeSSO)

local FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO = require(AuthCommon.Flags.FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO)

local set = {
	[LoginErrorCodes.AccountLocked] = true,
	[LoginErrorCodes.EmptyAccountSwitchBlobRequired] = true,
	[LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired] = true
}

local function isXboxPlatform(value: string?): boolean -- 2 equivalent calls inferred from this helper
	return string.find(value or "", "Xbox", 1, true) ~= nil
end

local function withPlatform(p: string, platform: string?) -- 4 equivalent calls inferred from this helper
	return {
		p,
		platform = platform
	}
end

local function xboxErrorMessage(p: number, platformAccountName: string?, p2: string, p3: string)
	if p == LoginErrorCodes.IncorrectCValueOrPassword then
		return p2
	end

	if p == LoginErrorCodes.MoreThanOneUsername or p == LoginErrorCodes.MultipleUsersPerCredential then
		return "Authentication.Login.Response.MoreThanOneUsername"
	end

	if p == LoginErrorCodes.AccountNotVerified then
		return p3
	end

	if p == LoginErrorCodes.ServiceUnavailable then
		return "Authentication.Login.Response.ServiceUnavailable"
	end

	if p == LoginErrorCodeSSO.FloodedXbox then
		return "Authentication.TwoStepVerification.Response.TooManyAttempts"
	end

	if p == LoginErrorCodeSSO.RobloxAccountAlreadyConnectedXbox then
		return withPlatform("Authentication.Login.Response.AlreadyLinked", platformAccountName) -- inferred equivalent call
	end

	if p == LoginErrorCodeSSO.ExternalIdentityAlreadyConnectedXbox then
		return withPlatform("Authentication.Login.Response.PlatformAlreadyLinked", platformAccountName) -- inferred equivalent call
	end

	if FFlagEnableIllegalChildAccountLinkingErrorMessageOnSSO and p == LoginErrorCodes.IllegalChildAccountLinking then
		return "Authentication.Login.LinkIllegalChildAccountLinking"
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

local function playstationErrorMessage(p: number, platformAccountName: string?, p2: string) -- 1 equivalent call inferred from this helper
	if p == LoginErrorCodeSSO.IncorrectCValueOrPassword then
		return p2
	end

	if p == LoginErrorCodeSSO.ExternalIdentityAlreadyConnected then
		return withPlatform("Authentication.Login.Response.PlatformAlreadyLinked", platformAccountName) -- inferred equivalent call
	end

	if p == LoginErrorCodeSSO.FloodedPS then
		return "Authentication.TwoStepVerification.Response.TooManyAttempts"
	end

	if p == LoginErrorCodeSSO.Require2FA then
		return "Authentication.Login.Response.Require2FAGeneric"
	end

	if p == LoginErrorCodeSSO.RelinkingCooldown then
		return withPlatform("Authentication.Login.Response.RelinkingFreeze", platformAccountName) -- inferred equivalent call
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

local function GetLoginByCredentialSsoErrorMessage(p: number, p2: string, p3: string)
	local platformAccountName = getAppFeaturePolicies().getPlatformAccountName()

	if isXboxPlatform(platformAccountName) then -- inferred equivalent call
		return (xboxErrorMessage(p, platformAccountName, p2, p3))
	end

	return playstationErrorMessage(p, platformAccountName, p2) -- inferred equivalent call
end

return {
	getMessage = GetLoginByCredentialSsoErrorMessage,
	getUiErrorCode = function(p: number)
		if isXboxPlatform(getAppFeaturePolicies().getPlatformAccountName()) and set[p] then -- inferred equivalent call
			return p
		end

		return nil
	end
}
