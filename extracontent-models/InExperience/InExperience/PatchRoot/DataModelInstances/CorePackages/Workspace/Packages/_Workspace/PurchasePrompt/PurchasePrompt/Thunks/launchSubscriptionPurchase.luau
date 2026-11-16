local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)
local PurchaseCompleteRecieved = require(PurchasePrompt.Actions.PurchaseCompleteRecieved)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local performSubscriptionPurchase = require(PurchasePrompt.Network.performSubscriptionPurchase)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Network = require(PurchasePrompt.Services.Network)
local Thunk = require(PurchasePrompt.Thunk)
local hideWindow = require(PurchasePrompt.Thunks.hideWindow)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local IAPExperience = require(parent.IAPExperience)
local isErrorReasonPrefixWithEconomicRestrictions = IAPExperience.Utility.isErrorReasonPrefixWithEconomicRestrictions
local parseErrorReasonToEconomicRestriction = IAPExperience.Utility.parseErrorReasonToEconomicRestriction

local v = { ExternalSettings, Network }

local function launchSubscriptionPurchase(p)
	return Thunk.new(script.Name, v, function(object, p2): nil
		local v2 = p2[ExternalSettings]
		local v3 = p2[Network]

		if v2.isStudio() then
			object:dispatch(PurchaseCompleteRecieved())
		else
			performSubscriptionPurchase(v3, object:getState().promptRequest.id, p):catch(function(p3)
				if not isErrorReasonPrefixWithEconomicRestrictions(p3) then
					object:dispatch(ErrorOccurred(p3))

					return
				end

				local v4 = parseErrorReasonToEconomicRestriction(p3)
				object:dispatch(SetEconomicRestrictionError(v4.violationType, v4.timeoutMinutes))

				object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
			end)

			object:dispatch(SetPromptState(PromptState.UpsellInProgress))
		end

		object:dispatch(hideWindow())
		return nil
	end)
end

return launchSubscriptionPurchase
