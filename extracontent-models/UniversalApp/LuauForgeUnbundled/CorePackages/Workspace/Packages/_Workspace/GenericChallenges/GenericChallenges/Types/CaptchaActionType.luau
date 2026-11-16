local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/addRawValueMethodToEnum")

local v5 = {
	Login = "Login",
	AppLogin = "AppLogin",
	Signup = "Signup",
	AppSignup = "AppSignup",
	GroupJoin = "GroupJoin",
	GroupWallPost = "GroupWallPost",
	ResetPassword = "ResetPassword",
	ToyCodeRedeem = "ToyCodeRedeem",
	GameCardRedeem = "GameCardRedeem",
	FollowUser = "FollowUser"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/enumerate")("CaptchaActionType", v5)

addRawValueMethodToEnum(v6, v5)

return v6
