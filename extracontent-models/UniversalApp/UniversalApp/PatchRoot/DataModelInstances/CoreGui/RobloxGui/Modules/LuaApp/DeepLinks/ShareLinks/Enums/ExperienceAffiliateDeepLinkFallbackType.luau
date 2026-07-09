local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {
	EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_INVALID = 0,
	EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_PROFILE = 1,
	EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_HOME = 2
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
