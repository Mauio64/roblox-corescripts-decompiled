local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {
	Unknown = "Unknown",
	Login = "Login",
	RobuxSpend = "RobuxSpend",
	ItemTrade = "ItemTrade"
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
