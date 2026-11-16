local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")
require(PurchasePrompt.Promise)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)

local RequestSubscriptionPurchase = require(PurchasePrompt.Actions.RequestSubscriptionPurchase)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local getSubscriptionPurchaseInfo = require(PurchasePrompt.Network.getSubscriptionPurchaseInfo)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local resolveSubscriptionPromptState = require(PurchasePrompt.Thunks.resolveSubscriptionPromptState)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local v = require(parent.AppCommonLib)
v = v.Logging
local Thunk = require(PurchasePrompt.Thunk)
local LoggingProtocol = require(parent.LoggingProtocol)

local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)

local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)

local v2 = { Network, ExternalSettings }

local function initiateSubscriptionPurchase(p)
	return Thunk.new(script.Name, v2, function(object, p2)
		local v3 = p2[Network]
		local v4 = p2[ExternalSettings]

		if FFlagEnablePurchaseFlowUUIDMigration then
			object:dispatch(SetPurchaseFlowUUID((HttpService:GenerateGUID(false))))

			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiateSubscriptionPurchase"
			})
		end

		if hasPendingRequest(object:getState()) then
			return nil
		end

		object:dispatch(RequestSubscriptionPurchase(p))

		if not v4.getFlagOrder66() then
			return getSubscriptionPurchaseInfo(v3, p):andThen(function(p3)
				object:dispatch(resolveSubscriptionPromptState(p3))
			end):catch(function(p3)
				object:dispatch(ErrorOccurred(p3))
			end)
		end

		object:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))
		return nil
	end)
end

return initiateSubscriptionPurchase
