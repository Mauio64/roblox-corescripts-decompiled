local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local joinGame = require(Modules.LuaApp.Util.joinGame)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

require(CorePackages.Workspace.Packages.PlayerContextualMenu)

return function(p1) -- line: 11
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy), Cryo (copy), joinGame (copy)
	return function(p2) -- line: 12
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), Cryo (copy), joinGame (copy), p1 (copy)
		p2:dispatch(SetCentralOverlay(OverlayType.PlayerContextualMenu, Cryo.Dictionary.join({
			joinExperience = function(p3, p4) -- line: 16
				-- upvalues: joinGame (copy)
				joinGame:ByUser({
					id = p3
				}, p4)
			end
		}, p1)))
	end
end
