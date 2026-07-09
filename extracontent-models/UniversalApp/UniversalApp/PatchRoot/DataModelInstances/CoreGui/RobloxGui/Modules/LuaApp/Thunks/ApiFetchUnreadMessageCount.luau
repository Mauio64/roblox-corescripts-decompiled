local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetUnreadMessagesCount = require(Modules.LuaApp.Http.Requests.GetUnreadMessagesCount)
local SetUnreadMessageCount = require(Modules.LuaApp.Actions.SetUnreadMessageCount)

return function(p1) -- line: 10
	-- upvalues: PerformFetch (copy), GetUnreadMessagesCount (copy), SetUnreadMessageCount (copy)
	return PerformFetch.Single("luaapp.apiProxy.incoming-items-count", function(p2) -- line: 11
		-- upvalues: GetUnreadMessagesCount (copy), p1 (copy), SetUnreadMessageCount (copy)
		return GetUnreadMessagesCount(p1):andThen(function(p3) -- line: 12
			-- upvalues: p2 (copy), SetUnreadMessageCount (copy)
			local count = p3.responseBody.count

			p2:dispatch(SetUnreadMessageCount(count))

			return p3
		end)
	end)
end
