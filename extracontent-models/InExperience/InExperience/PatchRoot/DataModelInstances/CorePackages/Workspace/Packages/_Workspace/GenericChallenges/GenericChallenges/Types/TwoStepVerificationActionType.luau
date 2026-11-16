local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local Utils = GenericChallenges.Utils
local addRawValueMethodToEnum = require(Utils.addRawValueMethodToEnum)
local enumerate = require(parent.enumerate)

local v = {
	Unknown = "Unknown",
	Login = "Login",
	RobuxSpend = "RobuxSpend",
	ItemTrade = "ItemTrade",
	PasswordReset = "PasswordReset"
}

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
