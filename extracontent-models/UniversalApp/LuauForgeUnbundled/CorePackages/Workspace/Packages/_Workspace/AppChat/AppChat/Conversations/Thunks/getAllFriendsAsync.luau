local Players = game:GetService("Players")

local NetworkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingBlocking")
local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingPresence")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")
local addUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Actions.AddUsers
local setUserIsFriend = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Actions.SetUserIsFriend
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Models.UserModel
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").llama
local receiveUsersPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Utils.receiveUsersPresence
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

return function(p2)
	return function(object)
		local localPlayer = Players.LocalPlayer

		assert(localPlayer, "Local Player not found")
		local userId = localPlayer.UserId

		if NetworkingBlocking.GetFriendsFromUserId.getStatus(object:getState(), userId) == RoduxNetworking.Enum.NetworkStatus.Fetching then
			return Promise.resolve({})
		end

		return object:dispatch(NetworkingBlocking.GetFriendsFromUserId.API(userId)):andThen(function(p3)
			local data = p3.responseBody.data
			local users = object:getState().Users or {}

			local ids = p2 and {} or nil
			local v5 = {}

			for i, v6 in ipairs(data) do
				local id = tostring(v6.id)

				if p2 then
					table.insert(ids, id)
				end

				if users[id] == nil then
					v5[id] = userModel.fromDataTable({
						id = v6.id,
						name = v6.name,
						displayName = v6.displayName,
						isFriend = true
					})
				else
					object:dispatch(setUserIsFriend(id, true))
				end
			end

			local keys = llama.Dictionary.keys(v5)

			object:dispatch(addUsers(v5))

			if FFlagAppChatPresenceStoreMigration then
				return p3
			end

			if p2 then
				object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(ids)):andThen(function(p4)
					receiveUsersPresence(p4.responseBody.userPresences, object)
					return p4
				end):catch(function(p4)
					warn("NetworkingPresence failure in getAllFriendsAsync, Status: " .. tostring(p4))
				end)
				return p3
			end

			object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(keys)):catch(function(p4)
				warn("NetworkingPresence failure in getAllFriendsAsync, Status: " .. tostring(p4))
			end)

			return p3
		end):catch(function(p3)
			warn("NetworkingFriends failure in getAllFriendsAsync, Status: " .. tostring(p3))
		end)
	end
end
