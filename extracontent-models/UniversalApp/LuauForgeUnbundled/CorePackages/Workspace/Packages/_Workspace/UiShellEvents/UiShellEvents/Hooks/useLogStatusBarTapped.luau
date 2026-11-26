local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/Navigation").useNavigation
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RobloxAppHooks").useRoactService
local getCurrentRouteState = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/Navigation").getCurrentRouteState
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RoactServiceTags").AppEventIngestService
local appUserInputService = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RoactServiceTags").AppUserInputService
local uiStatusBarTappedEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Analytics/uiStatusBarTappedEvent")

local function useLogStatusBarTapped(p2)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useRoactService(appUserInputService)
	local v8 = getCurrentRouteState((useNavigation())) or {}
	local v9 = p2 or v8.name or "Unknown"

	React.useEffect(function()
		local statusBarTappedConnection = v6.StatusBarTapped:Connect(function()
			uiStatusBarTappedEvent(v5, "StatusBar", { page = v9 })
		end)

		return function()
			statusBarTappedConnection:Disconnect()
		end
	end, { v5, v6, v9 })
end

return useLogStatusBarTapped
