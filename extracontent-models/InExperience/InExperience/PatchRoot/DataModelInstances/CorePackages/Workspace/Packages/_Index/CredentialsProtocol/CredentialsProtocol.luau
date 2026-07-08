local CredentialsProtocol = require(script.CredentialsProtocol)
local Constants = require(script.Constants)

require(script.CredentialsProtocolTypes)

local CredentialsProtocolErrorCodes = require(script.CredentialsProtocolErrorCodes)
local GetFFlagLuaAppEnableCredentialsProtocol = require(script.Flags.GetFFlagLuaAppEnableCredentialsProtocol)
local GetFIntLuaAppCredentialsProtocolTimeout = require(script.Flags.GetFIntLuaAppCredentialsProtocolTimeout)
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(script.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout)

return {
	Constants = Constants,
	CredentialsProtocol = CredentialsProtocol,
	CredentialsProtocolErrorCodes = CredentialsProtocolErrorCodes,
	Flags = {
		GetFFlagLuaAppEnableCredentialsProtocol = GetFFlagLuaAppEnableCredentialsProtocol,
		GetFIntLuaAppCredentialsProtocolTimeout = GetFIntLuaAppCredentialsProtocolTimeout,
		GetFIntLuaAppCredentialsProtocolAvailableTimeout = GetFIntLuaAppCredentialsProtocolAvailableTimeout
	}
}
