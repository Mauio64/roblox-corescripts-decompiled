local EconomicRestrictionsViolationType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/EconomicRestrictionsViolationType")

local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")

return function(data, p2)
	if p2 == EconomicRestrictionsViolationType.Chargeback then
		return data.chargebackViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.AbuseOfAffiliateSystem then
		return data.fraudAbuseOfAffiliateSystemViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse then
		return data.fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.PaymentAuthorizationAttempt then
		return data.fraudPaymentAbuseViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.RepeatedRefundRequests then
		return data.fraudRepeatedRefundRequestsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.SuspiciousAccountPatterns then
		return data.fraudSuspiciousAccountPatternsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.SuspiciousRefundRequests then
		return data.fraudSuspiciousRefundRequestsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.UnauthorizedPurchase then
		return data.fraudUnauthorizedPurchaseViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions then
		return data.fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.VirtualEconomyAbuse then
		return data.fraudVirtualEconomyAbuseViolationLabel
	end

	logger.error({ message = "Invalid violation type", violationType = p2 })

	return ""
end
