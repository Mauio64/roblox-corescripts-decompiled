local FormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/FormFactor")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/RoactUtils").Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p2): boolean
		return p2.FormFactor == FormFactor.Enums.FormFactor.WIDE
	end)
end
