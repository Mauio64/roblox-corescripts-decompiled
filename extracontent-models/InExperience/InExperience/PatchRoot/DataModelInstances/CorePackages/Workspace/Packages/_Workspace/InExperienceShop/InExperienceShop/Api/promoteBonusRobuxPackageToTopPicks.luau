local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local SharedFlags = require(parent.SharedFlags)
require(InExperienceShop.Types)
local findTopPicksSectionIndex = require(InExperienceShop.Utils.findTopPicksSectionIndex)
local FFlagPromoteRobuxInTopPicks = require(InExperienceShop.Flags.FFlagPromoteRobuxInTopPicks)
local FFlagHideBonusInShopWhenNotClaimable = require(InExperienceShop.Flags.FFlagHideBonusInShopWhenNotClaimable)
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local FFlagEnableBonusJwtInShop = SharedFlags.FFlagEnableBonusJwtInShop
local BonusPromotionEligibility = require(InExperienceShop.Api.BonusPromotionEligibility)

local function findFirstBonusRobuxPackageWithPaymentSession(items)
	for _, item in items do
		local robuxPackages = item.robuxPackages

		if robuxPackages == nil then
			continue
		end

		for _, robuxPackage in robuxPackages do
			if robuxPackage.bonusItem ~= nil then
				return robuxPackage, item.paymentSessionId, item.bonusJwt
			end
		end
	end

	return nil, nil, nil
end

local function withoutFeaturedPromotion(p)
	local topPicksSectionIndex = findTopPicksSectionIndex(p)

	if topPicksSectionIndex == nil then
		return p
	end

	local v = p[topPicksSectionIndex]

	if v.featuredRobuxPackage == nil then
		return p
	end

	local clone = table.clone(p)
	clone[topPicksSectionIndex] = {
		id = v.id,
		name = v.name,
		items = v.items,
		categoryType = v.categoryType,
		stableCategoryId = v.stableCategoryId,
		categoryGroup = v.categoryGroup,
		robuxPackages = v.robuxPackages,
		featuredRobuxPackage = nil
	}

	return clone
end

local function getBonusGamePassId(p) -- 1 equivalent call inferred from this helper
	local bonusItem = p.bonusItem

	if bonusItem == nil or bonusItem.type ~= "GamePass" then
		return nil
	end

	return (tostring(bonusItem.id))
end

local function canPromoteBonusPackage(firstBonusRobuxPackageWithPaymentSession, p): boolean -- 1 equivalent call inferred from this helper
	local bonusGamePassId = getBonusGamePassId(firstBonusRobuxPackageWithPaymentSession) -- inferred equivalent call

	if not (bonusGamePassId ~= nil and firstBonusRobuxPackageWithPaymentSession.bonusItemDetails ~= nil) then
		return false
	end

	return p[bonusGamePassId] == BonusPromotionEligibility.Eligible
end

local PromoteBonusRobuxPackageToTopPicks = {}

function PromoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(p)
	local firstBonusRobuxPackageWithPaymentSession, _, _ = findFirstBonusRobuxPackageWithPaymentSession(p)
	return firstBonusRobuxPackageWithPaymentSession
end

PromoteBonusRobuxPackageToTopPicks.getBonusGamePassId = getBonusGamePassId
PromoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion = withoutFeaturedPromotion

function PromoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(p, p2)
	if not (FFlagEnableRobuxInExperienceShop and FFlagPromoteRobuxInTopPicks) then
		return withoutFeaturedPromotion(p)
	end

	local firstBonusRobuxPackageWithPaymentSession, paymentSessionId, bonusJwt = findFirstBonusRobuxPackageWithPaymentSession(p)

	if firstBonusRobuxPackageWithPaymentSession == nil then
		return withoutFeaturedPromotion(p)
	end

	local v

	if paymentSessionId == nil or paymentSessionId == "" then
		v = FFlagEnableBonusJwtInShop

		if v then
			if bonusJwt == nil then
				v = false
			else
				v = bonusJwt ~= ""
			end
		end
	else
		v = true
	end

	if FFlagHideBonusInShopWhenNotClaimable and not v then
		return withoutFeaturedPromotion(p)
	end

	local topPicksSectionIndex = findTopPicksSectionIndex(p)

	if not (topPicksSectionIndex ~= nil and canPromoteBonusPackage(firstBonusRobuxPackageWithPaymentSession, p2)) then -- inferred equivalent call
		return withoutFeaturedPromotion(p)
	end

	local v2 = p[topPicksSectionIndex]
	local featuredRobuxPackage = v2.featuredRobuxPackage

	if featuredRobuxPackage ~= nil and featuredRobuxPackage.id == firstBonusRobuxPackageWithPaymentSession.id then
		local v3 = v2.paymentSessionId == paymentSessionId
		local v4 = not FFlagEnableBonusJwtInShop or v2.bonusJwt == bonusJwt

		if v3 and v4 then
			return p
		end
	end

	local clone = table.clone(p)
	local v3 = {
		id = v2.id,
		name = v2.name,
		items = v2.items,
		categoryType = v2.categoryType,
		stableCategoryId = v2.stableCategoryId,
		categoryGroup = v2.categoryGroup,
		paymentSessionId = v2.paymentSessionId,
		bonusJwt = v2.bonusJwt,
		robuxPackages = v2.robuxPackages,
		featuredRobuxPackage = firstBonusRobuxPackageWithPaymentSession
	}

	if paymentSessionId ~= nil then
		v3.paymentSessionId = paymentSessionId
	end

	if FFlagEnableBonusJwtInShop and bonusJwt ~= nil then
		v3.bonusJwt = bonusJwt
	end

	clone[topPicksSectionIndex] = v3
	return clone
end

return PromoteBonusRobuxPackageToTopPicks
