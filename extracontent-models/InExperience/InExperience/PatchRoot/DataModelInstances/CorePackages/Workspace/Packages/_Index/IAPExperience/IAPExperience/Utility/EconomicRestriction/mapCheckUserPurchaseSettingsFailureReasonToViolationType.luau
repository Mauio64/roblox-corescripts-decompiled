local IAPExperience = script:FindFirstAncestor("IAPExperience")
local CheckUserPurchaseSettingsFailureReason = require(IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason)
local EconomicRestrictionsViolationType = require(IAPExperience.Enums.EconomicRestrictionsViolationType)

return function(p1) -- line: 7
	-- upvalues: CheckUserPurchaseSettingsFailureReason (copy), EconomicRestrictionsViolationType (copy)
	if p1 == CheckUserPurchaseSettingsFailureReason.Chargeback then
		return EconomicRestrictionsViolationType.Chargeback
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.AbuseOfAffiliateSystem then
		return EconomicRestrictionsViolationType.AbuseOfAffiliateSystem
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.AttemptedUnauthorizedPaymentMethodUse then
		return EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.PaymentAuthorizationAttempt then
		return EconomicRestrictionsViolationType.PaymentAuthorizationAttempt
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.RepeatedRefundRequests then
		return EconomicRestrictionsViolationType.RepeatedRefundRequests
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.SuspiciousAccountPatterns then
		return EconomicRestrictionsViolationType.SuspiciousAccountPatterns
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.SuspiciousRefundRequests then
		return EconomicRestrictionsViolationType.SuspiciousRefundRequests
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.UnauthorizedPurchase then
		return EconomicRestrictionsViolationType.UnauthorizedPurchase
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.UseOfUnauthorizedOffPlatformTransactions then
		return EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions
	end

	if p1 == CheckUserPurchaseSettingsFailureReason.VirtualEconomyAbuse then
		return EconomicRestrictionsViolationType.VirtualEconomyAbuse
	end

	return EconomicRestrictionsViolationType.None
end
