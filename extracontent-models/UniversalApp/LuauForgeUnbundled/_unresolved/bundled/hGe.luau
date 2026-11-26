local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local appRunService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppRunService
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module = require("@luauforge/bundled/eie")
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local videoPlaybackCoordinator = require("@luauforge/bundled/gDL").VideoPlaybackCoordinator
local object = LuauPolyfill.Object

return function(p2)
	return React.forwardRef(function(p3, p4)
		local v5 = module(appRunService) or RunService

		local v6 = React.useMemo(function()
			return roactAppPolicy.connect(function(p5)
				return {
					setThrottleFramerateEnabled = function(p6)
						if p5.getThrottleFramerate() then
							if not videoPlaybackCoordinator.isAnyPlaying() then
								v5:setThrottleFramerateEnabled(p6)
							end

							videoPlaybackCoordinator.default:setPreferredFramerateThrottling(p6)
						end
					end
				}
			end)(p2)
		end, { p2, v5 })

		return React.createElement(v6, object.assign(p3, { ref = p4 }))
	end)
end
