local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local Network = require(PurchasePrompt.Services.Network)
local checkUserPurchaseSettings = require(PurchasePrompt.Network.checkUserPurchaseSettings)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local Analytics = require(PurchasePrompt.Services.Analytics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Thunk = require(PurchasePrompt.Thunk)
local initiatePurchasePrecheck = require(PurchasePrompt.Thunks.initiatePurchasePrecheck)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local CheckUserPurchaseSettingsFailureReason = IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason
local mapCheckUserPurchaseSettingsFailureReasonToViolationType = IAPExperience.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType
local EconomicRestrictionsViolationType = IAPExperience.Enums.EconomicRestrictionsViolationType
local t1 = {
	Analytics,
	Network,
	ExternalSettings
}

local function validateResult(p1) -- line: 32
	-- upvalues: mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy)
	if p1 == nil then
		return false
	end

	local v24 = p1.isEligible == nil or p1.failureReason == nil
	local v25 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(p1.failureReason) ~= EconomicRestrictionsViolationType.None and p1.expirationTimeInMinutes ~= nil

	if v24 and not v25 then
		return false
	end

	return true
end
local function initiateUserPurchaseSettingsPrecheck() -- line: 55
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), Analytics (copy), ExternalSettings (copy), initiatePurchasePrecheck (copy), getUpsellFlow (copy), UpsellFlow (copy), checkUserPurchaseSettings (copy), mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), ErrorOccurred (copy), PurchaseError (copy), CheckUserPurchaseSettingsFailureReason (copy), SetPromptState (copy), PromptState (copy), SetEconomicRestrictionError (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 56
		-- upvalues: Network (copy), Analytics (copy), ExternalSettings (copy), initiatePurchasePrecheck (copy), getUpsellFlow (copy), UpsellFlow (copy), checkUserPurchaseSettings (copy), mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), ErrorOccurred (copy), PurchaseError (copy), CheckUserPurchaseSettingsFailureReason (copy), SetPromptState (copy), PromptState (copy), SetEconomicRestrictionError (copy)
		local v28 = p3[Network]
		local v29 = p3[Analytics]
		local v30 = p3[ExternalSettings]

		if v30.isStudio() then
			return p2:dispatch(initiatePurchasePrecheck())
		end

		if getUpsellFlow(v30.getPlatform()) == UpsellFlow.Web then
			return p2:dispatch(initiatePurchasePrecheck())
		end

		return checkUserPurchaseSettings(v28):andThen(function(p4) -- line: 75
			-- upvalues: mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), p2 (copy), ErrorOccurred (copy), PurchaseError (copy), initiatePurchasePrecheck (copy), CheckUserPurchaseSettingsFailureReason (copy), v29 (copy), SetPromptState (copy), PromptState (copy), SetEconomicRestrictionError (copy)
			local v32

			if p4 == nil then
				v32 = false
			else
				local v33 = p4.isEligible == nil or p4.failureReason == nil
				local v34 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(p4.failureReason) ~= EconomicRestrictionsViolationType.None and p4.expirationTimeInMinutes ~= nil

				v32 = not v33 or (v34 and true or false)
			end

			if v32 == false then
				return p2:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end

			if p4.isEligible == true then
				return p2:dispatch(initiatePurchasePrecheck())
			end

			local v35 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(p4.failureReason)
			local v36 = v35 ~= EconomicRestrictionsViolationType.None

			if p4.failureReason == CheckUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
				v29.signalUserSettingEligibilityModal("PurchaseNotEnabled")

				return p2:dispatch(SetPromptState(PromptState.EnablePurchaseVPCModal))
			end

			if p4.failureReason == CheckUserPurchaseSettingsFailureReason.SpendLimitExceeded then
				return p2:dispatch(initiatePurchasePrecheck())
			end

			if v36 and p4.expirationTimeInMinutes ~= nil then
				v29.signalEconomicRestrictionError(v35, p4.expirationTimeInMinutes)
				p2:dispatch(SetEconomicRestrictionError(v35, p4.expirationTimeInMinutes))

				return p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
			end

			return p2:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end):catch(function(_) -- line: 116
			-- upvalues: p2 (copy), ErrorOccurred (copy), PurchaseError (copy)
			return p2:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end)
	end)
end

return initiateUserPurchaseSettingsPrecheck
