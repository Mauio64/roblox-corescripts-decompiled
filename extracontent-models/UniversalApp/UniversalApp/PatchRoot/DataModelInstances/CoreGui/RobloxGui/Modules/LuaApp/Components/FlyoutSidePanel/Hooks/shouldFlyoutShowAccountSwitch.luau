local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local FFlagLuaAccountSwitchExperimentBypassBackdoorDev = require(Modules.LuaApp.Flags.FFlagLuaAccountSwitchExperimentBypassBackdoorDev)
local FFlagEnableAuthButtonShownEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAuthButtonShownEvent
local FFlagAuthSecExclusions = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAuthSecExclusions
local GetFFlagEnableAccountSwitcherRedesignIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherRedesignIXP

local function shouldFlyoutShowAccountSwitch() -- line: 20
	-- upvalues: useAppPolicy (copy), RoactAppExperiment (copy), AppBtidLayers (copy), User (copy), FFlagLuaAccountSwitchExperimentBypassBackdoorDev (copy), FFlagAuthSecExclusions (copy), FFlagEnableLuaAccountSwitch (copy), EventStreamConstants (copy), FFlagEnableAuthButtonShownEvent (copy), useRoactService (copy), RoactAnalyticsAuthEvents (copy), React (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy)
	local v17 = useAppPolicy(function(p1) -- line: 21
		return p1
	end)
	local v18 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AccountSwitcherLayer }, function(p2) -- line: 26
		-- upvalues: AppBtidLayers (copy)
		return p2[AppBtidLayers.AccountSwitcherLayer] or {}
	end)
	local isAccountSwitcherEnabled = v18.isAccountSwitcherEnabled
	local v20 = User.fromLocalStorage()
	local v21 = isAccountSwitcherEnabled or FFlagLuaAccountSwitchExperimentBypassBackdoorDev
	local v22 = v20.isUnder13 ~= true
	local v23 = FFlagAuthSecExclusions and v17.getExcludeAccountSwitcher()
	local v24 = FFlagEnableLuaAccountSwitch and (not v23 and (v22 and v21))
	local v25 = if not v23 then if v22 then if not v24 then EventStreamConstants.State.SwitchAccountsIxpHidden else EventStreamConstants.State.SwitchAccountsShown else EventStreamConstants.State.SwitchAccountsU13Hidden else EventStreamConstants.State.SwitchAccountsExclusionsHidden

	if FFlagEnableAuthButtonShownEvent then
		local v26 = useRoactService(RoactAnalyticsAuthEvents)

		React.useEffect(function() -- line: 50
			-- upvalues: v26 (copy), EventStreamConstants (copy), v25 (copy)
			v26.reportAuthButtonShown(EventStreamConstants.Context.FlyoutSidePanel, EventStreamConstants.Button.SwitchAccounts, v25, EventStreamConstants.Origin.FlyoutSidePanel)
		end, { v25 })
	end

	local v27, v28

	if GetFFlagEnableAccountSwitcherRedesignIXP() then
		v27 = v18.enableAccountSwitcherFoundationDesign == true
		v28 = v18.enableAccountSwitcherSignedOutAccounts == true
	else
		v27 = true
		v28 = true
	end

	return v24, v27, v28
end

return shouldFlyoutShowAccountSwitch
