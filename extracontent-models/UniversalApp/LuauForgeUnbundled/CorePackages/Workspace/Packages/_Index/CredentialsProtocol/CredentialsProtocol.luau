local module = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/CredentialsProtocol")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/CredentialsProtocolTypes")
return {
	Constants = module2,
	CredentialsProtocol = module,
	CredentialsProtocolErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/CredentialsProtocolErrorCodes"),
	getCredentialsTimeoutSeconds = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/getCredentialsTimeoutSeconds"),
	Flags = {
		FFlagCacheCredentialsProtocolIsAvailable = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/FFlagCacheCredentialsProtocolIsAvailable"),
		GetFFlagLuaAppEnableCredentialsProtocol = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/GetFFlagLuaAppEnableCredentialsProtocol"),
		GetFIntLuaAppCredentialsProtocolTimeout = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/GetFIntLuaAppCredentialsProtocolTimeout"),
		GetFIntLuaAppCredentialsProtocolAvailableTimeout = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/GetFIntLuaAppCredentialsProtocolAvailableTimeout"),
		FFlagLuaAppNormalizeUnifiedPasskeyResponse = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/FFlagLuaAppNormalizeUnifiedPasskeyResponse")
	}
}
