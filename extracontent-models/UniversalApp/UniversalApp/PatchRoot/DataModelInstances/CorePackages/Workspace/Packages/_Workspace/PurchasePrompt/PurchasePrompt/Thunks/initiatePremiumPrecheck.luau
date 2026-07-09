local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Thunk = require(PurchasePrompt.Thunk)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Analytics = require(PurchasePrompt.Services.Analytics)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PaymentPlatform = require(PurchasePrompt.Enums.PaymentPlatform)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local launchPremiumUpsell = require(PurchasePrompt.Thunks.launchPremiumUpsell)
local checkUserPurchaseSettings = require(PurchasePrompt.Network.checkUserPurchaseSettings)
local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)
local EconomicRestrictionsViolationType = IAPExperience.Enums.EconomicRestrictionsViolationType
local CheckUserPurchaseSettingsFailureReason = IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason
local mapCheckUserPurchaseSettingsFailureReasonToViolationType = IAPExperience.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType
local t1 = {
	Analytics,
	Network,
	ExternalSettings
}

local function handleCheckUserSettingsResult(p1, p2, p3) -- line: 35
	-- upvalues: ErrorOccurred (copy), PurchaseError (copy), mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), launchPremiumUpsell (copy), CheckUserPurchaseSettingsFailureReason (copy), SetPromptState (copy), PromptState (copy), SetEconomicRestrictionError (copy)
	if p1 == nil then
		return p2:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
	end

	local v26 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(p1.failureReason)
	local v27 = v26 ~= EconomicRestrictionsViolationType.None and p1.expirationTimeInMinutes ~= nil

	if (p1.isEligible == nil or p1.failureReason == nil) and not v27 then
		return p2:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
	end

	if p1.isEligible == true then
		return p2:dispatch(launchPremiumUpsell())
	end

	if p1.failureReason == CheckUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
		p3.signalUserSettingEligibilityModal(CheckUserPurchaseSettingsFailureReason.PurchaseNotEnabled)

		return p2:dispatch(SetPromptState(PromptState.EnablePurchaseVPCModal))
	end

	if p1.failureReason == CheckUserPurchaseSettingsFailureReason.SpendLimitExceeded then
		return p2:dispatch(launchPremiumUpsell())
	end

	if v27 then
		p3.signalEconomicRestrictionError(v26, p1.expirationTimeInMinutes)
		p2:dispatch(SetEconomicRestrictionError(v26, p1.expirationTimeInMinutes))

		return p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
	end

	return p2:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
end
local function initiatePremiumPrecheck() -- line: 72
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), Analytics (copy), ExternalSettings (copy), launchPremiumUpsell (copy), getPaymentPlatform (copy), PaymentPlatform (copy), checkUserPurchaseSettings (copy), handleCheckUserSettingsResult (copy), ErrorOccurred (copy), PurchaseError (copy)
	return Thunk.new(script.Name, t1, function(p4, p5) -- line: 73
		-- upvalues: Network (copy), Analytics (copy), ExternalSettings (copy), launchPremiumUpsell (copy), getPaymentPlatform (copy), PaymentPlatform (copy), checkUserPurchaseSettings (copy), handleCheckUserSettingsResult (copy), ErrorOccurred (copy), PurchaseError (copy)
		local v30 = p5[Network]
		local v31 = p5[Analytics]
		local v32 = p5[ExternalSettings]

		if v32.isStudio() then
			return p4:dispatch(launchPremiumUpsell())
		end

		if getPaymentPlatform(v32.getPlatform()) == PaymentPlatform.Web then
			return p4:dispatch(launchPremiumUpsell())
		end

		return checkUserPurchaseSettings(v30):andThen(function(p6) -- line: 90
			-- upvalues: handleCheckUserSettingsResult (copy), p4 (copy), v31 (copy)
			return handleCheckUserSettingsResult(p6, p4, v31)
		end):catch(function(_) -- line: 93
			-- upvalues: p4 (copy), ErrorOccurred (copy), PurchaseError (copy)
			return p4:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end)
	end)
end

return initiatePremiumPrecheck
