local v5 = {
	FraudPaymentAuthorizationAttempt = "Feature.NotApproved.Label.Sublabel.FraudPaymentAbuse",
	FraudVirtualEconomyAbuse = "Feature.NotApproved.Label.Sublabel.FraudVirtualEconomyAbuse",
	FraudAbuseOfAffiliateSystem = "Feature.NotApproved.Label.Sublabel.FraudAbuseOfTheAffiliateSystem",
	FraudAttemptedUnauthorizedPaymentMethodUse = "Feature.NotApproved.Label.Sublabel.FraudAttemptedUnauthorizedPaymentMethodUse",
	FraudRepeatedRefundRequests = "Feature.NotApproved.Label.Sublabel.FraudRepeatedRefundRequests",
	FraudSuspiciousRefundRequests = "Feature.NotApproved.Label.Sublabel.FraudSuspiciousRefundRequests",
	FraudUnauthorizedPurchase = "Feature.NotApproved.Label.Sublabel.FraudUnauthorizedPurchase",
	FraudUseOfUnauthorizedOffPlatformTransactions = "Feature.NotApproved.Label.Sublabel.FraudUseOfUnauthorizedOffPlatformTransactions",
	FraudUseOfUnauthorizedPaymentMethod = "Feature.NotApproved.Label.Sublabel.FraudUseOfUnauthorizedPaymentMethod",
	FraudSuspiciousAccountPatterns = "Feature.NotApproved.Label.Sublabel.FraudSuspiciousAccountPatterns",
	FraudChargeback = "Feature.NotApproved.Label.AbuseType.Chargeback",
	None = "",
	PurchaseNotEnabled = "",
	SpendLimitExceeded = ""
}

local function formatEconomicRestriction(object, p2, p3)
	local v6 = v5[p3] or "Feature.NotApproved.Label.Sublabel.FraudPaymentAbuse"
	local v7 = v6 == "" and "" or object:Format(v6)

	local v8 = math.ceil(p2 / 60)

	if v8 > 24 then
		return object:Format("IAPExperience.PurchaseError.Text.EconomicRestrictionsDays", {
			day = math.ceil(v8 / 24),
			violation = v7
		})
	end

	return object:Format("IAPExperience.PurchaseError.Text.EconomicRestrictionsHours", {
		hour = v8,
		violation = v7
	})
end

return formatEconomicRestriction
