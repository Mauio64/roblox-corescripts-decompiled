local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local videoPlaybackCoordinator = require("@luauforge/bundled/fZd").VideoPlaybackCoordinator

return roactAppPolicy.connect(function(p2, p3)
	return { throttleFramerate = p2.getThrottleFramerate() }
end)(function(p2)
	React.useEffect(function()
		if p2.throttleFramerate then
			RunService:setThrottleFramerateEnabled(true)

			videoPlaybackCoordinator.default:setIsSettingFramerateThrottleAllowedByPolicy(true)

			videoPlaybackCoordinator.default:setPreferredFramerateThrottling(true)
		end

		return function()
			if p2.throttleFramerate then
				RunService:setThrottleFramerateEnabled(false)

				videoPlaybackCoordinator.default:setIsSettingFramerateThrottleAllowedByPolicy(false)

				videoPlaybackCoordinator.default:setPreferredFramerateThrottling(false)
			end
		end
	end, {})
end)
