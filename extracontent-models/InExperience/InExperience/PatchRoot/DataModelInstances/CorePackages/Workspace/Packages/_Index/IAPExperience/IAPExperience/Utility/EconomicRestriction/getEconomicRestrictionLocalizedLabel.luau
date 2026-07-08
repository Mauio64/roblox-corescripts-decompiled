local IAPExperience = script:FindFirstAncestor("IAPExperience")
local EconomicRestrictionsViolationType = require(IAPExperience.Enums.EconomicRestrictionsViolationType)
local logger = require(IAPExperience.Utility.logger)

return function(t1: {[any]: any}, p1) -- line: 9
	-- upvalues: EconomicRestrictionsViolationType (copy), logger (copy)
	if p1 == EconomicRestrictionsViolationType.Chargeback then
		return t1.chargebackViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.AbuseOfAffiliateSystem then
		return t1.fraudAbuseOfAffiliateSystemViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse then
		return t1.fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.PaymentAuthorizationAttempt then
		return t1.fraudPaymentAbuseViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.RepeatedRefundRequests then
		return t1.fraudRepeatedRefundRequestsViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.SuspiciousAccountPatterns then
		return t1.fraudSuspiciousAccountPatternsViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.SuspiciousRefundRequests then
		return t1.fraudSuspiciousRefundRequestsViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.UnauthorizedPurchase then
		return t1.fraudUnauthorizedPurchaseViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions then
		return t1.fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel
	end

	if p1 == EconomicRestrictionsViolationType.VirtualEconomyAbuse then
		return t1.fraudVirtualEconomyAbuseViolationLabel
	end

	logger.error({
		message = "Invalid violation type",
		violationType = p1
	})

	return ""
end
