local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local SetIsLocalUserSoothsayer = require(Modules.LuaApp.Actions.SetIsLocalUserSoothsayer)
local UsersGetRoles = require(Modules.LuaApp.Http.Requests.UsersGetRoles)

return function(p1) -- line: 10
	-- upvalues: UsersGetRoles (copy), Cryo (copy), SetIsLocalUserSoothsayer (copy)
	return function(p2) -- line: 11
		-- upvalues: UsersGetRoles (copy), p1 (copy), Cryo (copy), SetIsLocalUserSoothsayer (copy)
		return UsersGetRoles(p1):andThen(function(p3) -- line: 12
			-- upvalues: Cryo (copy), p2 (copy), SetIsLocalUserSoothsayer (copy)
			local v9 = p3.responseBody.roles or {}
			local v10 = Cryo.List.find(v9, "Soothsayer") ~= nil

			p2:dispatch(SetIsLocalUserSoothsayer(v10))
		end)
	end
end
