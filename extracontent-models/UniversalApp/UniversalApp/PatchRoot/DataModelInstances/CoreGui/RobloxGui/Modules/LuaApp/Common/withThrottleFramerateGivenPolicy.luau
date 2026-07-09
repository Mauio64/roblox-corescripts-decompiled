local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AppRunService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppRunService
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local VideoPlaybackCoordinator = require(CorePackages.Workspace.Packages.VideoUtils).VideoPlaybackCoordinator
local Object = LuauPolyfill.Object
local FFlagLuaAppVideoPlaybackRefCount = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppVideoPlaybackRefCount

return function(p1) -- line: 22
	-- upvalues: React (copy), useRoactService (copy), AppRunService (copy), RunService (copy), RoactAppPolicy (copy), FFlagLuaAppVideoPlaybackRefCount (copy), VideoPlaybackCoordinator (copy), Object (copy)
	return React.forwardRef(function(p2, p3) -- line: 23
		-- upvalues: useRoactService (copy), AppRunService (copy), RunService (copy), React (copy), RoactAppPolicy (copy), FFlagLuaAppVideoPlaybackRefCount (copy), VideoPlaybackCoordinator (copy), p1 (copy), Object (copy)
		local v15 = useRoactService(AppRunService) or RunService
		local v16 = React.useMemo(function() -- line: 27
			-- upvalues: RoactAppPolicy (copy), FFlagLuaAppVideoPlaybackRefCount (copy), VideoPlaybackCoordinator (copy), v15 (copy), p1 (copy)
			return RoactAppPolicy.connect(function(p4) -- line: 28
				-- upvalues: FFlagLuaAppVideoPlaybackRefCount (copy), VideoPlaybackCoordinator (copy), v15 (copy)
				return {
					setThrottleFramerateEnabled = function(p5) -- line: 30
						-- upvalues: p4 (copy), FFlagLuaAppVideoPlaybackRefCount (copy), VideoPlaybackCoordinator (copy), v15 (copy)
						if p4.getThrottleFramerate() then
							if not FFlagLuaAppVideoPlaybackRefCount or not VideoPlaybackCoordinator.isAnyPlaying() then
								v15:setThrottleFramerateEnabled(p5)
							end

							VideoPlaybackCoordinator.default:setPreferredFramerateThrottling(p5)
						end
					end
				}
			end)(p1)
		end, {
			p1,
			v15
		})

		return React.createElement(v16, Object.assign(p2, {
			ref = p3
		}))
	end)
end
