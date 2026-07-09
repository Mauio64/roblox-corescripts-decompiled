local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LuaApp = CoreGui.RobloxGui.Modules:FindFirstChild("LuaApp")
local ExperienceEventReceiver = require(LuaApp.ExperienceEventReceiver)
local SplashScreenManager = require(CorePackages.Workspace.Packages.SplashScreenManager).SplashScreenManager
local IntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).IntervalPerformanceTracker
local connection = nil

return function() -- line: 24
	-- upvalues: SplashScreenManager (copy), IntervalPerformanceTracker (copy), ExperienceEventReceiver (copy), VRService (copy), connection (ref)
	SplashScreenManager.initialize(36, 7, 36)
	IntervalPerformanceTracker:startTracking("appLaunchToTargetFPS")
	SplashScreenManager.addStatusChangeListener(function(p1) -- line: 31
		-- upvalues: IntervalPerformanceTracker (copy)
		if p1 then
			IntervalPerformanceTracker:stopAndLogTracking("appLaunchToTargetFPS")
		end
	end)

	local v9 = ExperienceEventReceiver.new()

	VRService.QuestDisplayRefreshRate = 72
	v9:onLeft(function() -- line: 47
		-- upvalues: VRService (copy)
		VRService.QuestDisplayRefreshRate = 72
	end)

	if not connection then
		connection = VRService:GetPropertyChangedSignal("VRSessionState"):Connect(function() -- line: 18
			-- upvalues: VRService (copy)
			VRService.QuestDisplayRefreshRate = 72
		end)
	end
end
