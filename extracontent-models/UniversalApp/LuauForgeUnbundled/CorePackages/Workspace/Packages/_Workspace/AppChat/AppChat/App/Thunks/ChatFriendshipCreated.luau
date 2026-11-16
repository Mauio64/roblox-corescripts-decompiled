local UserService = game:GetService("UserService")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib")

local USER_CAROUSEL_HEAD_SHOT = UserLib.Utils.AvatarThumbnailRequests.USER_CAROUSEL_HEAD_SHOT

local getConversationMetadata = AppChatNetworking.rodux.GetConversationMetadata
local preloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local updateUsers = UserLib.Thunks.UpdateUsers
local userModel = UserLib.Models.UserModel
local receiveUsersPresence = UserLib.Utils.receiveUsersPresence

local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingPresence")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local function AddNewFriend(object, p2, p3)
	local userService = p3 and p3.UserService or UserService

	local success, result = pcall(function()
		return userService:GetUserInfosByUserIdsAsync({ (tonumber(p2)) })[1]
	end)

	if not (success and (result and result.Username and result.DisplayName)) then
		return
	end

	object:dispatch(updateUsers({ (userModel.fromDataTable({
			id = p2,
			isFriend = true,
			friendRank = 0,
			name = result.Username,
			displayName = result.DisplayName,
			hasVerifiedBadge = result.HasVerifiedBadge
		})) }))

	local v6 = { p2 }

	local v7 = { (object:dispatch(preloadUsersThumbnail(v6, USER_CAROUSEL_HEAD_SHOT, nil))) }

	if not FFlagAppChatPresenceStoreMigration then
		table.insert(v7, object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v6)):andThen(function(p4)
			receiveUsersPresence(p4.responseBody.userPresences, object)
			return p4
		end):catch(function(p4)
			warn("NetworkingPresence failure in ChatFriendshipCreated, Status: " .. tostring(p4))
		end))
	end

	object:dispatch(getConversationMetadata.API())

	Promise.all(v7)
end

return function(p2)
	return function(p3, p4)
		AddNewFriend(p3, p2, p4)
	end
end
