local CorePackages = game:GetService("CorePackages")
local Requests = require(CorePackages.Workspace.Packages.Http).Requests
local Promise = require(CorePackages.Packages.Promise)
local ApiFetchUsersPresences = require(CorePackages.Workspace.Packages.UserLib).Thunks.ApiFetchUsersPresences
local DEPRECATED_UsersGetFriends = Requests.DEPRECATED_UsersGetFriends
local FetchUserFriendsStarted = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Actions.FetchUserFriendsStarted
local FetchUserFriendsFailed = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Actions.FetchUserFriendsFailed
local FetchUserFriendsCompleted = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Actions.FetchUserFriendsCompleted
local UserModel = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel
local UpdateUsers = require(CorePackages.Workspace.Packages.UserLib).Thunks.UpdateUsers
local GetFFlagInviteListRerank = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagInviteListRerank

return function(p1, p2, _, p4) -- line: 16
	-- upvalues: FetchUserFriendsStarted (copy), DEPRECATED_UsersGetFriends (copy), GetFFlagInviteListRerank (copy), UserModel (copy), UpdateUsers (copy), ApiFetchUsersPresences (copy), FetchUserFriendsCompleted (copy), Promise (copy), FetchUserFriendsFailed (copy)
	return function(p5) -- line: 17
		-- upvalues: FetchUserFriendsStarted (copy), p2 (copy), DEPRECATED_UsersGetFriends (copy), p1 (copy), p4 (copy), GetFFlagInviteListRerank (copy), UserModel (copy), UpdateUsers (copy), ApiFetchUsersPresences (copy), FetchUserFriendsCompleted (copy), Promise (copy), FetchUserFriendsFailed (copy)
		p5:dispatch(FetchUserFriendsStarted(p2))

		return DEPRECATED_UsersGetFriends(p1, p2, p4):andThen(function(p6) -- line: 21
			-- upvalues: GetFFlagInviteListRerank (copy), UserModel (copy), p5 (copy), UpdateUsers (copy)
			local responseBody = p6.responseBody
			local t1 = {}
			local t2 = {}

			for k, v in pairs(responseBody.data) do
				local str = tostring(v.id)

				v.isFriend = true

				if GetFFlagInviteListRerank() then
					v.friendRank = k
				end

				local v24 = UserModel.fromDataTable(v)

				table.insert(t1, str)
				t2[v24.id] = v24
			end

			p5:dispatch(UpdateUsers(t2))

			return t1
		end):andThen(function(p7) -- line: 43
			-- upvalues: p5 (copy), ApiFetchUsersPresences (copy), p1 (copy)
			return p5:dispatch(ApiFetchUsersPresences(p1, p7))
		end):andThen(function(p8) -- line: 46
			-- upvalues: p5 (copy), FetchUserFriendsCompleted (copy), p2 (copy), Promise (copy)
			p5:dispatch(FetchUserFriendsCompleted(p2))

			return Promise.resolve(p8)
		end, function(p9) -- line: 50
			-- upvalues: p5 (copy), FetchUserFriendsFailed (copy), p2 (copy), Promise (copy)
			p5:dispatch(FetchUserFriendsFailed(p2, p9))

			return Promise.reject(p9)
		end)
	end
end
