local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetAccountSettingsEmail = require(Modules.LuaApp.Http.Requests.GetAccountSettingsEmail)
local SetEmailNotificationCount = require(Modules.LuaApp.Actions.SetEmailNotificationCount)

return function(p1) -- line: 9
	-- upvalues: PerformFetch (copy), GetAccountSettingsEmail (copy), SetEmailNotificationCount (copy)
	return PerformFetch.Single("luaapp.accountsettingsapi.email", function(p2) -- line: 10
		-- upvalues: GetAccountSettingsEmail (copy), p1 (copy), SetEmailNotificationCount (copy)
		return GetAccountSettingsEmail(p1):andThen(function(p3) -- line: 11
			-- upvalues: p2 (copy), SetEmailNotificationCount (copy)
			local v9 = p3.responseBody.verified ~= false and 0 or 1

			p2:dispatch(SetEmailNotificationCount(v9))

			return p3
		end)
	end)
end
