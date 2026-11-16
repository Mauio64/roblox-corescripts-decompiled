local module = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxSubscriptionFlowCompleteReason")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceContext")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PurchaseClientSessionIdType")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SubscriptionGrantType")

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry
local v5 = if fFlagEnablePlusReferralEntrypointTelemetry then require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/Entrypoint") else nil
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/BlackbirdUpsellBanner")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxPlusUpsellBanner")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionProducts")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionSignals")

local v6 = {
	initiateRobloxSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/initiateRobloxSubscriptionPurchase"),
	startRobloxSubscriptionPurchaseFromUpsell = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/startRobloxSubscriptionPurchaseFromUpsell"),
	SurfaceContext = module3,
	SurfaceName = module2,
	Entrypoint = 0,
	PurchaseClientSessionIdType = 0,
	RobloxSubscriptionFlowCompleteReason = 0,
	SubscriptionGrantType = 0,
	Components = 0,
	Network = 0,
	RobloxSubscriptionSignals = 0,
	Utils = 0
}

if not fFlagEnablePlusReferralEntrypointTelemetry then
	v5 = nil
end

v6.Entrypoint = v5
v6.PurchaseClientSessionIdType = module4
v6.RobloxSubscriptionFlowCompleteReason = module
v6.SubscriptionGrantType = module5

v6.Components = { BlackbirdUpsellBanner = module6, RobloxPlusUpsellBanner = module7 }

v6.Network = {
	getRobloxSubscriptionProducts = module8,
	claimTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/claimTrial")
}

v6.RobloxSubscriptionSignals = module9
v6.Utils = { getSubscriptionPurchaseCloseCallback = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getSubscriptionPurchaseCloseCallback") }
return v6
