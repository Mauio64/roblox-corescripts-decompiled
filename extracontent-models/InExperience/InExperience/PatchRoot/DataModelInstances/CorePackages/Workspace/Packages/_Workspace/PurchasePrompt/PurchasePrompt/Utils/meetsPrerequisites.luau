local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ParentParentParent = ParentParent.Parent
local Constants = require(ParentParent.Misc.Constants)
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local ProductTypeEnum = require(ParentParent.types).ProductTypeEnum
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParentParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local GetFFlagEnableCreatorStorePurchasingCutover = require(ParentParent.Flags.GetFFlagEnableCreatorStorePurchasingCutover)

local function meetsPrerequisites(p1, p2, p3, p4, p5) -- line: 20
	-- upvalues: Constants (copy), PurchaseError (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), Players (copy), Workspace (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), ProductTypeEnum (copy)
	local v16 = p1.ProductType == Constants.ProductType.CollectibleItem
	local v17 = if not p1.CollectiblesItemDetails then nil else p1.CollectiblesItemDetails.IsLimited

	if v16 then
		if not v17 and p2 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p2 then
		return false, PurchaseError.AlreadyOwn
	end

	if p5 == nil and not p1.IsForSale and not p1.IsPublicDomain then
		return false, PurchaseError.NotForSale
	end

	if GetFFlagEnableCreatorStorePurchasingCutover() and p1.IsFiatPriced == true then
		return false, PurchaseError.NotForSale
	end

	if p5 == nil and p4.GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt() and p1.CanBeSoldInThisGame == false then
		return false, PurchaseError.NotForSaleHere
	end

	if p5 == nil and (v16 and v17 or p1.IsLimited or p1.IsLimitedUnique) and (p1.Remaining == nil or p1.Remaining == 0) then
		return false, PurchaseError.Limited
	end

	if p1.MinimumMembershipLevel == Enum.MembershipType.Premium.Value and Players.LocalPlayer.MembershipType ~= Enum.MembershipType.Premium then
		return false, PurchaseError.PremiumOnly
	end

	if p1.ContentRatingTypeId == 1 and Players.LocalPlayer:GetUnder13() then
		return false, PurchaseError.Under13
	end

	local v18 = if not p4.getLuaUseThirdPartyPermissions() then Workspace.AllowThirdPartySales else p4.isThirdPartyPurchaseAllowed()
	local v19 = FFlagEnableUnifiedPurchaseFlowForDevSubs and p1.ProductType == ProductTypeEnum.DeveloperSubscription

	if p1.ProductType ~= Constants.ProductType.DeveloperProduct and not v19 and p3 and not v18 then
		local v20 = game.CreatorType == Enum.CreatorType.Group
		local v21 = p1.Creator.CreatorType == "Group"
		local num = tonumber(p1.Creator.CreatorTargetId)

		if num ~= 1 and (v20 ~= v21 or num ~= game.CreatorId) then
			warn(("AllowThirdPartySales has blocked the purchase prompt for %d created by %d. To sell this asset made by a different %s, you will need to enable AllowThirdPartySales."):format(p1.AssetId, num, not v20 and "user" or "group"))

			return false, PurchaseError.ThirdPartyDisabled
		end
	end

	return true, nil
end

return meetsPrerequisites
