local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

local module = require("@luauforge/bundled/fAF")
local OpenCentralOverlayForUnifiedPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/PurchasePromptLite/PurchasePromptLite/State/Thunks/OpenCentralOverlayForUnifiedPurchasePrompt")
local module3 = require("@luauforge/bundled/ehA")
local module4 = require("@luauforge/bundled/fFR")
local module5 = require("@luauforge/bundled/ghP")
local module6 = require("@luauforge/bundled/dFu")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagEnablePlusReferralRecipientFlyoutEntry = SharedFlags.FFlagEnablePlusReferralRecipientFlyoutEntry
local fFlagEnablePlusReferralEntrypointTelemetry = SharedFlags.FFlagEnablePlusReferralEntrypointTelemetry

local v5 = if fFlagEnablePlusReferralRecipientFlyoutEntry then require("@luauforge/bundled/fHh") else nil

local fFlagEnablePlusReferralFlyoutEntry = SharedFlags.FFlagEnablePlusReferralFlyoutEntry
local v6

if fFlagEnablePlusReferralFlyoutEntry or fFlagEnablePlusReferralRecipientFlyoutEntry then
	v6 = require("@luauforge/bundled/gVD")
end

local useHasPendingReferral = if fFlagEnablePlusReferralRecipientFlyoutEntry then v6.useHasPendingReferral else nil
local useReferralEligibility

if fFlagEnablePlusReferralFlyoutEntry or fFlagEnablePlusReferralRecipientFlyoutEntry then
	useReferralEligibility = v6.useReferralEligibility
else
	useReferralEligibility = nil
end

local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module8 = require("@luauforge/bundled/iey")

local flyoutSidePanelComponent = require("@luauforge/bundled/fAm").Components.FlyoutSidePanelComponent
local module9 = require("@luauforge/bundled/iez")
local module10 = require("@luauforge/bundled/ieA")
local module11 = require("@luauforge/bundled/ieB")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module12 = require("@luauforge/bundled/hRz")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local module13 = require("@luauforge/bundled/dPQ")
local appBtidLayers = module13.AppBtidLayers
local appUserLayers = module13.AppUserLayers

local function FlyoutSidePanel(p2, p3)
	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)

	local v9 = React.useCallback(function()
		v7(module(nil, v8))
	end, {})

	local v10 = React.useCallback(function()
		v7(OpenCentralOverlayForUnifiedPurchasePrompt())
	end, {})
	local v11 = useSelector(function(p4)
		return p4.Users[p4.LocalUserId]
	end)

	local v12 = React.useCallback(function(p4)
		return React.createElement(module9, { layoutOrder = p4 })
	end, {})

	local v13, v14 = module10()
	local v15 = module11(v14)

	local v16 = React.useCallback(function()
		if module8 then
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.to(navigationCommands.fromLegacyPage({
					name = module6.AvatarExperienceRoot
				}))
			else
				v7(module5({
					{ name = module6.AvatarExperienceRoot }
				}))
			end
		elseif v11 and v11.id then
			v7(module3(v11.id, { source = "FlyoutSidePanel" }))
		end
	end, { v11 })

	local v17 = module12() or useUserExperiment({ appUserLayers.AppHealthReportLogs }, function(p4)
		return (p4[appUserLayers.AppHealthReportLogs] or {}).ReportLogsButtonEnabled or nil
	end)
	local v18

	if fFlagEnableBlackbirdCheck then
		v18 = useSelector(function(p4)
			local user = p4.Users[p4.LocalUserId]
			return user and user.hasRobloxSubscription == true and true or false
		end)
	else
		v18 = false
	end

	local v19, v20

	if fFlagEnablePlusReferralRecipientFlyoutEntry then
		v19 = useHasPendingReferral(not v18)

		v20 = useReferralEligibility(not v18 and v19.hasPending, v19.referrerId)
	end

	local v21 = if fFlagEnablePlusReferralFlyoutEntry then useReferralEligibility(v18, nil) else nil
	local v22

	if fFlagEnablePlusReferralRecipientFlyoutEntry then
		v22 = React.useCallback(function(p4)
			v5.initiateRobloxSubscriptionPurchase(
				nil,
				nil,
				nil,
				v5.SurfaceName.PlusReferralLandingSheet,
				v5.SurfaceContext.InApp,
				nil,
				fFlagEnablePlusReferralEntrypointTelemetry and {
					entrypoint = v5.Entrypoint.FlyoutMenu
				} or nil,
				p4
			)
		end, {})
	end

	React.useEffect(function()
		IXPService:LogBrowserTrackerLayerExposure(appBtidLayers.AccountSwitcherLayer)
	end, {})

	local createElement = React.createElement
	local v24 = {
		displayOrder = p2.displayOrder,
		renderLogOut = v12,
		localUserModel = v11,
		onSwitchAccountActivated = 0,
		onProfileActivated = 0,
		openPurchaseRobuxPage = 0,
		openReportLogConfirmation = 0,
		buildCreatorWebNavUrl = 0,
		onOpenReferralSheet = 0,
		pendingReferral = 0,
		recipientEligibility = 0,
		senderEligibility = 0
	}

	if not v13 then
		v15 = nil
	end

	v24.onSwitchAccountActivated = v15
	v24.onProfileActivated = v16
	v24.openPurchaseRobuxPage = v9

	if not v17 then
		v10 = nil
	end

	v24.openReportLogConfirmation = v10
	v24.buildCreatorWebNavUrl = module4
	v24.onOpenReferralSheet = v22
	v24.pendingReferral = v19
	v24.recipientEligibility = v20
	v24.senderEligibility = v21
	return createElement(flyoutSidePanelComponent, v24)
end

return FlyoutSidePanel
