local HttpService = game:GetService("HttpService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Promise = require(PurchasePrompt.Promise)
local Thunk = require(PurchasePrompt.Thunk)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)
local RequestPremiumPurchase = require(PurchasePrompt.Actions.RequestPremiumPurchase)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local getPremiumUpsellPrecheck = require(PurchasePrompt.Network.getPremiumUpsellPrecheck)
local getPremiumProductInfo = require(PurchasePrompt.Network.getPremiumProductInfo)
local getAccountInfo = require(PurchasePrompt.Network.getAccountInfo)
local getBalanceInfo = require(PurchasePrompt.Network.getBalanceInfo)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local resolvePremiumPromptState = require(PurchasePrompt.Thunks.resolvePremiumPromptState)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local _ = require(PurchasePromptParent.AppCommonLib).Logging
local LoggingProtocol = require(PurchasePromptParent.LoggingProtocol)
local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)
local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)
local t1 = {
	Network,
	ExternalSettings
}

local function initiatePremiumPurchase(_, _, _) -- line: 33
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), HttpService (copy), SetPurchaseFlowUUID (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), hasPendingRequest (copy), RequestPremiumPurchase (copy), ErrorOccurred (copy), PurchaseError (copy), Promise (copy), getPremiumUpsellPrecheck (copy), getPremiumProductInfo (copy), getAccountInfo (copy), getBalanceInfo (copy), resolvePremiumPromptState (copy)
	return Thunk.new(script.Name, t1, function(p4, p5) -- line: 34
		-- upvalues: Network (copy), ExternalSettings (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), HttpService (copy), SetPurchaseFlowUUID (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), hasPendingRequest (copy), RequestPremiumPurchase (copy), ErrorOccurred (copy), PurchaseError (copy), Promise (copy), getPremiumUpsellPrecheck (copy), getPremiumProductInfo (copy), getAccountInfo (copy), getBalanceInfo (copy), resolvePremiumPromptState (copy)
		local v29 = p5[Network]
		local v30 = p5[ExternalSettings]

		if FFlagEnablePurchaseFlowUUIDMigration then
			local guid = HttpService:GenerateGUID(false)

			p4:dispatch(SetPurchaseFlowUUID(guid))
			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiatePremiumPurchase"
			})
		end

		if hasPendingRequest(p4:getState()) then
			return nil
		end

		p4:dispatch(RequestPremiumPurchase())

		if v30.getFlagOrder66() then
			p4:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))

			return nil
		end

		local v32 = v30.isStudio()

		return Promise.all({
			canShowUpsell = not v32 and getPremiumUpsellPrecheck(v29) or Promise.resolve(true),
			premiumProductInfo = getPremiumProductInfo(v29),
			accountInfo = getAccountInfo(v29, v30),
			balanceInfo = getBalanceInfo(v29, v30, false)
		}):andThen(function(p6) -- line: 66
			-- upvalues: p4 (copy), resolvePremiumPromptState (copy)
			p4:dispatch(resolvePremiumPromptState(p6.accountInfo, p6.balanceInfo, p6.premiumProductInfo, p6.canShowUpsell))
		end):catch(function(p7) -- line: 76
			-- upvalues: p4 (copy), ErrorOccurred (copy)
			p4:dispatch(ErrorOccurred(p7))
		end)
	end)
end

return initiatePremiumPurchase
