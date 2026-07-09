local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local SetGamePasses = require(Modules.LuaApp.Actions.Games.SetGamePasses)

return function(p1, p2) -- line: 6
	-- upvalues: SetGamePasses (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetGamePasses.name then
		v7 = Cryo.Dictionary.join(v7, {
			[p2.universeId] = p2.passes
		})
	end

	return v7
end
