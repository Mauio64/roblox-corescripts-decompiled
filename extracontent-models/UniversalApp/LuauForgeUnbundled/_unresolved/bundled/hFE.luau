local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local homePageLoadTracker = require("@luauforge/bundled/hFF").HomePageLoadTracker

local module = require("@luauforge/bundled/ftU")
local checkForSduiModal = module.CheckForSduiModal
local checkForPrompts = module.CheckForPrompts

local module2 = require("@luauforge/bundled/hFL")

local module3 = require("@luauforge/bundled/hFN")
local module4 = require("@luauforge/bundled/hFO")
local module5 = require("@luauforge/bundled/huX")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local fFlagLuaAppHomeVngAppUpsell = SharedFlags.FFlagLuaAppHomeVngAppUpsell
local getFFlagEnablePushNotificationsUpsellModal = SharedFlags.GetFFlagEnablePushNotificationsUpsellModal
local getFFlagEnableReminderOfNormsABTest = SharedFlags.GetFFlagEnableReminderOfNormsABTest
local fFlagLuaAppsServerTriggeredModals = SharedFlags.FFlagLuaAppsServerTriggeredModals
local fFlagEnableSduiV2HomepagePrompts = SharedFlags.FFlagEnableSduiV2HomepagePrompts
local fFlagLuaAppHomePageLoadTracker = SharedFlags.FFlagLuaAppHomePageLoadTracker
local fFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration
local useOnScreenNavigationListener

if fFlagEnableOnScreenAPIIntegration then
	useOnScreenNavigationListener = require("@luauforge/bundled/dCu").useOnScreenNavigationListener
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

	local v12 = if getFFlagEnableReminderOfNormsABTest() then React.createElement(module4) else nil

	local v13 = if fFlagLuaAppsServerTriggeredModals then React.createElement(checkForSduiModal) else nil
	local v14 = if fFlagEnableSduiV2HomepagePrompts then React.createElement(checkForPrompts) else nil
	return createElement(fragment, nil, {
		NavigationEvents = v9,
		CheckForVngAppUpsell = v10,
		CheckForPushNotificationsUpsell = v11,
		CheckForReminderOfNorms = v12,
		CheckForSduiModal = v13,
		CheckForPrompts = v14
	})
end

return module5(HomePageEffects)
