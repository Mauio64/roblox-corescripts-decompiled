local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local parent = UiShellEvents.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useCurrentCamera = RobloxAppHooks.useCurrentCamera
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useDeviceOrientation = RobloxAppHooks2.useDeviceOrientation
local Navigation2 = require(parent.Navigation)
local getCurrentRouteState = Navigation2.getCurrentRouteState
require(parent.RobloxAppEnums)
local orientationChangedEvent = require(UiShellEvents.Analytics.orientationChangedEvent)

local defineFastFlag = game:DefineFastFlag("LogSessionOnOrientationChange", false)
local SessionService

if defineFastFlag then
	SessionService = game:GetService("SessionService")
else
	SessionService = nil
end

local v = {
	[Enum.ScreenOrientation.LandscapeLeft] = "LandscapeLeft",
	[Enum.ScreenOrientation.LandscapeRight] = "LandscapeRight",
	[Enum.ScreenOrientation.LandscapeSensor] = "LandscapeSensor",
	[Enum.ScreenOrientation.Portrait] = "Portrait",
	[Enum.ScreenOrientation.Sensor] = "Sensor"
}

local function round(value: number) -- 2 equivalent calls inferred from this helper
	return (math.floor(value or 0.5))
end

local function useLogOrientationChanged(p, p2, p3: string?)
	local v2 = useNavigation()
	local v3 = useCurrentCamera()
	local deviceOrientation = useDeviceOrientation()

	local v4 = getCurrentRouteState(v2) or {}
	local page = p3 or v4.name
	local experienceOrientation = v[p2]

	React.useEffect(function()
		local gameId = tostring(game.GameId)
		local v5 = gameId == "0" and "app" or "experience"

		if deviceOrientation or experienceOrientation then
			local sessionID = nil
			local sessionID2 = nil
			local sessionTag = nil
			local sessionTag2 = nil

			if defineFastFlag and SessionService then
				if SessionService:SessionExists("level2a") then
					sessionID = SessionService:GetSessionID("level2a")
					sessionTag = SessionService:GetSessionTag("level2a")
				end

				if SessionService:SessionExists("level2b") then
					sessionID2 = SessionService:GetSessionID("level2b")
					sessionTag2 = SessionService:GetSessionTag("level2b")
				end
			end

			orientationChangedEvent(p, v5, {
				deviceOrientation = deviceOrientation,
				experienceOrientation = experienceOrientation,
				page = page,
				viewportX = round(v3.ViewportSize.X), -- inferred equivalent call
				viewportY = round(v3.ViewportSize.Y), -- inferred equivalent call
				universeId = gameId,
				l2a_session_id = sessionID,
				l2b_session_id = sessionID2,
				l2a_session_tag = sessionTag,
				l2b_session_tag = sessionTag2
			})
		end
	end, { p, deviceOrientation, experienceOrientation })
end

return useLogOrientationChanged
