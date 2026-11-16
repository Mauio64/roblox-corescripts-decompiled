local Players = game:GetService("Players")

local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local vipServerSet = { [productTypeEnum.VIPServer] = true }

local function getIsAlreadyOwned(p2, p3, p4, p5)
	if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and p5 or vipServerSet[p4] then
		return Promise.resolve(false)
	end

	return p2.getPlayerOwns(Players.LocalPlayer, p3, p4):catch(function(p6)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getIsAlreadyOwned
