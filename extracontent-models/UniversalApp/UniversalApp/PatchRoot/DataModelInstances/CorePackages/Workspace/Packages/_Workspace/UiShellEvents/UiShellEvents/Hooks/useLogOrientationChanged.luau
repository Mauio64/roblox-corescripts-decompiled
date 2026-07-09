local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local UiShellEventsParent = UiShellEvents.Parent
local React = require(UiShellEventsParent.React)
local useNavigation = require(UiShellEventsParent.Navigation).useNavigation
local useCurrentCamera = require(UiShellEventsParent.RobloxAppHooks).useCurrentCamera
local useDeviceOrientation = require(UiShellEventsParent.RobloxAppHooks).useDeviceOrientation
local getCurrentRouteState = require(UiShellEventsParent.Navigation).getCurrentRouteState

require(UiShellEventsParent.RobloxAppEnums)

local orientationChangedEvent = require(UiShellEvents.Analytics.orientationChangedEvent)
local v9 = game:DefineFastFlag("LogSessionOnOrientationChange", false)
local v10 = if not v9 then nil else game:GetService("SessionService")
local t1 = {
	[Enum.ScreenOrientation.LandscapeLeft] = "LandscapeLeft",
	[Enum.ScreenOrientation.LandscapeRight] = "LandscapeRight",
	[Enum.ScreenOrientation.LandscapeSensor] = "LandscapeSensor",
	[Enum.ScreenOrientation.Portrait] = "Portrait",
	[Enum.ScreenOrientation.Sensor] = "Sensor"
}

local function round(n1: number) -- line: 25
	return (math.floor(n1 or 0.5))
end
local function useLogOrientationChanged(p1, p2, s1: string?) -- line: 29
	-- upvalues: useNavigation (copy), useCurrentCamera (copy), useDeviceOrientation (copy), getCurrentRouteState (copy), t1 (copy), React (copy), v9 (copy), v10 (copy), orientationChangedEvent (copy)
	local v18 = useNavigation()
	local v19 = useCurrentCamera()
	local v20 = useDeviceOrientation()
	local v21 = getCurrentRouteState(v18) or {}
	local v22 = s1 or v21.name
	local v23 = t1[p2]

	React.useEffect(function() -- line: 42
		-- upvalues: v20 (copy), v23 (copy), v9 (copy), v10 (copy), orientationChangedEvent (copy), p1 (copy), v22 (copy), v19 (copy)
		local str = tostring(game.GameId)
		local v25 = str ~= "0" and "experience" or "app"

		if v20 or v23 then
			local SessionID = nil
			local SessionID2 = nil
			local SessionTag = nil
			local SessionTag2 = nil

			if v9 and v10 then
				if v10:SessionExists("level2a") then
					SessionID = v10:GetSessionID("level2a")
					SessionTag = v10:GetSessionTag("level2a")
				end

				if v10:SessionExists("level2b") then
					SessionID2 = v10:GetSessionID("level2b")
					SessionTag2 = v10:GetSessionTag("level2b")
				end
			end

			orientationChangedEvent(p1, v25, {
				deviceOrientation = v20,
				experienceOrientation = v23,
				page = v22,
				viewportX = math.floor(v19.ViewportSize.X or 0.5),
				viewportY = math.floor(v19.ViewportSize.Y or 0.5),
				universeId = str,
				l2a_session_id = SessionID,
				l2b_session_id = SessionID2,
				l2a_session_tag = SessionTag,
				l2b_session_tag = SessionTag2
			})
		end
	end, {
		p1,
		v20,
		v23
	})
end

return useLogOrientationChanged
