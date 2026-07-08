local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local UiShellEventsParent = UiShellEvents.Parent
local React = require(UiShellEventsParent.React)
local useNavigation = require(UiShellEventsParent.Navigation).useNavigation
local useRoactService = require(UiShellEventsParent.RobloxAppHooks).useRoactService
local getCurrentRouteState = require(UiShellEventsParent.Navigation).getCurrentRouteState
local AppEventIngestService = require(UiShellEventsParent.RoactServiceTags).AppEventIngestService
local AppUserInputService = require(UiShellEventsParent.RoactServiceTags).AppUserInputService
local uiStatusBarTappedEvent = require(UiShellEvents.Analytics.uiStatusBarTappedEvent)

local function useLogStatusBarTapped(s1: string?) -- line: 11
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), AppUserInputService (copy), useNavigation (copy), getCurrentRouteState (copy), React (copy), uiStatusBarTappedEvent (copy)
	local v12 = useRoactService(AppEventIngestService)
	local v13 = useRoactService(AppUserInputService)
	local v14 = useNavigation()
	local v15 = getCurrentRouteState(v14) or {}
	local v16 = s1 or (v15.name or "Unknown")

	React.useEffect(function() -- line: 19
		-- upvalues: v13 (copy), uiStatusBarTappedEvent (copy), v12 (copy), v16 (copy)
		local connection = v13.StatusBarTapped:Connect(function() -- line: 20
			-- upvalues: uiStatusBarTappedEvent (copy), v12 (copy), v16 (copy)
			uiStatusBarTappedEvent(v12, "StatusBar", {
				page = v16
			})
		end)

		return function() -- line: 26
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v12,
		v13,
		v16
	})
end

return useLogStatusBarTapped
