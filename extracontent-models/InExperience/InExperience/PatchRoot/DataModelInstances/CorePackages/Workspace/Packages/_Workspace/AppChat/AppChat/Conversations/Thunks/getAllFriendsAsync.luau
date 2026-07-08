local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local Promise = require(AppChatParent.Promise)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local AddUsers = require(AppChatParent.UserLib).Actions.AddUsers
local SetUserIsFriend = require(AppChatParent.UserLib).Actions.SetUserIsFriend
local UserModel = require(AppChatParent.UserLib).Models.UserModel
local llama = require(AppChatParent.LuaSocialLibrariesDeps).llama
local receiveUsersPresence = require(AppChatParent.UserLib).Utils.receiveUsersPresence

return function(b1: boolean?) -- line: 16
	-- upvalues: Players (copy), NetworkingFriends (copy), RoduxNetworking (copy), Promise (copy), UserModel (copy), SetUserIsFriend (copy), llama (copy), AddUsers (copy), NetworkingPresence (copy), receiveUsersPresence (copy)
	return function(p1) -- line: 17
		-- upvalues: Players (copy), NetworkingFriends (copy), RoduxNetworking (copy), Promise (copy), b1 (copy), UserModel (copy), SetUserIsFriend (copy), llama (copy), AddUsers (copy), NetworkingPresence (copy), receiveUsersPresence (copy)
		local LocalPlayer = Players.LocalPlayer

		assert(LocalPlayer, "Local Player not found")

		local UserId = LocalPlayer.UserId

		if NetworkingFriends.GetFriendsFromUserId.getStatus(p1:getState(), UserId) == RoduxNetworking.Enum.NetworkStatus.Fetching then
			return Promise.resolve({})
		end

		return p1:dispatch(NetworkingFriends.GetFriendsFromUserId.API(UserId)):andThen(function(p2) -- line: 30
			-- upvalues: p1 (copy), b1 (copy), UserModel (copy), SetUserIsFriend (copy), llama (copy), AddUsers (copy), NetworkingPresence (copy), receiveUsersPresence (copy)
			local data = p2.responseBody.data
			local v19 = p1:getState().Users or {}
			local t1 = {}
			local t2 = nil

			if b1 then
				t2 = {}
			end

			for _, v in ipairs(data) do
				local str = tostring(v.id)

				if b1 then
					table.insert(t2, str)
				end

				if v19[str] == nil then
					t1[str] = UserModel.fromDataTable({
						isFriend = true,
						id = v.id,
						name = v.name,
						displayName = v.displayName
					})
				else
					p1:dispatch(SetUserIsFriend(str, true))
				end
			end

			local v25 = llama.Dictionary.keys(t1)

			p1:dispatch(AddUsers(t1))

			if b1 then
				p1:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(t2)):andThen(function(p3) -- line: 67
					-- upvalues: receiveUsersPresence (copy), p1 (copy)
					local userPresences = p3.responseBody.userPresences

					receiveUsersPresence(userPresences, p1)

					return p3
				end):catch(function(p4) -- line: 72
					warn("NetworkingPresence failure in getAllFriendsAsync, Status: " .. tostring(p4))
				end)

				return p2
			end

			p1:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v25)):catch(function(p5) -- line: 78
				warn("NetworkingPresence failure in getAllFriendsAsync, Status: " .. tostring(p5))
			end)

			return p2
		end):catch(function(p6) -- line: 85
			warn("NetworkingFriends failure in getAllFriendsAsync, Status: " .. tostring(p6))
		end)
	end
end
