local parent = script.Parent
local Constants = require(parent.Constants)

local GetFFlagIBEnableCollectiblesSystemSupport = require(parent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)

local UtilityFunctions = {}

function UtilityFunctions.getBundleId(p)
	return if p.parentBundleId ~= nil then p.parentBundleId else nil
end

function UtilityFunctions.isCollectibles(p)
	return p and p.productType and p.productType == Constants.ProductType.CollectibleItem
end

function UtilityFunctions.hasLimitedQuantity(data)
	if not data then
		return nil
	end

	local isLimited = data.isLimited
	local isLimitedUnique

	if GetFFlagIBEnableCollectiblesSystemSupport() then
		isLimitedUnique = data.isLimitedUnique
	end

	local collectibleIsLimited = data.collectibleIsLimited

	return isLimited or isLimitedUnique or collectibleIsLimited
end

function UtilityFunctions.isLimited1Point0(p)
	if p then
		return p.isLimited or p.isLimitedUnique
	end

	return nil
end

function UtilityFunctions.isLimited1Point0_LimitedUnique(p)
	return if p then p.isLimitedUnique else nil
end

function UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(p)
	return if p then p.collectibleIsLimited else nil
end

function UtilityFunctions.isUnlimitedCollectibleAsset(p: string?, p2)
	if not (p and p2) then
		return nil
	end

	local v = not UtilityFunctions.hasLimitedQuantity(p2)
	local v2 = p2.productType == Constants.ProductType.CollectibleItem
	local v3 = p == Constants.ItemType.Asset

	return v and v2 and v3
end

function UtilityFunctions.isLimitedBundle(p: string?, p2)
	if p and p2 then
		local collectibleIsLimited = p2.collectibleIsLimited
		local v = p == Constants.ItemType.Bundle

		return collectibleIsLimited and v
	end

	return nil
end

function UtilityFunctions.isUnlimitedCollectibleBundle(p: string?, p2)
	if not (p and p2) then
		return nil
	end

	local v = not p2.collectibleIsLimited
	local v2 = p2.productType == Constants.ProductType.CollectibleItem
	local v3 = p == Constants.ItemType.Bundle

	return v and v2 and v3
end

function UtilityFunctions.isLimitedCollectible(p)
	if not p then
		return nil
	end

	local limitedQuantity = UtilityFunctions.hasLimitedQuantity(p)
	local v = p.productType == Constants.ProductType.CollectibleItem

	return limitedQuantity and v
end

return UtilityFunctions
