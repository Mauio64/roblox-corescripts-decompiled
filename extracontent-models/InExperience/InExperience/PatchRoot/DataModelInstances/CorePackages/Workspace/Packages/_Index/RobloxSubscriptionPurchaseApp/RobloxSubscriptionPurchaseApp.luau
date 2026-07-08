local _script = script
local FFlagRobloxPlusFAEFreeTrial = require(_script.Flags.FFlagRobloxPlusFAEFreeTrial)
local RobloxSubscriptionFlowCompleteReason = require(_script.Enums.RobloxSubscriptionFlowCompleteReason)
local SurfaceName = require(_script.Enums.SurfaceName)
local SurfaceContext = require(_script.Enums.SurfaceContext)
local PurchaseClientSessionIdType = require(_script.Enums.PurchaseClientSessionIdType)
local SubscriptionGrantType = require(_script.Enums.SubscriptionGrantType)
local BlackbirdUpsellBanner = require(_script.Components.BlackbirdUpsellBanner)
local getRobloxSubscriptionProducts = require(_script.Network.getRobloxSubscriptionProducts)

require(_script.types)

local RobloxSubscriptionSignals = require(_script.Store.RobloxSubscriptionSignals)

return {
	FFlagRobloxPlusFAEFreeTrial = FFlagRobloxPlusFAEFreeTrial,
	initiateRobloxSubscriptionPurchase = require(script.Flows.initiateRobloxSubscriptionPurchase),
	SurfaceContext = SurfaceContext,
	SurfaceName = SurfaceName,
	PurchaseClientSessionIdType = PurchaseClientSessionIdType,
	RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionFlowCompleteReason,
	SubscriptionGrantType = SubscriptionGrantType,
	Components = {
		BlackbirdUpsellBanner = BlackbirdUpsellBanner
	},
	Network = {
		getRobloxSubscriptionProducts = getRobloxSubscriptionProducts,
		claimTrial = require(_script.Network.claimTrial)
	},
	RobloxSubscriptionSignals = RobloxSubscriptionSignals,
	Utils = {
		getSubscriptionPurchaseCloseCallback = require(_script.Utils.getSubscriptionPurchaseCloseCallback)
	},
	["jest.config"] = script["jest.config"]
}
