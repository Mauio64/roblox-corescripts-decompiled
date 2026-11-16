local IAPExperience = script:FindFirstAncestor("IAPExperience")
local EconomicRestrictionsViolationType = require(IAPExperience.Enums.EconomicRestrictionsViolationType)

local logger = require(IAPExperience.Utility.logger)

return function(data, violationType)
	if violationType == EconomicRestrictionsViolationType.Chargeback then
		return data.chargebackViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.AbuseOfAffiliateSystem then
		return data.fraudAbuseOfAffiliateSystemViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse then
		return data.fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.PaymentAuthorizationAttempt then
		return data.fraudPaymentAbuseViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.RepeatedRefundRequests then
		return data.fraudRepeatedRefundRequestsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.SuspiciousAccountPatterns then
		return data.fraudSuspiciousAccountPatternsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.SuspiciousRefundRequests then
		return data.fraudSuspiciousRefundRequestsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.UnauthorizedPurchase then
		return data.fraudUnauthorizedPurchaseViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions then
		return data.fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.VirtualEconomyAbuse then
		return data.fraudVirtualEconomyAbuseViolationLabel
	end

	logger.error({ message = "Invalid violation type", violationType = violationType })

	return ""
end
