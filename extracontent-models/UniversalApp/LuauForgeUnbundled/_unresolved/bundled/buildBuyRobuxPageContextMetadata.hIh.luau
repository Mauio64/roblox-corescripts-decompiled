local v5 = {}

local function buildBuyRobuxPageContextMetadata(p2, p3)
	local v6 = p2 or v5
	local analytics = v6.analytics or v5
	return {
		applePayAvailability = "",
		ctx = "",
		limitedTimeBonusItemIds = analytics.limited_time_bonus_item_ids or "",
		paymentSessionId = v6.payment_session_id or "",
		personalizedBonusItem = analytics.personalized_bonus_item or "",
		robuxBalance = p3 == nil and "" or p3,
		robuxPackageIds = analytics.robux_package_ids or "",
		sectionNames = analytics.section_names or "",
		subscriptionProductIds = analytics.subscription_product_ids or ""
	}
end

return buildBuyRobuxPageContextMetadata
