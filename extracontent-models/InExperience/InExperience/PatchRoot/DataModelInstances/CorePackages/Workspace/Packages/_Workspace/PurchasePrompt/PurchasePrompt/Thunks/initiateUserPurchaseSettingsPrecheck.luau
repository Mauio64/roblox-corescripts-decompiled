local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

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

local IAPExperience = require(parent.IAPExperience)
local CheckUserPurchaseSettingsFailureReason = IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason

local mapCheckUserPurchaseSettingsFailureReasonToViolationType = IAPExperience.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType
local EconomicRestrictionsViolationType = IAPExperience.Enums.EconomicRestrictionsViolationType

local v = { Analytics, Network, ExternalSettings }

local function validateResult(data): boolean -- 1 equivalent call inferred from this helper
	if data == nil then
		return false
	end

	local v2 = data.isEligible == nil or data.failureReason == nil
	local v3

	if mapCheckUserPurchaseSettingsFailureReasonToViolationType(data.failureReason) == EconomicRestrictionsViolationType.None then
		v3 = false
	else
		v3 = data.expirationTimeInMinutes ~= nil
	end

	return not (v2 and not v3)
end

local function initiateUserPurchaseSettingsPrecheck()
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[Network]
		local v3 = p[Analytics]
		local v4 = p[ExternalSettings]

		if v4.isStudio() or getUpsellFlow(v4.getPlatform()) == UpsellFlow.Web then
			return object:dispatch(initiatePurchasePrecheck())
		end

		return checkUserPurchaseSettings(v2):andThen(function(data)
			if validateResult(data) == false then -- inferred equivalent call
				return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end

			if data.isEligible == true then
				return object:dispatch(initiatePurchasePrecheck())
			end

			local v5 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(data.failureReason)

			local v6 = v5 ~= EconomicRestrictionsViolationType.None

			if data.failureReason == CheckUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
				v3.signalUserSettingEligibilityModal("PurchaseNotEnabled")
				return object:dispatch(SetPromptState(PromptState.EnablePurchaseVPCModal))
			end

			if data.failureReason == CheckUserPurchaseSettingsFailureReason.SpendLimitExceeded then
				return object:dispatch(initiatePurchasePrecheck())
			end

			if not v6 or data.expirationTimeInMinutes == nil then
				return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end

			v3.signalEconomicRestrictionError(v5, data.expirationTimeInMinutes)

			object:dispatch(SetEconomicRestrictionError(v5, data.expirationTimeInMinutes))

			return object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
		end):catch(function(_)
			return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end)
	end)
end

return initiateUserPurchaseSettingsPrecheck
