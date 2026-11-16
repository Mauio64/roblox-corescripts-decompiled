local parent = script.Parent.Parent
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local parent2 = parent.Parent
local Constants = require(parent.Misc.Constants)
local PurchaseError = require(parent.Enums.PurchaseError)
local types = require(parent.types)
local productTypeEnum = types.ProductTypeEnum
local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs

local GetFFlagEnableCreatorStorePurchasingCutover = require(parent.Flags.GetFFlagEnableCreatorStorePurchasingCutover)

local FFlagPurchasePromptSkipThirdPartyCheckForMissingCreator = require(parent.Flags.FFlagPurchasePromptSkipThirdPartyCheckForMissingCreator)

local function meetsPrerequisites(data, p, p2, p3, p4)
	local v = data.ProductType == Constants.ProductType.CollectibleItem
	local isLimited

	if data.CollectiblesItemDetails then
		isLimited = data.CollectiblesItemDetails.IsLimited
	end

	if v then
		if not isLimited and p then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p then
		return false, PurchaseError.AlreadyOwn
	end

	if
		p4 == nil and not (data.IsForSale or data.IsPublicDomain)
		or GetFFlagEnableCreatorStorePurchasingCutover() and data.IsFiatPriced == true
	then
		return false, PurchaseError.NotForSale
	end

	if p4 == nil and data.CanBeSoldInThisGame == false then
		return false, PurchaseError.NotForSaleHere
	end

	if
		p4 == nil
		and (v and isLimited or data.IsLimited or data.IsLimitedUnique)
		and (data.Remaining == nil or data.Remaining == 0)
	then
		return false, PurchaseError.Limited
	end

	if
		data.MinimumMembershipLevel == Enum.MembershipType.Premium.Value
		and Players.LocalPlayer.MembershipType ~= Enum.MembershipType.Premium
	then
		return false, PurchaseError.PremiumOnly
	end

	if data.ContentRatingTypeId == 1 and Players.LocalPlayer:GetUnder13() then
		return false, PurchaseError.Under13
	end

	local v2

	if p3.getLuaUseThirdPartyPermissions() then
		v2 = p3.isThirdPartyPurchaseAllowed()
	else
		v2 = Workspace.AllowThirdPartySales
	end

	local v3 = FFlagEnableUnifiedPurchaseFlowForDevSubs and data.ProductType == productTypeEnum.DeveloperSubscription

	local v4 = FFlagPurchasePromptSkipThirdPartyCheckForMissingCreator and data.Creator == nil

	if data.ProductType == Constants.ProductType.DeveloperProduct or v3 or v4 or not p2 or v2 then
		return true, nil
	end

	local v5 = game.CreatorType == Enum.CreatorType.Group
	local v6 = data.Creator.CreatorType == "Group"
	local creatorTargetId = tonumber(data.Creator.CreatorTargetId)

	if creatorTargetId ~= 1 and (v5 ~= v6 or creatorTargetId ~= game.CreatorId) then
		warn(("AllowThirdPartySales has blocked the purchase prompt for %d created by %d. To sell this asset made by a different %s, you will need to enable AllowThirdPartySales."):format(
			data.AssetId,
			creatorTargetId,
			v5 and "group" or "user"
		))
		return false, PurchaseError.ThirdPartyDisabled
	end

	return true, nil
end

return meetsPrerequisites
