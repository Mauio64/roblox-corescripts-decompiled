local CredentialsProtocol = require(script.CredentialsProtocol)
local Constants = require(script.Constants)
require(script.CredentialsProtocolTypes)
local CredentialsProtocolErrorCodes = require(script.CredentialsProtocolErrorCodes)
local getCredentialsTimeoutSeconds = require(script.getCredentialsTimeoutSeconds)

local FFlagCacheCredentialsProtocolIsAvailable = require(script.Flags.FFlagCacheCredentialsProtocolIsAvailable)
local GetFFlagLuaAppEnableCredentialsProtocol = require(script.Flags.GetFFlagLuaAppEnableCredentialsProtocol)
local GetFIntLuaAppCredentialsProtocolTimeout = require(script.Flags.GetFIntLuaAppCredentialsProtocolTimeout)

local GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(script.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout)
local FFlagLuaAppNormalizeUnifiedPasskeyResponse = require(script.Flags.FFlagLuaAppNormalizeUnifiedPasskeyResponse)

return {
	Constants = Constants,
	CredentialsProtocol = CredentialsProtocol,
	CredentialsProtocolErrorCodes = CredentialsProtocolErrorCodes,
	getCredentialsTimeoutSeconds = getCredentialsTimeoutSeconds,
	["jest.config"] = script["jest.config"],
	Flags = {
		FFlagCacheCredentialsProtocolIsAvailable = FFlagCacheCredentialsProtocolIsAvailable,
		GetFFlagLuaAppEnableCredentialsProtocol = GetFFlagLuaAppEnableCredentialsProtocol,
		GetFIntLuaAppCredentialsProtocolTimeout = GetFIntLuaAppCredentialsProtocolTimeout,
		GetFIntLuaAppCredentialsProtocolAvailableTimeout = GetFIntLuaAppCredentialsProtocolAvailableTimeout,
		FFlagLuaAppNormalizeUnifiedPasskeyResponse = FFlagLuaAppNormalizeUnifiedPasskeyResponse
	}
}
