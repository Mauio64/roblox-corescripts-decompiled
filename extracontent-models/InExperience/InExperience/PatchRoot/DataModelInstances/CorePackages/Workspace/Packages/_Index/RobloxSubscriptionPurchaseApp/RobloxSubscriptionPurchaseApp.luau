local script2 = script
local RobloxSubscriptionFlowCompleteReason = require(script2.Enums.RobloxSubscriptionFlowCompleteReason)
local SurfaceName = require(script2.Enums.SurfaceName)
local SurfaceContext = require(script2.Enums.SurfaceContext)
local PurchaseClientSessionIdType = require(script2.Enums.PurchaseClientSessionIdType)
local SubscriptionGrantType = require(script2.Enums.SubscriptionGrantType)
local parent = script2.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralEntrypointTelemetry = SharedFlags.FFlagEnablePlusReferralEntrypointTelemetry
local Entrypoint

if FFlagEnablePlusReferralEntrypointTelemetry then
	Entrypoint = require(script2.Enums.Entrypoint)
end

local BlackbirdUpsellBanner = require(script2.Components.BlackbirdUpsellBanner)
local RobloxPlusUpsellBanner = require(script2.Components.RobloxPlusUpsellBanner)
local getRobloxSubscriptionProducts = require(script2.Network.getRobloxSubscriptionProducts)
require(script2.types)
local RobloxSubscriptionSignals = require(script2.Store.RobloxSubscriptionSignals)

local RobloxSubscriptionPurchaseApp = {}
RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase = require(script.Flows.initiateRobloxSubscriptionPurchase)
RobloxSubscriptionPurchaseApp.startRobloxSubscriptionPurchaseFromUpsell = require(script.Flows.startRobloxSubscriptionPurchaseFromUpsell)
RobloxSubscriptionPurchaseApp.SurfaceContext = SurfaceContext
RobloxSubscriptionPurchaseApp.SurfaceName = SurfaceName

if not FFlagEnablePlusReferralEntrypointTelemetry then
	Entrypoint = nil
end

RobloxSubscriptionPurchaseApp.Entrypoint = Entrypoint
RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType = PurchaseClientSessionIdType
RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionFlowCompleteReason
RobloxSubscriptionPurchaseApp.SubscriptionGrantType = SubscriptionGrantType

RobloxSubscriptionPurchaseApp.Components = {
	BlackbirdUpsellBanner = BlackbirdUpsellBanner,
	RobloxPlusUpsellBanner = RobloxPlusUpsellBanner
}

RobloxSubscriptionPurchaseApp.Network = {
	getRobloxSubscriptionProducts = getRobloxSubscriptionProducts,
	claimTrial = require(script2.Network.claimTrial)
}

RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals = RobloxSubscriptionSignals
RobloxSubscriptionPurchaseApp.Utils = {
	getSubscriptionPurchaseCloseCallback = require(script2.Utils.getSubscriptionPurchaseCloseCallback)
}

RobloxSubscriptionPurchaseApp["jest.config"] = script["jest.config"]
return RobloxSubscriptionPurchaseApp
