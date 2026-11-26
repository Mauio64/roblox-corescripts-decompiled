local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/RoactUtils").Hooks.RoactRodux.useSelector

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Common/Constants")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/getDeepValue")

return function()
	return useSelector(function(p2)
		return getDeepValue(p2, `{module.RODUX_KEY}.ProfileShareLinks.shortUrl`)
	end)
end
