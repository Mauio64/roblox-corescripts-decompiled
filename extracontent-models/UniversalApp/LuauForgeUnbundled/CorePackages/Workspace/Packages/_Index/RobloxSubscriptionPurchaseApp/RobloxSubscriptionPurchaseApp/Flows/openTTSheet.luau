local RobloxPlusSheetKind = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")
local RobloxSubscriptionFlowCompleteReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxSubscriptionFlowCompleteReason")
local SurfaceContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceContext")
local SurfaceName = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
local initiateRobloxSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/initiateRobloxSubscriptionPurchase")

local function openTTSheet(callback, p2, p3)
	return initiateRobloxSubscriptionPurchase({ sheetKind = RobloxPlusSheetKind.TT }, {
		onFlowComplete = function(p4)
			if callback and p4 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
				callback()
			end
		end
	}, nil, p2 or SurfaceName.TTGrantSheet, p3 or SurfaceContext.InApp)
end

return openTTSheet
