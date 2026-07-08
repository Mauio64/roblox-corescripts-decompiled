local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local UserModel = require(AppChatParent.UserLib).Models.UserModel
local MockUser = require(AppChatParent.UserLib).Models.MockUser
local MockUserData = require(AppChat.Users.MockUserData)
local v6 = MockUser.new()
local v7 = MockUserData.USERS["1"]

v6.name = v7.displayName
v6.id = v7.id
v6.presence = UserModel.PresenceType.ONLINE
v6.lastLocation = v7.lastLocation
v6.isFriend = true

local v8 = MockUser.new()
local v9 = MockUserData.USERS["2"]

v8.name = v9.displayName
v8.id = v9.id
v8.presence = UserModel.PresenceType.IN_GAME
v8.lastLocation = v9.lastLocation
v8.isFriend = true

local v10 = MockUser.new()
local v11 = MockUserData.USERS["3"]

v10.name = v11.displayName
v10.id = v11.id
v10.isFriend = true

return {
	Users = {
		[1] = v6,
		[2] = v8,
		[3] = v10
	},
	ChatAppReducer = {
		Presence = {
			byUserId = MockUserData.createMockPresenceData()
		}
	}
}
