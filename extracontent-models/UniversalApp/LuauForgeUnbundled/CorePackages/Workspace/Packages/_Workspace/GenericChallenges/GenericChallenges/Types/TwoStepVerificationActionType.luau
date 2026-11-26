local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/addRawValueMethodToEnum")

local v5 = {
	Unknown = "Unknown",
	Login = "Login",
	RobuxSpend = "RobuxSpend",
	ItemTrade = "ItemTrade",
	PasswordReset = "PasswordReset"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/enumerate")("TwoStepVerificationActionType", v5)

addRawValueMethodToEnum(v6, v5)

return v6
