local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local VideoPlaybackCoordinator = require(CorePackages.Workspace.Packages.VideoUtils).VideoPlaybackCoordinator

return RoactAppPolicy.connect(function(p1, _) -- line: 28
	return {
		throttleFramerate = p1.getThrottleFramerate()
	}
end)(function(t1: {[any]: any}) -- line: 7
	-- upvalues: React (copy), RunService (copy), VideoPlaybackCoordinator (copy)
	React.useEffect(function() -- line: 8
		-- upvalues: t1 (copy), RunService (copy), VideoPlaybackCoordinator (copy)
		if t1.throttleFramerate then
			RunService:setThrottleFramerateEnabled(true)
			VideoPlaybackCoordinator.default:setIsSettingFramerateThrottleAllowedByPolicy(true)
			VideoPlaybackCoordinator.default:setPreferredFramerateThrottling(true)
		end

		return function() -- line: 16
			-- upvalues: t1 (copy), RunService (copy), VideoPlaybackCoordinator (copy)
			if t1.throttleFramerate then
				RunService:setThrottleFramerateEnabled(false)
				VideoPlaybackCoordinator.default:setIsSettingFramerateThrottleAllowedByPolicy(false)
				VideoPlaybackCoordinator.default:setPreferredFramerateThrottling(false)
			end
		end
	end, {})
end)
