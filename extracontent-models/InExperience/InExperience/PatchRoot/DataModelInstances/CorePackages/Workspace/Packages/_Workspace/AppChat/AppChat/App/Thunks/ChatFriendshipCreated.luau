local UserService = game:GetService("UserService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Promise = require(parent.Promise)
local UserLib = require(parent.UserLib)

local USER_CAROUSEL_HEAD_SHOT = UserLib.Utils.AvatarThumbnailRequests.USER_CAROUSEL_HEAD_SHOT

local getConversationMetadata = AppChatNetworking.rodux.GetConversationMetadata
local PreloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local UpdateUsers = UserLib.Thunks.UpdateUsers
local UserModel = UserLib.Models.UserModel
local receiveUsersPresence = UserLib.Utils.receiveUsersPresence

local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local function AddNewFriend(object, id: string, p)
	local userService = p and p.UserService or UserService

	local success, result = pcall(function()
		return userService:GetUserInfosByUserIdsAsync({ (tonumber(id)) })[1]
	end)

	if not (success and (result and result.Username and result.DisplayName)) then
		return
	end

	object:dispatch(UpdateUsers({ (UserModel.fromDataTable({
			id = id,
			isFriend = true,
			friendRank = 0,
			name = result.Username,
			displayName = result.DisplayName,
			hasVerifiedBadge = result.HasVerifiedBadge
		})) }))

	local v = { id }

	local v2 = { (object:dispatch(PreloadUsersThumbnail(v, USER_CAROUSEL_HEAD_SHOT, nil))) }

	if not FFlagAppChatPresenceStoreMigration then
		table.insert(v2, object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v)):andThen(function(p2)
			receiveUsersPresence(p2.responseBody.userPresences, object)
			return p2
		end):catch(function(p2)
			warn("NetworkingPresence failure in ChatFriendshipCreated, Status: " .. tostring(p2))
		end))
	end

	object:dispatch(getConversationMetadata.API())

	Promise.all(v2)
end

return function(id: string)
	return function(p, p2)
		AddNewFriend(p, id, p2)
	end
end
