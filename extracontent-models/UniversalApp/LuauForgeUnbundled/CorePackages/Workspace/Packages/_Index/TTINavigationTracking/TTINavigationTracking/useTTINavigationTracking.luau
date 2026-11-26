local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TTINavigationTracking/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TTINavigationTracking/RoactNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TTINavigationTracking/Navigation").useNavigation
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TTINavigationTracking/RobloxAppNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/TTINavigationTracking/SharedFlags")
local fFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local fFlagLuaAppNavTTIMeasurementV2 = SharedFlags.FFlagLuaAppNavTTIMeasurementV2

local useOnScreenNavigationListener = if fFlagEnableOnScreenAPIIntegration then RobloxAppNavigation.useOnScreenNavigationListener else nil

local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/TTINavigationTracking/TimeToInteractiveTracker").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone
local hooks = timeToInteractiveTracker.Hooks or nil
local trackMilestone = timeToInteractiveTracker.trackMilestone or nil

local function useTTINavigationTracking(p2)
	hooks.useTTIRenderAndMountedTracking(p2)

	local v5 = useNavigation()

	local function endNavigation()
		if not fFlagLuaAppNavTTIMeasurementV2 then
			timeToInteractiveTracker.trackEnd(p2)

			return
		end

		timeToInteractiveTracker.discardOlderNavigationStarts(p2)
		timeToInteractiveTracker.trackEndAtNextFrame(p2)
	end

	local function onWillFocus()
		local v6 = timeToInteractiveTracker.getEvents(false)[p2]

		if v6 and v6.startTime then
			trackMilestone(p2, milestone.RenderStarted)
		end
	end
	local function onDidFocus()
		local v6 = timeToInteractiveTracker.getEvents(false)[p2]

		if not (v6 and v6.startTime) then
			return
		end

		trackMilestone(p2, milestone.SurfaceMounted)

		if not fFlagLuaAppNavTTIMeasurementV2 then
			timeToInteractiveTracker.trackEnd(p2)

			return
		end

		timeToInteractiveTracker.discardOlderNavigationStarts(p2)
		timeToInteractiveTracker.trackEndAtNextFrame(p2)
	end

	if fFlagEnableOnScreenAPIIntegration then
		useOnScreenNavigationListener(function()
			if v5.isFocused() then
				return
			end

			local v6 = timeToInteractiveTracker.getEvents(false)[p2]

			if v6 and v6.startTime then
				trackMilestone(p2, milestone.RenderStarted)
			end

			local v7 = timeToInteractiveTracker.getEvents(false)[p2]

			if v7 then
				if not v7.startTime then
					return
				end

				trackMilestone(p2, milestone.SurfaceMounted)

				if fFlagLuaAppNavTTIMeasurementV2 then
					timeToInteractiveTracker.discardOlderNavigationStarts(p2)
					timeToInteractiveTracker.trackEndAtNextFrame(p2)
				else
					timeToInteractiveTracker.trackEnd(p2)
				end
			end
		end, nil)
	end

	React.useEffect(function()
		if fFlagLuaAppNavTTIMeasurementV2 then
			timeToInteractiveTracker.discardOlderNavigationStarts(p2)
			timeToInteractiveTracker.trackEndAtNextFrame(p2)
		else
			timeToInteractiveTracker.trackEnd(p2)
		end

		local v6 = v5.addListener(RoactNavigation.Events.WillFocus, onWillFocus)
		local v7 = v5.addListener(RoactNavigation.Events.DidFocus, onDidFocus)
		return function()
			v6.remove()
			v7.remove()
		end
	end, {})
end

return useTTINavigationTracking
