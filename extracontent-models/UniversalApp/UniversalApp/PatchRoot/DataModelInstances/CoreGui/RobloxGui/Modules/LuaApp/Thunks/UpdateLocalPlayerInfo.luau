local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local GetUsersAuthenticated = require(Modules.LuaApp.Http.Requests.GetUsersAuthenticated)
local GetLocalUser = require(CorePackages.Workspace.Packages.UserLib).Thunks.GetLocalUser

return function(p1) -- line: 12
	-- upvalues: GetUsersAuthenticated (copy), User (copy), GetLocalUser (copy), Promise (copy), Logging (copy)
	return function(p2) -- line: 13
		-- upvalues: GetUsersAuthenticated (copy), p1 (copy), User (copy), GetLocalUser (copy), Promise (copy), Logging (copy)
		local v10 = p2:getState()
		local v11 = v10.Users[v10.LocalUserId]
		local IsLocalUserUnder13 = v10.IsLocalUserUnder13
		local CountryCode = v10.CountryCode

		return GetUsersAuthenticated(p1):andThen(function(p3) -- line: 19
			-- upvalues: User (copy), v11 (copy), IsLocalUserUnder13 (copy), CountryCode (copy), p2 (copy), GetLocalUser (copy), Promise (copy)
			local v15 = User.new(v11.id, p3.responseBody.name, v11.membership.Value, IsLocalUserUnder13, CountryCode, p3.responseBody.displayName)

			v15:setToLocalPlayer()
			v15:setToLocalStorage()
			p2:dispatch(GetLocalUser())

			return Promise.resolve()
		end, function(p4) -- line: 33
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("Failed to update local user info")

			return Promise.reject(p4)
		end)
	end
end
