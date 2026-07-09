local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetFriendRequestsCount = require(Modules.LuaApp.Http.Requests.GetFriendRequestsCount)
local SetFriendRequestsCount = require(Modules.LuaApp.Actions.SetFriendRequestsCount)

return function(p1) -- line: 9
	-- upvalues: PerformFetch (copy), GetFriendRequestsCount (copy), SetFriendRequestsCount (copy)
	return PerformFetch.Single("luaapp.friendsapi.friend-requests-count", function(p2) -- line: 10
		-- upvalues: GetFriendRequestsCount (copy), p1 (copy), SetFriendRequestsCount (copy)
		return GetFriendRequestsCount(p1):andThen(function(p3) -- line: 11
			-- upvalues: p2 (copy), SetFriendRequestsCount (copy)
			local count = p3.responseBody.count

			p2:dispatch(SetFriendRequestsCount(count))

			return p3
		end)
	end)
end
