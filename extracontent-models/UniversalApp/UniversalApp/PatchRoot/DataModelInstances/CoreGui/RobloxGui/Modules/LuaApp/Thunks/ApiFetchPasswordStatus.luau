local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetPasswordStatus = require(Modules.LuaApp.Http.Requests.GetPasswordStatus)
local SetPasswordNotificationCount = require(Modules.LuaApp.Actions.SetPasswordNotificationCount)

return function(p1) -- line: 9
	-- upvalues: PerformFetch (copy), GetPasswordStatus (copy), SetPasswordNotificationCount (copy)
	return PerformFetch.Single("luaapp.authapi.passwords-current-status", function(p2) -- line: 10
		-- upvalues: GetPasswordStatus (copy), p1 (copy), SetPasswordNotificationCount (copy)
		return GetPasswordStatus(p1):andThen(function(p3) -- line: 11
			-- upvalues: p2 (copy), SetPasswordNotificationCount (copy)
			local v9 = p3.responseBody.valid ~= false and 0 or 1

			p2:dispatch(SetPasswordNotificationCount(v9))

			return p3
		end)
	end)
end
