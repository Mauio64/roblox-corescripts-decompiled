local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local SharedFlags = require(InExperienceShopParent.SharedFlags)

require(InExperienceShop.Types)

local FFlagPromoteRobuxInTopPicks = require(InExperienceShop.Flags.FFlagPromoteRobuxInTopPicks)
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local BonusPromotionEligibility = require(InExperienceShop.Api.BonusPromotionEligibility)

local function findFirstBonusRobuxPackageWithPaymentSession(t1: {[any]: any}) -- line: 17
	for _, v13 in t1 do
		local robuxPackages = v13.robuxPackages

		if robuxPackages ~= nil then
			for _, v16 in robuxPackages do
				if v16.bonusItem ~= nil then
					return v16, v13.paymentSessionId
				end
			end
		end
	end

	return nil, nil
end
local function findTopPicksSectionIndex(t2: {[any]: any}) -- line: 37
	for v21, v22 in t2 do
		if string.lower(v22.name) == "top picks" then
			return v21
		end
	end

	return nil
end
local function withoutFeaturedPromotion(t3: {[any]: any}) -- line: 46
	local g27 = nil
	local v26 = nil

	for v24, v25 in t3 do
		if string.lower(v25.name) == "top picks" then
			v26 = v24
			g27 = true
		end

		if g27 then
			break
		end
	end

	if not g27 then
		v26 = nil
	end

	g27 = false

	if v26 == nil then
		return t3
	end

	local v28 = t3[v26]

	if v28.featuredRobuxPackage == nil then
		return t3
	end

	local v29 = table.clone(t3)

	v29[v26] = {
		featuredRobuxPackage = nil,
		id = v28.id,
		name = v28.name,
		items = v28.items,
		robuxPackages = v28.robuxPackages
	}

	return v29
end
local function canPromoteBonusPackage(p1, t4: {[any]: any}) -- line: 76
	-- upvalues: BonusPromotionEligibility (copy)
	local bonusItem = p1.bonusItem
	local v35 = if bonusItem ~= nil and bonusItem.type == "GamePass" then tostring(bonusItem.id) else nil

	if v35 == nil then
		return false
	end

	if p1.bonusItemDetails == nil then
		return false
	end

	return t4[v35] == BonusPromotionEligibility.Eligible
end

return {
	findFirstBonusRobuxPackage = function(t5: {[any]: any}) -- line: 32
		-- upvalues: findFirstBonusRobuxPackageWithPaymentSession (copy)
		local v18, _ = findFirstBonusRobuxPackageWithPaymentSession(t5)

		return v18
	end,
	getBonusGamePassId = function(p2) -- line: 68
		local bonusItem = p2.bonusItem

		if bonusItem == nil or bonusItem.type ~= "GamePass" then
			return nil
		end

		return (tostring(bonusItem.id))
	end,
	withoutFeaturedPromotion = withoutFeaturedPromotion,
	promoteBonusRobuxPackageToTopPicks = function(t6: {[any]: any}, t7: {[any]: any}) -- line: 99
		-- upvalues: FFlagEnableRobuxInExperienceShop (copy), FFlagPromoteRobuxInTopPicks (copy), withoutFeaturedPromotion (copy), findFirstBonusRobuxPackageWithPaymentSession (copy), BonusPromotionEligibility (copy)
		if not FFlagEnableRobuxInExperienceShop or not FFlagPromoteRobuxInTopPicks then
			return (withoutFeaturedPromotion(t6))
		end

		local v38, v39 = findFirstBonusRobuxPackageWithPaymentSession(t6)

		if v38 == nil then
			return (withoutFeaturedPromotion(t6))
		end

		local g43 = nil
		local v42 = nil

		for v40, v41 in t6 do
			if string.lower(v41.name) == "top picks" then
				v42 = v40
				g43 = true
			end

			if g43 then
				break
			end
		end

		if not g43 then
			v42 = nil
		end

		g43 = false

		if v42 == nil then
			return (withoutFeaturedPromotion(t6))
		end

		local bonusItem = v38.bonusItem
		local v45 = if bonusItem ~= nil and bonusItem.type == "GamePass" then tostring(bonusItem.id) else nil

		if v45 == nil or (v38.bonusItemDetails == nil or t7[v45] ~= BonusPromotionEligibility.Eligible) then
			return (withoutFeaturedPromotion(t6))
		end

		local v46 = t6[v42]
		local featuredRobuxPackage = v46.featuredRobuxPackage

		if featuredRobuxPackage ~= nil and featuredRobuxPackage.id == v38.id and v39 == v46.paymentSessionId then
			return t6
		end

		local v48 = table.clone(t6)
		local t8 = {
			id = v46.id,
			name = v46.name,
			items = v46.items,
			paymentSessionId = v46.paymentSessionId,
			robuxPackages = v46.robuxPackages,
			featuredRobuxPackage = v38
		}

		if v39 ~= nil then
			t8.paymentSessionId = v39
		end

		v48[v42] = t8

		return v48
	end
}
