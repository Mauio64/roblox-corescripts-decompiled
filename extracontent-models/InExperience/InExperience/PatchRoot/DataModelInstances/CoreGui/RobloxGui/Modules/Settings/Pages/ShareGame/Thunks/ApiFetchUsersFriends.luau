local CorePackages = game:GetService("CorePackages")

local Http = require(CorePackages.Workspace.Packages.Http)
local Requests = Http.Requests

local Promise = require(CorePackages.Packages.Promise)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local ApiFetchUsersPresences = UserLib.Thunks.ApiFetchUsersPresences
local DEPRECATED_UsersGetFriends = Requests.DEPRECATED_UsersGetFriends
local LegacyFriendsRodux = require(CorePackages.Workspace.Packages.LegacyFriendsRodux)
local FetchUserFriendsStarted = LegacyFriendsRodux.Actions.FetchUserFriendsStarted
local LegacyFriendsRodux2 = require(CorePackages.Workspace.Packages.LegacyFriendsRodux)
local FetchUserFriendsFailed = LegacyFriendsRodux2.Actions.FetchUserFriendsFailed
local LegacyFriendsRodux3 = require(CorePackages.Workspace.Packages.LegacyFriendsRodux)
local FetchUserFriendsCompleted = LegacyFriendsRodux3.Actions.FetchUserFriendsCompleted
local UserLib2 = require(CorePackages.Workspace.Packages.UserLib)
local UserModel = UserLib2.Models.UserModel
local UserLib3 = require(CorePackages.Workspace.Packages.UserLib)
local UpdateUsers = UserLib3.Thunks.UpdateUsers

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagInviteListRerank = SharedFlags.GetFFlagInviteListRerank

return function(p, p2, _, p3)
	return function(object)
		object:dispatch(FetchUserFriendsStarted(p2))

		return DEPRECATED_UsersGetFriends(p, p2, p3):andThen(function(p4)
			local responseBody = p4.responseBody

			local ids = {}
			local v = {}

			for k, v2 in pairs(responseBody.data) do
				local id = tostring(v2.id)
				v2.isFriend = true

				if GetFFlagInviteListRerank() then
					v2.friendRank = k
				end

				local v3 = UserModel.fromDataTable(v2)

				table.insert(ids, id)
				v[v3.id] = v3
			end

			object:dispatch(UpdateUsers(v))

			return ids
		end):andThen(function(p4)
			return object:dispatch(ApiFetchUsersPresences(p, p4))
		end):andThen(function(p4)
			object:dispatch(FetchUserFriendsCompleted(p2))

			return Promise.resolve(p4)
		end, function(p4)
			object:dispatch(FetchUserFriendsFailed(p2, p4))
			return Promise.reject(p4)
		end)
	end
end
