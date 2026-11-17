local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local RobloxPlusSheetKind = require(RobloxSubscriptionPurchaseApp.Enums.RobloxPlusSheetKind)
local RobloxSubscriptionFlowCompleteReason = require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)
local SurfaceContext = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceContext)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
local initiateRobloxSubscriptionPurchase = require(RobloxSubscriptionPurchaseApp.Flows.initiateRobloxSubscriptionPurchase)

local function openTTSheet(callback, p, p2)
	return initiateRobloxSubscriptionPurchase({ sheetKind = RobloxPlusSheetKind.TT }, {
		onFlowComplete = function(p3)
			if callback and p3 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
				callback()
			end
		end
	}, nil, p or SurfaceName.TTGrantSheet, p2 or SurfaceContext.InApp)
end

return openTTSheet
