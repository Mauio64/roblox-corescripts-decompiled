local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local parent = UiShellEvents.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local Navigation2 = require(parent.Navigation)
local getCurrentRouteState = Navigation2.getCurrentRouteState
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppUserInputService = RoactServiceTags2.AppUserInputService
local uiStatusBarTappedEvent = require(UiShellEvents.Analytics.uiStatusBarTappedEvent)

local function useLogStatusBarTapped(p: string?)
	local v = useRoactService(AppEventIngestService)
	local v2 = useRoactService(AppUserInputService)
	local v3 = getCurrentRouteState((useNavigation())) or {}
	local page = p or v3.name or "Unknown"

	React.useEffect(function()
		local statusBarTappedConnection = v2.StatusBarTapped:Connect(function()
			uiStatusBarTappedEvent(v, "StatusBar", { page = page })
		end)

		return function()
			statusBarTappedConnection:Disconnect()
		end
	end, { v, v2, page })
end

return useLogStatusBarTapped
