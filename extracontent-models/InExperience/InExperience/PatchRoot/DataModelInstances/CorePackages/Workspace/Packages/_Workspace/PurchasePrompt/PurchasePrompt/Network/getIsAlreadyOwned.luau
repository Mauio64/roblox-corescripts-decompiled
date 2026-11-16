local parent = script.Parent.Parent
local Players = game:GetService("Players")

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local types = require(parent.types)
local productTypeEnum = types.ProductTypeEnum
local SharedFlags = require(parent.Parent.SharedFlags)

local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local vipServerSet = { [productTypeEnum.VIPServer] = true }

local function getIsAlreadyOwned(p, p2, p3, flag: boolean?)
	if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and flag or vipServerSet[p3] then
		return Promise.resolve(false)
	end

	return p.getPlayerOwns(Players.LocalPlayer, p2, p3):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getIsAlreadyOwned
