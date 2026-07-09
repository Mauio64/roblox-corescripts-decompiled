local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local SetGamePrivateServersEnabled = require(Modules.LuaApp.Actions.Games.SetGamePrivateServersEnabled)

return function(p1, p2) -- line: 6
	-- upvalues: SetGamePrivateServersEnabled (copy), Dash (copy)
	local v7 = p1 or {}

	if p2.type == SetGamePrivateServersEnabled.name then
		v7 = Dash.assign(v7, {
			[p2.universeId] = p2.privateServersEnabled
		})
	end

	return v7
end
