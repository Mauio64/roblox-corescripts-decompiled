local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.RoactRodux.useSelector
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/Constants")

return function()
	return useSelector(function(p2)
		return getDeepValue(p2, Constants.RODUX_KEY .. ".ShareUrl.linkId")
	end)
end
