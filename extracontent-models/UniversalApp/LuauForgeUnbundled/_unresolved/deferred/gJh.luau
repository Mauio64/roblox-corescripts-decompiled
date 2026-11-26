local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

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

local v6 = enumerate("ActionType", v5)

module(v6, v5)

return v6
