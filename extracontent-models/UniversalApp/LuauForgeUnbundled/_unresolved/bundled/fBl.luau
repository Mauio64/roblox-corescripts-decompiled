local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module = require("@luauforge/bundled/fvT")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/fBm")

local streamNotificationsBellIcon = require("@luauforge/bundled/fBn").StreamNotificationsBellIcon
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local tutils = require(CorePackages.Packages.tutils)
local v5 = { navigation = true }

local fFlagStreamNotificationBellEntryPoint = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagStreamNotificationBellEntryPoint
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

if SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled then
	require("@luauforge/bundled/fBn").StreamPromptsBannerSlot.set(require("@luauforge/bundled/fBo").StreamPromptsHandler)
end

local module4 = require("@luauforge/bundled/fBp")

if module4.FStringOpenChatOnJoinNotificationTypes ~= "" then
	require("@luauforge/bundled/fBv").DeeplinkTapListeners.connect(module4.handleDeeplinkTap)
end

local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local fFlagStreamNotificationDropdownSingleOwner = SharedFlags.FFlagStreamNotificationDropdownSingleOwner
local fFlagStreamNotificationDropdownFocusedOwner = SharedFlags.FFlagStreamNotificationDropdownFocusedOwner
local fFlagEnableOnScreenAPIIntegration = SharedFlags.FFlagEnableOnScreenAPIIntegration

local getLegacyNavigationStore = if fFlagSignalsNavP3bTopBar then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil
local useIsRouteOnScreen

if fFlagStreamNotificationDropdownFocusedOwner and fFlagEnableOnScreenAPIIntegration then
	useIsRouteOnScreen = require("@luauforge/bundled/dFz").useIsRouteOnScreen
else
	useIsRouteOnScreen = nil
end

local module5 = require("@luauforge/bundled/fBw")

local extended = Roact.PureComponent:extend("NotificationsButton")

local strictInterface = t.strictInterface
local v6 = {
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	isSecondary = t.optional(t.boolean),
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	isFocused = 0,
	navigation = 0,
	numberOfNotifications = 0,
	entryPoint = 0,
	getEntryPoint = 0,
	analytics = 0,
	enableNotifications = 0
}
local v7 = if fFlagStreamNotificationDropdownFocusedOwner then t.boolean else nil
v6.isFocused = v7

local v8 = if fFlagStreamNotificationDropdownFocusedOwner and not (fFlagEnableOnScreenAPIIntegration or fFlagSignalsNavP3bTopBar) then t.table else nil
v6.navigation = v8

v6.numberOfNotifications = t.integer
local v9 = if fFlagStreamNotificationBellEntryPoint then t.optional(t.string) else nil
v6.entryPoint = v9

local v10 = if fFlagStreamNotificationBellEntryPoint and fFlagSignalsNavP3bTopBar then t.optional(Dash.isCallable) else nil
v6.getEntryPoint = v10

v6.analytics = t.table

v6.enableNotifications = t.boolean
extended.validateProps = strictInterface(v6)

local function isVisible(p2)
	return p2.enableNotifications and not p2.isSearching
end

function extended:updateVisibility(p3)
	local props = self.props
	local v11 = props.enableNotifications and not props.isSearching

	if v11 ~= p3 then
		self.props.setVisible(v11)
	end
end

function extended:reportCTAIfNecessary(p3)
	if module2() then
		local numberOfNotifications = tonumber(self.props.numberOfNotifications)
		local numberOfNotifications2 = p3 and tonumber(p3.numberOfNotifications) or 0

		if numberOfNotifications > 0 and numberOfNotifications2 == 0 then
			self.props.analytics.reportNSOpenCTAShown(numberOfNotifications)
		end
	end
end

function extended:didMount()
	self:updateVisibility(nil)
end

function extended:didUpdate(p2, p3)
	self:updateVisibility(p2.enableNotifications and not p2.isSearching)
	self:reportCTAIfNecessary(p2)
end

function extended.render(p2)
	return withStyle(function(p3)
		local numberOfNotifications = p2.props.numberOfNotifications

		local createElement = Roact.createElement
		local v12 = {
			notificationCount = numberOfNotifications and tonumber(numberOfNotifications),
			compactWidth = p2.props.formFactor == formFactor.COMPACT,
			buttonRef = p2.props.buttonRef,
			entryPoint = 0,
			getEntryPoint = 0,
			isPrimary = 0,
			isFocused = 0
		}
		local v13 = if fFlagStreamNotificationBellEntryPoint then p2.props.entryPoint else nil
		v12.entryPoint = v13

		local v14 = if fFlagStreamNotificationBellEntryPoint and fFlagSignalsNavP3bTopBar then p2.props.getEntryPoint else nil
		v12.getEntryPoint = v14

		v12.isPrimary = fFlagStreamNotificationDropdownSingleOwner and true or nil
		local v15 = if fFlagStreamNotificationDropdownFocusedOwner then p2.props.isFocused else nil
		v12.isFocused = v15
		return createElement(streamNotificationsBellIcon, v12)
	end)
end

local v11 = RoactRodux.connect(function(p2, p3)
	local joined = nil

	if fFlagStreamNotificationBellEntryPoint and not fFlagSignalsNavP3bTopBar then
		local v12

		if fFlagUseNavigationSelectors then
			v12 = selectors.selectCurrentLegacyRoute(p2)
		else
			v12 = p2.Navigation.history[#p2.Navigation.history]
		end

		if v12 then
			local names = {}

			for i, v13 in ipairs(v12) do
				if v13.name then
					table.insert(names, v13.name)
				end
			end

			joined = table.concat(names, "/")
		end
	end

	local v12 = {
		numberOfNotifications = p2.NotificationBadgeCounts.TopBarNotificationIcon or 0,
		entryPoint = 0
	}

	if not fFlagStreamNotificationBellEntryPoint then
		joined = nil
	end

	v12.entryPoint = joined
	return v12
end)(extended)
local v12

if fFlagSignalsNavP3bTopBar then
	local function NotificationsButtonWithSignals(p2)
		local v13

		if fFlagStreamNotificationBellEntryPoint then
			local legacyNavigationStore = getLegacyNavigationStore(false)
			v13 = React.useCallback(function()
				return module5(legacyNavigationStore.getCurrentLegacyRoute(false))
			end, { legacyNavigationStore })
		end

		local createElement = React.createElement

		local join = Cryo.Dictionary.join
		local v15 = { navigation = Cryo.None, getEntryPoint = 0 }

		if not fFlagStreamNotificationBellEntryPoint then
			v13 = nil
		end

		v15.getEntryPoint = v13
		return createElement(v11, join(p2, v15))
	end

	v12 = React.memo(NotificationsButtonWithSignals, function(p2, p3)
		return tutils.shallowEqual(p2, p3, v5)
	end)
else
	v12 = v11
end

local v13

if fFlagStreamNotificationDropdownFocusedOwner then
	v13 = fFlagEnableOnScreenAPIIntegration and function(p2)
		local v14 = useIsRouteOnScreen()
		return React.createElement(v12, Cryo.Dictionary.union(p2, { isFocused = v14 }))
	end or RoactNavigation.withNavigationFocus(v12)
else
	v13 = v12
end

local v14 = roactServices.connect({ analytics = module })(v13)

return (roactAppPolicy.connect(function(p2, p3)
	return { enableNotifications = p2.getNotifications() }
end)(v14))
