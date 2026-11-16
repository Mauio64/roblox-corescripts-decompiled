local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/Navigation").useNavigation
local useCurrentCamera = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RobloxAppHooks").useCurrentCamera
local useDeviceOrientation = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RobloxAppHooks").useDeviceOrientation
local getCurrentRouteState = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/Navigation").getCurrentRouteState
require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RobloxAppEnums")
local orientationChangedEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Analytics/orientationChangedEvent")

local defineFastFlag = game:DefineFastFlag("LogSessionOnOrientationChange", false)
local SessionService = if defineFastFlag then game:GetService("SessionService") else nil

local v5 = {
	[Enum.ScreenOrientation.LandscapeLeft] = "LandscapeLeft",
	[Enum.ScreenOrientation.LandscapeRight] = "LandscapeRight",
	[Enum.ScreenOrientation.LandscapeSensor] = "LandscapeSensor",
	[Enum.ScreenOrientation.Portrait] = "Portrait",
	[Enum.ScreenOrientation.Sensor] = "Sensor"
}

local function round(value)
	return (math.floor(value or 0.5))
end

local function useLogOrientationChanged(p2, p3, p4)
	local v6 = useNavigation()
	local v7 = useCurrentCamera()
	local v8 = useDeviceOrientation()

	local v9 = getCurrentRouteState(v6) or {}
	local v10 = p4 or v9.name
	local v11 = v5[p3]

	React.useEffect(function()
		local gameId = tostring(game.GameId)
		local v12 = gameId == "0" and "app" or "experience"

		if v8 or v11 then
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

			orientationChangedEvent(p2, v12, {
				deviceOrientation = v8,
				experienceOrientation = v11,
				page = v10,
				viewportX = math.floor(v7.ViewportSize.X or 0.5),
				viewportY = math.floor(v7.ViewportSize.Y or 0.5),
				universeId = gameId,
				l2a_session_id = sessionID,
				l2b_session_id = sessionID2,
				l2a_session_tag = sessionTag,
				l2b_session_tag = sessionTag2
			})
		end
	end, { p2, v8, v11 })
end

return useLogOrientationChanged
