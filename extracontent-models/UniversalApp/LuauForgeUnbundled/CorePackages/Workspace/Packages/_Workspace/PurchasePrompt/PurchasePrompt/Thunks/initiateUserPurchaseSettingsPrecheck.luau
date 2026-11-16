local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local checkUserPurchaseSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/checkUserPurchaseSettings")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local SetEconomicRestrictionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetEconomicRestrictionError")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local initiatePurchasePrecheck = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiatePurchasePrecheck")

local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local checkUserPurchaseSettingsFailureReason = IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason

local mapCheckUserPurchaseSettingsFailureReasonToViolationType = IAPExperience.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType
local economicRestrictionsViolationType = IAPExperience.Enums.EconomicRestrictionsViolationType

local v5 = { Analytics, Network, ExternalSettings }

local function validateResult(data): boolean
	if data == nil then
		return false
	end

	local v6 = data.isEligible == nil or data.failureReason == nil
	local v7

	if mapCheckUserPurchaseSettingsFailureReasonToViolationType(data.failureReason) == economicRestrictionsViolationType.None then
		v7 = false
	else
		v7 = data.expirationTimeInMinutes ~= nil
	end

	if v6 and not v7 then
		return false
	end

	return true
end

local function initiateUserPurchaseSettingsPrecheck()
	return Thunk.new("initiateUserPurchaseSettingsPrecheck", v5, function(object, p2)
		local v6 = p2[Network]
		local v7 = p2[Analytics]
		local v8 = p2[ExternalSettings]

		if v8.isStudio() or getUpsellFlow(v8.getPlatform()) == UpsellFlow.Web then
			return object:dispatch(initiatePurchasePrecheck())
		end

		return checkUserPurchaseSettings(v6):andThen(function(data)
			local v9

			if data == nil then
				v9 = false
			else
				local v10 = data.isEligible == nil or data.failureReason == nil

				local v11 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(data.failureReason) ~= economicRestrictionsViolationType.None
					and data.expirationTimeInMinutes ~= nil
				v9 = (not v10 or v11) and true or false
			end

			if v9 == false then
				return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end

			if data.isEligible == true then
				return object:dispatch(initiatePurchasePrecheck())
			end

			local v10 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(data.failureReason)

			local v11 = v10 ~= economicRestrictionsViolationType.None

			if data.failureReason == checkUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
				v7.signalUserSettingEligibilityModal("PurchaseNotEnabled")
				return object:dispatch(SetPromptState(PromptState.EnablePurchaseVPCModal))
			end

			if data.failureReason == checkUserPurchaseSettingsFailureReason.SpendLimitExceeded then
				return object:dispatch(initiatePurchasePrecheck())
			end

			if not v11 or data.expirationTimeInMinutes == nil then
				return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end

			v7.signalEconomicRestrictionError(v10, data.expirationTimeInMinutes)

			object:dispatch(SetEconomicRestrictionError(v10, data.expirationTimeInMinutes))

			return object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
		end):catch(function(p3)
			return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end)
	end)
end

return initiateUserPurchaseSettingsPrecheck
