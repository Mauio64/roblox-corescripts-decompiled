local HttpService = game:GetService("HttpService")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local SetPurchaseFlowUUID = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlowUUID")

local RequestSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestSubscriptionPurchase")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local getSubscriptionPurchaseInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getSubscriptionPurchaseInfo")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local resolveSubscriptionPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/resolveSubscriptionPromptState")
local hasPendingRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/hasPendingRequest")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").Logging
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")

local FFlagEnablePurchaseFlowUUIDMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePurchaseFlowUUIDMigration")

local PurchaseFlowUUIDTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/PurchaseFlowUUIDTelemetry")

local v5 = { Network, ExternalSettings }

local function initiateSubscriptionPurchase(p2)
	return Thunk.new("initiateSubscriptionPurchase", v5, function(object, p3)
		local v6 = p3[Network]
		local v7 = p3[ExternalSettings]

		if FFlagEnablePurchaseFlowUUIDMigration then
			object:dispatch(SetPurchaseFlowUUID((HttpService:GenerateGUID(false))))

			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiateSubscriptionPurchase"
			})
		end

		if hasPendingRequest(object:getState()) then
			return nil
		end

		object:dispatch(RequestSubscriptionPurchase(p2))

		if not v7.getFlagOrder66() then
			return getSubscriptionPurchaseInfo(v6, p2):andThen(function(p4)
				object:dispatch(resolveSubscriptionPromptState(p4))
			end):catch(function(p4)
				object:dispatch(ErrorOccurred(p4))
			end)
		end

		object:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))
		return nil
	end)
end

return initiateSubscriptionPurchase
