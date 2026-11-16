local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local Promise = require(parent.Promise)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local UserLib = require(parent.UserLib)
local AddUsers = UserLib.Actions.AddUsers
local UserLib2 = require(parent.UserLib)
local SetUserIsFriend = UserLib2.Actions.SetUserIsFriend
local UserLib3 = require(parent.UserLib)
local UserModel = UserLib3.Models.UserModel
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local UserLib4 = require(parent.UserLib)
local receiveUsersPresence = UserLib4.Utils.receiveUsersPresence
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

return function(flag: boolean?)
	return function(object)
		local localPlayer = Players.LocalPlayer

		assert(localPlayer, "Local Player not found")
		local userId = localPlayer.UserId

		if NetworkingFriends.GetFriendsFromUserId.getStatus(object:getState(), userId) == RoduxNetworking.Enum.NetworkStatus.Fetching then
			return Promise.resolve({})
		end

		return object:dispatch(NetworkingFriends.GetFriendsFromUserId.API(userId)):andThen(function(p)
			local data = p.responseBody.data
			local users = object:getState().Users or {}

			local ids = flag and {} or nil
			local v = {}

			for _, v2 in ipairs(data) do
				local id = tostring(v2.id)

				if flag then
					table.insert(ids, id)
				end

				if users[id] == nil then
					v[id] = UserModel.fromDataTable({
						id = v2.id,
						name = v2.name,
						displayName = v2.displayName,
						isFriend = true
					})
				else
					object:dispatch(SetUserIsFriend(id, true))
				end
			end

			local keys = llama.Dictionary.keys(v)

			object:dispatch(AddUsers(v))

			if FFlagAppChatPresenceStoreMigration then
				return p
			end

			if flag then
				object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(ids)):andThen(function(p2)
					receiveUsersPresence(p2.responseBody.userPresences, object)
					return p2
				end):catch(function(p2)
					warn("NetworkingPresence failure in getAllFriendsAsync, Status: " .. tostring(p2))
				end)
				return p
			end

			object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(keys)):catch(function(p2)
				warn("NetworkingPresence failure in getAllFriendsAsync, Status: " .. tostring(p2))
			end)

			return p
		end):catch(function(p)
			warn("NetworkingFriends failure in getAllFriendsAsync, Status: " .. tostring(p))
		end)
	end
end
