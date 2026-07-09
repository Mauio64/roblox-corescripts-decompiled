local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local FriendsPostDeclineFriendRequest = require(Modules.LuaApp.Http.Requests.FriendsPostDeclineFriendRequest)
local AddFriendStatus = require(Modules.LuaApp.Actions.AddFriendStatus)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2) -- line: 10
	-- upvalues: ArgCheck (copy), PerformFetch (copy), FriendsPostDeclineFriendRequest (copy), AddFriendStatus (copy), SetNetworkingErrorToast (copy), Promise (copy)
	ArgCheck.isType(p2, "string", "Thunks.DeclineFriendRequest.userId")

	return PerformFetch.Single("luaapp.friends.declinefriendrequest." .. p2, function(p3) -- line: 13
		-- upvalues: FriendsPostDeclineFriendRequest (copy), p1 (copy), p2 (copy), AddFriendStatus (copy), SetNetworkingErrorToast (copy), Promise (copy)
		return FriendsPostDeclineFriendRequest(p1, p2):andThen(function(_) -- line: 14
			-- upvalues: p3 (copy), AddFriendStatus (copy), p2 (copy)
			p3:dispatch(AddFriendStatus(p2, Enum.FriendStatus.NotFriend))
		end, function(p5) -- line: 16
			-- upvalues: p3 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p3:dispatch(SetNetworkingErrorToast(p5))

			return Promise.reject(p5)
		end)
	end)
end
