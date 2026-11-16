local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local SetEconomicRestrictionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetEconomicRestrictionError")
local PurchaseCompleteRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PurchaseCompleteRecieved")
local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local performSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performSubscriptionPurchase")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local hideWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/hideWindow")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local isErrorReasonPrefixWithEconomicRestrictions = IAPExperience.Utility.isErrorReasonPrefixWithEconomicRestrictions
local parseErrorReasonToEconomicRestriction = IAPExperience.Utility.parseErrorReasonToEconomicRestriction

local v5 = { ExternalSettings, Network }

local function launchSubscriptionPurchase(p2)
	return Thunk.new("launchSubscriptionPurchase", v5, function(object, p3): nil
		local v6 = p3[ExternalSettings]
		local v7 = p3[Network]

		if v6.isStudio() then
			object:dispatch(PurchaseCompleteRecieved())
		else
			performSubscriptionPurchase(v7, object:getState().promptRequest.id, p2):catch(function(p4)
				if not isErrorReasonPrefixWithEconomicRestrictions(p4) then
					object:dispatch(ErrorOccurred(p4))

					return
				end

				local v8 = parseErrorReasonToEconomicRestriction(p4)
				object:dispatch(SetEconomicRestrictionError(v8.violationType, v8.timeoutMinutes))

				object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
			end)

			object:dispatch(SetPromptState(PromptState.UpsellInProgress))
		end

		object:dispatch(hideWindow())
		return nil
	end)
end

return launchSubscriptionPurchase
