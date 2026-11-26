local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")

return function(callback)
	return {
		navigateBackInAppRoute = function()
			callback(RobloxAppToastsRodux())
		end
	}
end
