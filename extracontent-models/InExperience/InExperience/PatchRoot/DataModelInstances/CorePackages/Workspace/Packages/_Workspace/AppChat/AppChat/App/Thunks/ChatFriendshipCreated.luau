local UserService = game:GetService("UserService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Promise = require(AppChatParent.Promise)
local UserLib = require(AppChatParent.UserLib)
local USER_CAROUSEL_HEAD_SHOT = UserLib.Utils.AvatarThumbnailRequests.USER_CAROUSEL_HEAD_SHOT
local GetConversationMetadata = AppChatNetworking.rodux.GetConversationMetadata
local PreloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local UpdateUsers = UserLib.Thunks.UpdateUsers
local UserModel = UserLib.Models.UserModel
local receiveUsersPresence = UserLib.Utils.receiveUsersPresence
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local function AddNewFriend(p1, s1: string, p2) -- line: 24
	-- upvalues: UserService (copy), UserModel (copy), UpdateUsers (copy), PreloadUsersThumbnail (copy), USER_CAROUSEL_HEAD_SHOT (copy), FFlagAppChatPresenceStoreMigration (copy), NetworkingPresence (copy), receiveUsersPresence (copy), GetConversationMetadata (copy), Promise (copy)
	local v19 = p2 and p2.UserService or UserService
	local ok, result = pcall(function() -- line: 28
		-- upvalues: v19 (copy), s1 (copy)
		return v19:GetUserInfosByUserIdsAsync({ (tonumber(s1)) })[1]
	end)

	if not ok then
		return
	end

	if not result or not result.Username or not result.DisplayName then
		return
	end

	local v22 = UserModel.fromDataTable({
		isFriend = true,
		friendRank = 0,
		id = s1,
		name = result.Username,
		displayName = result.DisplayName,
		hasVerifiedBadge = result.HasVerifiedBadge
	})

	p1:dispatch(UpdateUsers({ v22 }))

	local t1 = { s1 }
	local t2 = { (p1:dispatch(PreloadUsersThumbnail(t1, USER_CAROUSEL_HEAD_SHOT, nil))) }

	if not FFlagAppChatPresenceStoreMigration then
		table.insert(t2, p1:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(t1)):andThen(function(p3) -- line: 66
			-- upvalues: receiveUsersPresence (copy), p1 (copy)
			local userPresences = p3.responseBody.userPresences

			receiveUsersPresence(userPresences, p1)

			return p3
		end):catch(function(p4) -- line: 71
			warn("NetworkingPresence failure in ChatFriendshipCreated, Status: " .. tostring(p4))
		end))
	end

	p1:dispatch(GetConversationMetadata.API())
	Promise.all(t2)
end

return function(s2: string) -- line: 83
	-- upvalues: AddNewFriend (copy)
	return function(p5, p6) -- line: 84
		-- upvalues: AddNewFriend (copy), s2 (copy)
		AddNewFriend(p5, s2, p6)
	end
end
