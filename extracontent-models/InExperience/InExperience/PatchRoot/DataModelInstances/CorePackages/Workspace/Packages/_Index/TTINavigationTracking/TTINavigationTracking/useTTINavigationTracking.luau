local parent = script:FindFirstAncestor("TTINavigationTracking").Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local FFlagLuaAppNavTTIMeasurementV2 = SharedFlags.FFlagLuaAppNavTTIMeasurementV2
local useOnScreenNavigationListener

if FFlagEnableOnScreenAPIIntegration then
	useOnScreenNavigationListener = RobloxAppNavigation.useOnScreenNavigationListener
else
	useOnScreenNavigationListener = nil
end

local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local Milestone = timeToInteractiveTracker.Milestone
local hooks = timeToInteractiveTracker.Hooks or nil
local trackMilestone = timeToInteractiveTracker.trackMilestone or nil

local function useTTINavigationTracking(p: string)
	hooks.useTTIRenderAndMountedTracking(p)

	local v = useNavigation()

	local function endNavigation() -- 3 equivalent calls inferred from this helper
		if not FFlagLuaAppNavTTIMeasurementV2 then
			timeToInteractiveTracker.trackEnd(p)

			return
		end

		timeToInteractiveTracker.discardOlderNavigationStarts(p)
		timeToInteractiveTracker.trackEndAtNextFrame(p)
	end

	local function onWillFocus() -- 1 equivalent call inferred from this helper
		local v2 = timeToInteractiveTracker.getEvents(false)[p]

		if v2 and v2.startTime then
			trackMilestone(p, Milestone.RenderStarted)
		end
	end
	local function onDidFocus()
		local v2 = timeToInteractiveTracker.getEvents(false)[p]

		if not (v2 and v2.startTime) then
			return
		end

		trackMilestone(p, Milestone.SurfaceMounted)
		endNavigation() -- inferred equivalent call
	end

	if FFlagEnableOnScreenAPIIntegration then
		useOnScreenNavigationListener(function()
			if v.isFocused() then
				return
			end

			onWillFocus() -- inferred equivalent call
			local v2 = timeToInteractiveTracker.getEvents(false)[p]

			if v2 then
				if not v2.startTime then
					return
				end

				trackMilestone(p, Milestone.SurfaceMounted)
				endNavigation() -- inferred equivalent call
			end
		end, nil)
	end

	React.useEffect(function()
		endNavigation() -- inferred equivalent call
		local v2 = v.addListener(RoactNavigation.Events.WillFocus, onWillFocus)
		local v3 = v.addListener(RoactNavigation.Events.DidFocus, onDidFocus)
		return function()
			v2.remove()
			v3.remove()
		end
	end, {})
end

return useTTINavigationTracking
