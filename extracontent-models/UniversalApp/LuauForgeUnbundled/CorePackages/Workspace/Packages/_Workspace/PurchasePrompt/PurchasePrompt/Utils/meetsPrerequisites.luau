local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local GetFFlagEnableCreatorStorePurchasingCutover = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableCreatorStorePurchasingCutover")

local FFlagPurchasePromptSkipThirdPartyCheckForMissingCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagPurchasePromptSkipThirdPartyCheckForMissingCreator")

local function meetsPrerequisites(data, p2, p3, p4, p5)
	local v5 = data.ProductType == Constants.ProductType.CollectibleItem
	local isLimited = if data.CollectiblesItemDetails then data.CollectiblesItemDetails.IsLimited else nil

	if v5 then
		if not isLimited and p2 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p2 then
		return false, PurchaseError.AlreadyOwn
	end

	if
		p5 == nil and not (data.IsForSale or data.IsPublicDomain)
		or GetFFlagEnableCreatorStorePurchasingCutover() and data.IsFiatPriced == true
	then
		return false, PurchaseError.NotForSale
	end

	if p5 == nil and data.CanBeSoldInThisGame == false then
		return false, PurchaseError.NotForSaleHere
	end

	if
		p5 == nil
		and (v5 and isLimited or data.IsLimited or data.IsLimitedUnique)
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

	local v6

	if p4.getLuaUseThirdPartyPermissions() then
		v6 = p4.isThirdPartyPurchaseAllowed()
	else
		v6 = Workspace.AllowThirdPartySales
	end

	local v7 = fFlagEnableUnifiedPurchaseFlowForDevSubs
		and data.ProductType == productTypeEnum.DeveloperSubscription

	local v8 = FFlagPurchasePromptSkipThirdPartyCheckForMissingCreator and data.Creator == nil

	if data.ProductType == Constants.ProductType.DeveloperProduct or v7 or v8 or not p3 or v6 then
		return true, nil
	end

	local v9 = game.CreatorType == Enum.CreatorType.Group
	local v10 = data.Creator.CreatorType == "Group"
	local creatorTargetId = tonumber(data.Creator.CreatorTargetId)

	if creatorTargetId ~= 1 and (v9 ~= v10 or creatorTargetId ~= game.CreatorId) then
		warn(("AllowThirdPartySales has blocked the purchase prompt for %d created by %d. To sell this asset made by a different %s, you will need to enable AllowThirdPartySales."):format(
			data.AssetId,
			creatorTargetId,
			v9 and "group" or "user"
		))
		return false, PurchaseError.ThirdPartyDisabled
	end

	return true, nil
end

return meetsPrerequisites
