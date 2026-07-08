local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
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
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local isErrorReasonPrefixWithEconomicRestrictions = IAPExperience.Utility.isErrorReasonPrefixWithEconomicRestrictions
local parseErrorReasonToEconomicRestriction = IAPExperience.Utility.parseErrorReasonToEconomicRestriction
local t1 = {
	ExternalSettings,
	Network
}

local function launchSubscriptionPurchase(p1) -- line: 23
	-- upvalues: Thunk (copy), t1 (copy), ExternalSettings (copy), Network (copy), PurchaseCompleteRecieved (copy), hideWindow (copy), performSubscriptionPurchase (copy), isErrorReasonPrefixWithEconomicRestrictions (copy), parseErrorReasonToEconomicRestriction (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), SetPromptState (copy), PromptState (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 24
		-- upvalues: ExternalSettings (copy), Network (copy), PurchaseCompleteRecieved (copy), hideWindow (copy), performSubscriptionPurchase (copy), p1 (copy), isErrorReasonPrefixWithEconomicRestrictions (copy), parseErrorReasonToEconomicRestriction (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), SetPromptState (copy), PromptState (copy)
		local v22 = p3[ExternalSettings]
		local v23 = p3[Network]

		if v22.isStudio() then
			p2:dispatch(PurchaseCompleteRecieved())
			p2:dispatch(hideWindow())

			return nil
		end

		performSubscriptionPurchase(v23, p2:getState().promptRequest.id, p1):catch(function(p4) -- line: 35
			-- upvalues: isErrorReasonPrefixWithEconomicRestrictions (copy), parseErrorReasonToEconomicRestriction (copy), p2 (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy)
			if isErrorReasonPrefixWithEconomicRestrictions(p4) then
				local v25 = parseErrorReasonToEconomicRestriction(p4)

				p2:dispatch(SetEconomicRestrictionError(v25.violationType, v25.timeoutMinutes))
				p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))

				return
			end

			p2:dispatch(ErrorOccurred(p4))
		end)
		p2:dispatch(SetPromptState(PromptState.UpsellInProgress))
		p2:dispatch(hideWindow())

		return nil
	end)
end

return launchSubscriptionPurchase
