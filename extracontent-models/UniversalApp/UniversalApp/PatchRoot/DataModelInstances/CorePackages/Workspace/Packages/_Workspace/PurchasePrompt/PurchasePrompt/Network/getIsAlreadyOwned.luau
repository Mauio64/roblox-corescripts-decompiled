local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require(ParentParent.Parent.SharedFlags).FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local function getIsAlreadyOwned(p1, p2, p3, b1: boolean?) -- line: 11
	-- upvalues: FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), Promise (copy), Players (copy), PurchaseError (copy)
	if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and b1 then
		return Promise.resolve(false)
	end

	return p1.getPlayerOwns(Players.LocalPlayer, p2, p3):catch(function(_) -- line: 15
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getIsAlreadyOwned
