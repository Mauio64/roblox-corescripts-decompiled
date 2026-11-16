local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local Utils = GenericChallenges.Utils
local addRawValueMethodToEnum = require(Utils.addRawValueMethodToEnum)
local enumerate = require(parent.enumerate)

local v = {
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

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
