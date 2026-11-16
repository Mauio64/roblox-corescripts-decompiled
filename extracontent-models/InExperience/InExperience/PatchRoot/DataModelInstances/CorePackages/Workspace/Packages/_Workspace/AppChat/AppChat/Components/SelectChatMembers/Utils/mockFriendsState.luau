local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel
local UserLib2 = require(parent.UserLib)
local MockUser = UserLib2.Models.MockUser
local MockUserData = require(AppChat.Users.MockUserData)

local v = MockUser.new()
local _1 = MockUserData.USERS["1"]
v.name = _1.displayName
v.id = _1.id
v.presence = UserModel.PresenceType.ONLINE
v.lastLocation = _1.lastLocation
v.isFriend = true

local v2 = MockUser.new()
local _2 = MockUserData.USERS["2"]
v2.name = _2.displayName
v2.id = _2.id
v2.presence = UserModel.PresenceType.IN_GAME
v2.lastLocation = _2.lastLocation
v2.isFriend = true

local v3 = MockUser.new()
local _3 = MockUserData.USERS["3"]
v3.name = _3.displayName
v3.id = _3.id
v3.isFriend = true

return {
	Users = { v, v2, v3 },
	ChatAppReducer = {
		Presence = {
			byUserId = MockUserData.createMockPresenceData()
		}
	}
}
