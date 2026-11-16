local initiateRobloxSubscriptionPurchaseInternal = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/initiateRobloxSubscriptionPurchaseInternal")
local RobloxSubscriptionOverlayController = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/RobloxSubscriptionOverlayController")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local SurfaceContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceContext")
local SurfaceName = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")

local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralLandingSheet

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry

local function initiateRobloxSubscriptionPurchase(p2, data, universeId, p3, p4, p5, p6, p7)
	local v5 = RobloxSubscriptionStore.get()

	if data then
		if data.onFlowComplete then
			v5.setOnFlowComplete(data.onFlowComplete)
		end

		if data.onBackButtonActivated then
			v5.setOnBackButtonActivated(data.onBackButtonActivated)
		end

		if data.onCtaOverride then
			v5.setOnCtaOverride(data.onCtaOverride)
		end
	end

	if p2 then
		v5.setPurchaseUIOptions(p2)
	end

	if p5 then
		v5.setPurchaseFlowOptions(p5)
	end

	if fFlagEnablePlusReferralLandingSheet then
		v5.setReferrerId(p7)
	end

	local v6 = {}

	if universeId ~= nil then
		v6.universeId = universeId
	end

	local clientSessionId = if p6 then p6.clientSessionId else nil

	local v7 = if fFlagEnablePlusReferralEntrypointTelemetry and p6 then p6.entrypoint else nil

	local v8 = {
		context = p4 or SurfaceContext.Unspecified,
		surfaceName = p3 or SurfaceName.Unspecified,
		metadata = v6,
		clientSessionId = clientSessionId,
		entrypoint = v7
	}

	v5.setEntryContext(v8)

	initiateRobloxSubscriptionPurchaseInternal(v8)

	return RobloxSubscriptionOverlayController.render()
end

return initiateRobloxSubscriptionPurchase
