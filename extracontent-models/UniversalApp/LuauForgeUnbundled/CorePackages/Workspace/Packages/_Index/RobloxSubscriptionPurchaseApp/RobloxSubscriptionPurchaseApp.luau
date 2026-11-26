local module = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxSubscriptionFlowCompleteReason")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceContext")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PurchaseClientSessionIdType")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SubscriptionGrantType")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry
local v5 = if fFlagEnablePlusReferralEntrypointTelemetry then require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/Entrypoint") else nil
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/BlackbirdUpsellBanner")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxPlusUpsellBanner")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionProducts")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionSignals")

local v6 = {
	initiateRobloxSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/initiateRobloxSubscriptionPurchase"),
	resetRobloxSubscriptionPurchaseConfiguration = function()
		require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/resetRobloxSubscriptionPurchaseConfiguration")()
	end,
	openTTSheet = 0,
	startRobloxSubscriptionPurchaseFromUpsell = 0,
	SurfaceContext = 0,
	SurfaceName = 0,
	Entrypoint = 0,
	PurchaseClientSessionIdType = 0,
	RobloxSubscriptionFlowCompleteReason = 0,
	SubscriptionGrantType = 0,
	RobloxPlusSheetKind = 0,
	Flags = 0,
	Components = 0,
	Network = 0,
	RobloxSubscriptionSignals = 0,
	CampaignLocalizations = 0,
	Utils = 0
}
local v7 = if module7 then require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/openTTSheet") else nil
v6.openTTSheet = v7
v6.startRobloxSubscriptionPurchaseFromUpsell = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/startRobloxSubscriptionPurchaseFromUpsell")
v6.SurfaceContext = module3
v6.SurfaceName = module2

if not fFlagEnablePlusReferralEntrypointTelemetry then
	v5 = nil
end

v6.Entrypoint = v5
v6.PurchaseClientSessionIdType = module4
v6.RobloxSubscriptionFlowCompleteReason = module
v6.SubscriptionGrantType = module5
v6.RobloxPlusSheetKind = module6

v6.Flags = {
	FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet"),
	FFlagSubscriptionSheetCampaignLocalizations = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagSubscriptionSheetCampaignLocalizations
}

v6.Components = { BlackbirdUpsellBanner = module8, RobloxPlusUpsellBanner = module9 }

v6.Network = {
	getRobloxSubscriptionProducts = module10,
	claimTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/claimTrial")
}

v6.RobloxSubscriptionSignals = module11
v6.CampaignLocalizations = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/CampaignLocalizations")
v6.Utils = { getSubscriptionPurchaseCloseCallback = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getSubscriptionPurchaseCloseCallback") }
return v6
