local VRService = game:GetService("VRService")

local module = require("@luauforge/bundled/hWU")
local splashScreenManager = require("@luauforge/bundled/hSy").SplashScreenManager

local intervalPerformanceTracker = require("@luauforge/bundled/fvL").IntervalPerformanceTracker

local vRSessionStateChangedConnection = nil

return function()
	splashScreenManager.initialize(36, 7, 36)

	intervalPerformanceTracker:startTracking("appLaunchToTargetFPS")
	splashScreenManager.addStatusChangeListener(function(p2)
		if p2 then
			intervalPerformanceTracker:stopAndLogTracking("appLaunchToTargetFPS")
		end
	end)

	local v5 = module.new()
	VRService.QuestDisplayRefreshRate = 72

	v5:onLeft(function()
		VRService.QuestDisplayRefreshRate = 72
	end)

	if not vRSessionStateChangedConnection then
		vRSessionStateChangedConnection = VRService:GetPropertyChangedSignal("VRSessionState"):Connect(function()
			VRService.QuestDisplayRefreshRate = 72
		end)
	end
end
