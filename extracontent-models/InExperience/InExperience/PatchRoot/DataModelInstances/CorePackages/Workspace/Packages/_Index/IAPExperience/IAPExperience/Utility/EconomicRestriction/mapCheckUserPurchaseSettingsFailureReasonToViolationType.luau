local IAPExperience = script:FindFirstAncestor("IAPExperience")
local CheckUserPurchaseSettingsFailureReason = require(IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason)

local EconomicRestrictionsViolationType = require(IAPExperience.Enums.EconomicRestrictionsViolationType)

return function(p)
	if p == CheckUserPurchaseSettingsFailureReason.Chargeback then
		return EconomicRestrictionsViolationType.Chargeback
	end

	if p == CheckUserPurchaseSettingsFailureReason.AbuseOfAffiliateSystem then
		return EconomicRestrictionsViolationType.AbuseOfAffiliateSystem
	end

	if p == CheckUserPurchaseSettingsFailureReason.AttemptedUnauthorizedPaymentMethodUse then
		return EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse
	end

	if p == CheckUserPurchaseSettingsFailureReason.PaymentAuthorizationAttempt then
		return EconomicRestrictionsViolationType.PaymentAuthorizationAttempt
	end

	if p == CheckUserPurchaseSettingsFailureReason.RepeatedRefundRequests then
		return EconomicRestrictionsViolationType.RepeatedRefundRequests
	end

	if p == CheckUserPurchaseSettingsFailureReason.SuspiciousAccountPatterns then
		return EconomicRestrictionsViolationType.SuspiciousAccountPatterns
	end

	if p == CheckUserPurchaseSettingsFailureReason.SuspiciousRefundRequests then
		return EconomicRestrictionsViolationType.SuspiciousRefundRequests
	end

	if p == CheckUserPurchaseSettingsFailureReason.UnauthorizedPurchase then
		return EconomicRestrictionsViolationType.UnauthorizedPurchase
	end

	if p == CheckUserPurchaseSettingsFailureReason.UseOfUnauthorizedOffPlatformTransactions then
		return EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions
	end

	if p == CheckUserPurchaseSettingsFailureReason.VirtualEconomyAbuse then
		return EconomicRestrictionsViolationType.VirtualEconomyAbuse
	end

	return EconomicRestrictionsViolationType.None
end
