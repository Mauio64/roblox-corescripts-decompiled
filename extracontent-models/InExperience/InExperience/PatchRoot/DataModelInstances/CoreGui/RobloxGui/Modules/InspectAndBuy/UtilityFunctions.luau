local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local GetFFlagIBEnableCollectiblesSystemSupport = require(scriptParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local t1 = {
	getBundleId = function(p1) -- line: 9
		if p1.parentBundleId ~= nil then
			return p1.parentBundleId
		end

		return nil
	end,
	isCollectibles = function(p2) -- line: 17
		-- upvalues: Constants (copy)
		return p2 and (p2.productType and p2.productType == Constants.ProductType.CollectibleItem)
	end,
	hasLimitedQuantity = function(p3) -- line: 21
		-- upvalues: GetFFlagIBEnableCollectiblesSystemSupport (copy)
		if not p3 then
			return nil
		end

		local isLimited = p3.isLimited
		local v9 = if not GetFFlagIBEnableCollectiblesSystemSupport() then nil else p3.isLimitedUnique
		local collectibleIsLimited = p3.collectibleIsLimited

		return isLimited or (v9 or collectibleIsLimited)
	end,
	isLimited1Point0 = function(p4) -- line: 34
		if not p4 then
			return nil
		end

		return p4.isLimited or p4.isLimitedUnique
	end,
	isLimited1Point0_LimitedUnique = function(p5) -- line: 43
		if not p5 then
			return nil
		end

		return p5.isLimitedUnique
	end,
	isLimited2Point0_Or_LimitedCollectible = function(p6) -- line: 52
		if not p6 then
			return nil
		end

		return p6.collectibleIsLimited
	end
}

function t1.isUnlimitedCollectibleAsset(s1: string?, p7) -- line: 61
	-- upvalues: t1 (copy), Constants (copy)
	if not s1 or not p7 then
		return nil
	end

	local v16 = t1.hasLimitedQuantity(p7)
	local v17 = p7.productType == Constants.ProductType.CollectibleItem
	local v18 = s1 == Constants.ItemType.Asset

	return not v16 and (v17 and v18)
end
function t1.isLimitedBundle(s2: string?, p8) -- line: 73
	-- upvalues: Constants (copy)
	if not s2 or not p8 then
		return nil
	end

	local collectibleIsLimited = p8.collectibleIsLimited
	local v22 = s2 == Constants.ItemType.Bundle

	return collectibleIsLimited and v22
end
function t1.isUnlimitedCollectibleBundle(s3: string?, p9) -- line: 84
	-- upvalues: Constants (copy)
	if not s3 or not p9 then
		return nil
	end

	local collectibleIsLimited = p9.collectibleIsLimited
	local v26 = p9.productType == Constants.ProductType.CollectibleItem
	local v27 = s3 == Constants.ItemType.Bundle

	return not collectibleIsLimited and (v26 and v27)
end
function t1.isLimitedCollectible(p10) -- line: 96
	-- upvalues: t1 (copy), Constants (copy)
	if not p10 then
		return nil
	end

	local v29 = t1.hasLimitedQuantity(p10)
	local v30 = p10.productType == Constants.ProductType.CollectibleItem

	return v29 and v30
end

return t1
