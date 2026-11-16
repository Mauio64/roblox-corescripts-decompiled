local CheckUserPurchaseSettingsFailureReason = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/CheckUserPurchaseSettingsFailureReason")

local EconomicRestrictionsViolationType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/EconomicRestrictionsViolationType")

return function(p2)
	if p2 == CheckUserPurchaseSettingsFailureReason.Chargeback then
		return EconomicRestrictionsViolationType.Chargeback
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.AbuseOfAffiliateSystem then
		return EconomicRestrictionsViolationType.AbuseOfAffiliateSystem
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.AttemptedUnauthorizedPaymentMethodUse then
		return EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.PaymentAuthorizationAttempt then
		return EconomicRestrictionsViolationType.PaymentAuthorizationAttempt
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.RepeatedRefundRequests then
		return EconomicRestrictionsViolationType.RepeatedRefundRequests
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.SuspiciousAccountPatterns then
		return EconomicRestrictionsViolationType.SuspiciousAccountPatterns
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.SuspiciousRefundRequests then
		return EconomicRestrictionsViolationType.SuspiciousRefundRequests
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.UnauthorizedPurchase then
		return EconomicRestrictionsViolationType.UnauthorizedPurchase
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.UseOfUnauthorizedOffPlatformTransactions then
		return EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions
	end

	if p2 == CheckUserPurchaseSettingsFailureReason.VirtualEconomyAbuse then
		return EconomicRestrictionsViolationType.VirtualEconomyAbuse
	end

	return EconomicRestrictionsViolationType.None
end
