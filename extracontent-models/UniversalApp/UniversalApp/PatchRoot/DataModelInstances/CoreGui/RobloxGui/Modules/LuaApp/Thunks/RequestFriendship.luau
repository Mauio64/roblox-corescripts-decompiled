local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local FriendsPostRequestFriendship = require(Modules.LuaApp.Http.Requests.FriendsPostRequestFriendship)
local AddFriendStatus = require(Modules.LuaApp.Actions.AddFriendStatus)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local function RequestFriendship(p1, p2, s1: string?) -- line: 10
	-- upvalues: ArgCheck (copy), PerformFetch (copy), FriendsPostRequestFriendship (copy), AddFriendStatus (copy), SetNetworkingErrorToast (copy), Promise (copy)
	ArgCheck.isType(p2, "string", "Thunks.RequestFriendship.userId")

	return PerformFetch.Single("luaapp.friends.requestfriendship." .. p2, function(p3) -- line: 13
		-- upvalues: s1 (copy), FriendsPostRequestFriendship (copy), p1 (copy), p2 (copy), AddFriendStatus (copy), SetNetworkingErrorToast (copy), Promise (copy)
		local v14 = s1 or "PlayerSearch"

		return (FriendsPostRequestFriendship(p1, p2, v14):andThen(function(p4) -- line: 15
			-- upvalues: p3 (copy), AddFriendStatus (copy), p2 (copy)
			if p4 and (p4.responseBody and p4.responseBody.success == true) then
				p3:dispatch(AddFriendStatus(p2, Enum.FriendStatus.FriendRequestSent))
			end

			return p4
		end, function(p5) -- line: 20
			-- upvalues: p3 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p3:dispatch(SetNetworkingErrorToast(p5))

			return Promise.reject(p5)
		end))
	end)
end

return RequestFriendship
