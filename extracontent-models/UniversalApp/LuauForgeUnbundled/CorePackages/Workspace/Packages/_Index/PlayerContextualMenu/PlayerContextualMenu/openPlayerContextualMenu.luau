local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/CentralOverlay")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/RobloxAppEnums")

require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components")

return function(p2)
	return function(object)
		object:dispatch(CentralOverlay.Actions.SetCentralOverlay(
			RobloxAppEnums.CentralOverlayType.PlayerContextualMenu,
			p2
		))
	end
end
