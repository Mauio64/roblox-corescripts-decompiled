local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local initiateRobloxSubscriptionPurchaseInternal = require(RobloxSubscriptionPurchaseApp.Actions.initiateRobloxSubscriptionPurchaseInternal)
local RobloxSubscriptionOverlayController = require(RobloxSubscriptionPurchaseApp.Flows.RobloxSubscriptionOverlayController)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local SurfaceContext = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceContext)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
require(RobloxSubscriptionPurchaseApp.types)
local parent = RobloxSubscriptionPurchaseApp.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePlusReferralEntrypointTelemetry = SharedFlags2.FFlagEnablePlusReferralEntrypointTelemetry

local function initiateRobloxSubscriptionPurchase(p, data, universeId: number?, p2, p3, p4, p5, p6: number?)
	local v = RobloxSubscriptionStore.get()

	if data then
		if data.onFlowComplete then
			v.setOnFlowComplete(data.onFlowComplete)
		end

		if data.onBackButtonActivated then
			v.setOnBackButtonActivated(data.onBackButtonActivated)
		end

		if data.onCtaOverride then
			v.setOnCtaOverride(data.onCtaOverride)
		end
	end

	if p then
		v.setPurchaseUIOptions(p)
	end

	if p4 then
		v.setPurchaseFlowOptions(p4)
	end

	if FFlagEnablePlusReferralLandingSheet then
		v.setReferrerId(p6)
	end

	local metadata = {}

	if universeId ~= nil then
		metadata.universeId = universeId
	end

	local clientSessionId

	if p5 then
		clientSessionId = p5.clientSessionId
	end

	local entrypoint

	if FFlagEnablePlusReferralEntrypointTelemetry and p5 then
		entrypoint = p5.entrypoint
	end

	local v2 = {
		context = p3 or SurfaceContext.Unspecified,
		surfaceName = p2 or SurfaceName.Unspecified,
		metadata = metadata,
		clientSessionId = clientSessionId,
		entrypoint = entrypoint
	}

	v.setEntryContext(v2)

	initiateRobloxSubscriptionPurchaseInternal(v2)

	return RobloxSubscriptionOverlayController.render()
end

return initiateRobloxSubscriptionPurchase
