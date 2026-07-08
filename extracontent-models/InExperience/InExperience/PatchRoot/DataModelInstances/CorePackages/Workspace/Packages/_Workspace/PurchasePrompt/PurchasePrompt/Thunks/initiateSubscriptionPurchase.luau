local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")

require(PurchasePrompt.Promise)

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)
local RequestSubscriptionPurchase = require(PurchasePrompt.Actions.RequestSubscriptionPurchase)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)

require(PurchasePrompt.Network.getPremiumUpsellPrecheck)

local getSubscriptionPurchaseInfo = require(PurchasePrompt.Network.getSubscriptionPurchaseInfo)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local resolveSubscriptionPromptState = require(PurchasePrompt.Thunks.resolveSubscriptionPromptState)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local _ = require(PurchasePromptParent.AppCommonLib).Logging
local Thunk = require(PurchasePrompt.Thunk)
local LoggingProtocol = require(PurchasePromptParent.LoggingProtocol)
local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)
local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)
local t1 = {
	Network,
	ExternalSettings
}

local function initiateSubscriptionPurchase(p1) -- line: 31
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), HttpService (copy), SetPurchaseFlowUUID (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), hasPendingRequest (copy), RequestSubscriptionPurchase (copy), ErrorOccurred (copy), PurchaseError (copy), getSubscriptionPurchaseInfo (copy), resolveSubscriptionPromptState (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 32
		-- upvalues: Network (copy), ExternalSettings (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), HttpService (copy), SetPurchaseFlowUUID (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), hasPendingRequest (copy), RequestSubscriptionPurchase (copy), p1 (copy), ErrorOccurred (copy), PurchaseError (copy), getSubscriptionPurchaseInfo (copy), resolveSubscriptionPromptState (copy)
		local v23 = p3[Network]
		local v24 = p3[ExternalSettings]

		if FFlagEnablePurchaseFlowUUIDMigration then
			local guid = HttpService:GenerateGUID(false)

			p2:dispatch(SetPurchaseFlowUUID(guid))
			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiateSubscriptionPurchase"
			})
		end

		if hasPendingRequest(p2:getState()) then
			return nil
		end

		p2:dispatch(RequestSubscriptionPurchase(p1))

		if v24.getFlagOrder66() then
			p2:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))

			return nil
		end

		return getSubscriptionPurchaseInfo(v23, p1):andThen(function(p4) -- line: 58
			-- upvalues: p2 (copy), resolveSubscriptionPromptState (copy)
			p2:dispatch(resolveSubscriptionPromptState(p4))
		end):catch(function(p5) -- line: 61
			-- upvalues: p2 (copy), ErrorOccurred (copy)
			p2:dispatch(ErrorOccurred(p5))
		end)
	end)
end

return initiateSubscriptionPurchase
