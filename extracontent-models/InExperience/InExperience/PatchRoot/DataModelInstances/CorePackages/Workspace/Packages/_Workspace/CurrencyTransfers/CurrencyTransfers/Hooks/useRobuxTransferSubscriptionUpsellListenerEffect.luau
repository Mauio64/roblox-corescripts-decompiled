local MarketplaceService = game:GetService("MarketplaceService")

local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local React = require(parent.React)
local LoggingProtocol = require(parent.LoggingProtocol)
local SharedFlags = require(parent.SharedFlags)

local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

local function useRobuxTransferSubscriptionUpsellListenerEffect(callback)
	React.useEffect(function()
		if not SharedFlags.GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent() then
			return function() end
		end

		local promptRobuxTransferSubscriptionUpsellRequestedConnection = MarketplaceService.PromptRobuxTransferSubscriptionUpsellRequested:Connect(function()
			LoggingProtocol.default:logRobloxTelemetryCounter(
				CurrencyTransferTelemetry.CurrencyTransferEngineUpsellSignalReceivedCounter,
				1,
				{
					transferOrigination = tostring(TransferOrigination.InExperience)
				}
			)

			callback()
		end)

		return function()
			if promptRobuxTransferSubscriptionUpsellRequestedConnection then
				promptRobuxTransferSubscriptionUpsellRequestedConnection:Disconnect()
				promptRobuxTransferSubscriptionUpsellRequestedConnection = nil
			end
		end
	end, { callback })
end

return useRobuxTransferSubscriptionUpsellListenerEffect
