local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local OpenCentralOverlayForReportLogs = require(Modules.LuaApp.Thunks.OpenCentralOverlayForReportLogs)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local buildCreatorWebNavUrl = require(Modules.LuaApp.buildCreatorWebNavUrl)
local FlyoutSidePanelComponent = require(CorePackages.Workspace.Packages.FlyoutSidePanel).Components.FlyoutSidePanelComponent
local FlyoutLogoutButton = require(script.Parent.FlyoutLogoutButton)
local shouldFlyoutShowAccountSwitch = require(script.Parent.Hooks.shouldFlyoutShowAccountSwitch)
local useFlyoutSwitchAccount = require(script.Parent.Hooks.useFlyoutSwitchAccount)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GetFFlagForceEnableReportLogsButton = require(Modules.LuaApp.Flags.GetFFlagForceEnableReportLogsButton)
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppBtidLayers = ExperimentLayers.AppBtidLayers
local AppUserLayers = ExperimentLayers.AppUserLayers
local FFlagEnableAccountSwitcherIxpExposureGating = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAccountSwitcherIxpExposureGating

local function FlyoutSidePanel(t1: {[any]: any}, _) -- line: 33
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), OpenPurchaseRobuxPage (copy), OpenCentralOverlayForReportLogs (copy), useSelector (copy), FlyoutLogoutButton (copy), shouldFlyoutShowAccountSwitch (copy), useFlyoutSwitchAccount (copy), OpenProfilePeekView (copy), GetFFlagForceEnableReportLogsButton (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagEnableAccountSwitcherIxpExposureGating (copy), IXPService (copy), AppBtidLayers (copy), FlyoutSidePanelComponent (copy), buildCreatorWebNavUrl (copy)
	local v26 = useDispatch()
	local v27 = useRoactService(RoactNetworking)
	local v28 = React.useCallback(function() -- line: 37
		-- upvalues: v26 (copy), OpenPurchaseRobuxPage (copy), v27 (copy)
		v26(OpenPurchaseRobuxPage(nil, v27))
	end, {})
	local v29 = React.useCallback(function() -- line: 41
		-- upvalues: v26 (copy), OpenCentralOverlayForReportLogs (copy)
		v26(OpenCentralOverlayForReportLogs())
	end, {})
	local v30 = useSelector(function(p2) -- line: 44
		return p2.Users[p2.LocalUserId]
	end)
	local v31 = React.useCallback(function(n1: number) -- line: 48
		-- upvalues: React (copy), FlyoutLogoutButton (copy)
		return React.createElement(FlyoutLogoutButton, {
			layoutOrder = n1
		})
	end, {})
	local v32, v33, v34 = shouldFlyoutShowAccountSwitch()
	local v35 = useFlyoutSwitchAccount(v33, v34)
	local v36 = React.useCallback(function() -- line: 57
		-- upvalues: v30 (copy), v26 (copy), OpenProfilePeekView (copy)
		if v30 and v30.id then
			v26(OpenProfilePeekView(v30.id, {
				source = "FlyoutSidePanel"
			}))
		end
	end, { v30 })
	local v37 = GetFFlagForceEnableReportLogsButton() or useUserExperiment({ AppUserLayers.AppHealthReportLogs }, function(p3) -- line: 65
		-- upvalues: AppUserLayers (copy)
		return (p3[AppUserLayers.AppHealthReportLogs] or {}).ReportLogsButtonEnabled or nil
	end)

	React.useEffect(function() -- line: 70
		-- upvalues: FFlagEnableAccountSwitcherIxpExposureGating (copy), IXPService (copy), AppBtidLayers (copy)
		if FFlagEnableAccountSwitcherIxpExposureGating then
			IXPService:LogBrowserTrackerLayerExposure(AppBtidLayers.AccountSwitcherLayer)
		end
	end, {})

	return React.createElement(FlyoutSidePanelComponent, {
		displayOrder = t1.displayOrder,
		renderLogOut = v31,
		localUserModel = v30,
		onSwitchAccountActivated = if not v32 then nil else v35,
		onProfileActivated = v36,
		openPurchaseRobuxPage = v28,
		openReportLogConfirmation = if not v37 then nil else v29,
		buildCreatorWebNavUrl = buildCreatorWebNavUrl
	})
end

return FlyoutSidePanel
