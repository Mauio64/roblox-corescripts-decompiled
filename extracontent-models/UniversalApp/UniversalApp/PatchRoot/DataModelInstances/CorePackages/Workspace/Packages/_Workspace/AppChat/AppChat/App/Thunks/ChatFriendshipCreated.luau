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

local function AddNewFriend(p1, s1: string, p2) -- line: 23
	-- upvalues: UserService (copy), UserModel (copy), UpdateUsers (copy), PreloadUsersThumbnail (copy), USER_CAROUSEL_HEAD_SHOT (copy), NetworkingPresence (copy), receiveUsersPresence (copy), GetConversationMetadata (copy), Promise (copy)
	local v18 = p2 and p2.UserService or UserService
	local ok, result = pcall(function() -- line: 27
		-- upvalues: v18 (copy), s1 (copy)
		return v18:GetUserInfosByUserIdsAsync({ (tonumber(s1)) })[1]
	end)

	if not ok then
		return
	end

	if not result or not result.Username or not result.DisplayName then
		return
	end

	local v21 = UserModel.fromDataTable({
		isFriend = true,
		friendRank = 0,
		id = s1,
		name = result.Username,
		displayName = result.DisplayName,
		hasVerifiedBadge = result.HasVerifiedBadge
	})

	p1:dispatch(UpdateUsers({ v21 }))

	local t1 = { s1 }
	local v23 = p1:dispatch(PreloadUsersThumbnail(t1, USER_CAROUSEL_HEAD_SHOT, nil))
	local t2 = {
		p1:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(t1)):andThen(function(p3) -- line: 60
			-- upvalues: receiveUsersPresence (copy), p1 (copy)
			local userPresences = p3.responseBody.userPresences

			receiveUsersPresence(userPresences, p1)

			return p3
		end):catch(function(p4) -- line: 65
			warn("NetworkingPresence failure in ChatFriendshipCreated, Status: " .. tostring(p4))
		end),
		v23
	}

	p1:dispatch(GetConversationMetadata.API())
	Promise.all(t2)
end

return function(s2: string) -- line: 77
	-- upvalues: AddNewFriend (copy)
	return function(p5, p6) -- line: 78
		-- upvalues: AddNewFriend (copy), s2 (copy)
		AddNewFriend(p5, s2, p6)
	end
end
