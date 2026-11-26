local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local homePageLoadTracker = require("@luauforge/bundled/hQG").HomePageLoadTracker

local module = require("@luauforge/bundled/fBo")
local checkForSduiModal = module.CheckForSduiModal
local checkForPrompts = module.CheckForPrompts

local module2 = require("@luauforge/bundled/hQH")

local module3 = require("@luauforge/bundled/hQJ")
local module4 = require("@luauforge/bundled/hQK")
local module5 = require("@luauforge/bundled/hGe")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local fFlagLuaAppHomeVngAppUpsell = SharedFlags.FFlagLuaAppHomeVngAppUpsell
local getFFlagEnablePushNotificationsUpsellModal = SharedFlags.GetFFlagEnablePushNotificationsUpsellModal
local fFlagLuaAppsServerTriggeredModals = SharedFlags.FFlagLuaAppsServerTriggeredModals
local fFlagEnableSduiV2HomepagePrompts = SharedFlags.FFlagEnableSduiV2HomepagePrompts
local fFlagLuaAppHomePageLoadTracker = SharedFlags.FFlagLuaAppHomePageLoadTracker
local fFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local useOnScreenNavigationListener

if fFlagEnableOnScreenAPIIntegration then
	useOnScreenNavigationListener = require("@luauforge/bundled/dFz").useOnScreenNavigationListener
else
	useOnScreenNavigationListener = nil
end

local function HomePageEffects(p2)
	local setThrottleFramerateEnabled = p2.setThrottleFramerateEnabled

	local v5 = React.useCallback(function()
		if fFlagLuaAppHomePageLoadTracker then
			homePageLoadTracker.logSurfaceMounted()

			if homePageLoadTracker.isWarmVisit() then
				homePageLoadTracker.logFunctionallyReadyAndEnd()
			end
		end

		if isSubjectToDesktopPolicies() and setThrottleFramerateEnabled then
			setThrottleFramerateEnabled(false)
		end
	end, { setThrottleFramerateEnabled })

	local v6 = React.useCallback(function()
		if isSubjectToDesktopPolicies() and setThrottleFramerateEnabled then
			setThrottleFramerateEnabled(true)
		end
	end, { setThrottleFramerateEnabled })

	local ref = React.useRef(v5)
	ref.current = v5

	React.useEffect(function()
		ref.current()
	end, {})

	if fFlagEnableOnScreenAPIIntegration then
		useOnScreenNavigationListener(v5, v6)
	end

	local createElement = React.createElement
	local fragment = React.Fragment

	local v9 = if not fFlagEnableOnScreenAPIIntegration then React.createElement(RoactNavigation.NavigationEvents, {
		onDidFocus = v5,
		onWillBlur = v6
	}) else nil

	local v10 = if fFlagLuaAppHomeVngAppUpsell then React.createElement(module2) else nil
	local v11 = if getFFlagEnablePushNotificationsUpsellModal() then React.createElement(module3) else nil
	local v8 = {
		NavigationEvents = v9,
		CheckForVngAppUpsell = v10,
		CheckForPushNotificationsUpsell = v11,
		CheckForReminderOfNorms = React.createElement(module4),
		CheckForSduiModal = 0,
		CheckForPrompts = 0
	}
	local v12 = if fFlagLuaAppsServerTriggeredModals then React.createElement(checkForSduiModal) else nil
	v8.CheckForSduiModal = v12
	local v13 = if fFlagEnableSduiV2HomepagePrompts then React.createElement(checkForPrompts) else nil
	v8.CheckForPrompts = v13
	return createElement(fragment, nil, v8)
end

return module5(HomePageEffects)
