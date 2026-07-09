local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactAnalyticsTopBar = require(Modules.LuaApp.Services.RoactAnalyticsTopBar)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local GetFFlagReportNotificationStreamCTA = require(Modules.LuaApp.Flags.GetFFlagReportNotificationStreamCTA)
local StreamNotificationsBellIcon = require(CorePackages.Workspace.Packages.StreamNotifications).StreamNotificationsBellIcon
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local FFlagStreamNotificationBellEntryPoint = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStreamNotificationBellEntryPoint
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local FFlagStreamNotificationDropdownSingleOwner = SharedFlags.FFlagStreamNotificationDropdownSingleOwner
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v23 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v24 = Roact.PureComponent:extend("NotificationsButton")

v24.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	isSecondary = t.optional(t.boolean),
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	numberOfNotifications = t.integer,
	entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else t.optional(t.string),
	analytics = t.table,
	enableNotifications = t.boolean
})

local function isVisible(p1) -- line: 63
	return p1.enableNotifications and not p1.isSearching
end

function v24.updateVisibility(p2, p3) -- line: 67
	local props = p2.props
	local v33 = props.enableNotifications and not props.isSearching

	if v33 ~= p3 then
		p2.props.setVisible(v33)
	end
end
function v24.reportCTAIfNecessary(p4, p5) -- line: 74
	-- upvalues: GetFFlagReportNotificationStreamCTA (copy)
	if GetFFlagReportNotificationStreamCTA() then
		local num = tonumber(p4.props.numberOfNotifications)
		local v37 = p5 and tonumber(p5.numberOfNotifications) or 0

		if num > 0 and v37 == 0 then
			p4.props.analytics.reportNSOpenCTAShown(num)
		end
	end
end
function v24.didMount(p6) -- line: 85
	p6:updateVisibility(nil)
end
function v24.didUpdate(p7, p8, _) -- line: 89
	p7:updateVisibility(p8.enableNotifications and not p8.isSearching)
	p7:reportCTAIfNecessary(p8)
end
function v24.render(p10) -- line: 94
	-- upvalues: withStyle (copy), Roact (copy), StreamNotificationsBellIcon (copy), FormFactor (copy), FFlagStreamNotificationBellEntryPoint (copy), FFlagStreamNotificationDropdownSingleOwner (copy)
	return withStyle(function(_) -- line: 95
		-- upvalues: p10 (copy), Roact (copy), StreamNotificationsBellIcon (copy), FormFactor (copy), FFlagStreamNotificationBellEntryPoint (copy), FFlagStreamNotificationDropdownSingleOwner (copy)
		local numberOfNotifications = p10.props.numberOfNotifications

		return Roact.createElement(StreamNotificationsBellIcon, {
			notificationCount = numberOfNotifications and tonumber(numberOfNotifications),
			compactWidth = p10.props.formFactor == FormFactor.COMPACT,
			buttonRef = p10.props.buttonRef,
			entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else p10.props.entryPoint,
			isPrimary = not not FFlagStreamNotificationDropdownSingleOwner or nil
		})
	end)
end

local v26 = RoactRodux.connect(function(p12, _) -- line: 110
	-- upvalues: FFlagStreamNotificationBellEntryPoint (copy), FFlagSignalsNavP3bTopBar (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v45 = nil

	if FFlagStreamNotificationBellEntryPoint and not FFlagSignalsNavP3bTopBar then
		local v46 = if not FFlagUseNavigationSelectors then p12.Navigation.history[#p12.Navigation.history] else Selectors.selectCurrentLegacyRoute(p12)

		if v46 then
			local t1 = {}

			for _, v in ipairs(v46) do
				if v.name then
					table.insert(t1, v.name)
				end
			end

			v45 = table.concat(t1, "/")
		end
	end

	return {
		numberOfNotifications = p12.NotificationBadgeCounts.TopBarNotificationIcon or 0,
		entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else v45
	}
end)(v24)

if FFlagSignalsNavP3bTopBar then
	local v27 = v26

	function v26(p14) -- line: 135
		-- upvalues: FFlagStreamNotificationBellEntryPoint (copy), v23 (copy), useSignalState (copy), React (copy), v27 (copy), Cryo (copy)
		local v51 = nil

		if FFlagStreamNotificationBellEntryPoint then
			local v52 = v23(false)
			local v53 = useSignalState(v52.getCurrentLegacyRoute)

			if v53 then
				local t2 = {}

				for _, v in ipairs(v53) do
					if v.name then
						table.insert(t2, v.name)
					end
				end

				v51 = table.concat(t2, "/")
			end
		end

		return React.createElement(v27, Cryo.Dictionary.union(p14, {
			entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else v51
		}))
	end
end

local v28 = RoactServices.connect({
	analytics = RoactAnalyticsTopBar
})(v26)

return (RoactAppPolicy.connect(function(p15, _) -- line: 163
	return {
		enableNotifications = p15.getNotifications()
	}
end)(v28))
