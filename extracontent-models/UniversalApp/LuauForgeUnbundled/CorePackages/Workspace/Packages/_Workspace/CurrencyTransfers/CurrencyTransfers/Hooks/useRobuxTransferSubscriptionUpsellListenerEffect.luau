local MarketplaceService = game:GetService("MarketplaceService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/LoggingProtocol")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")

local function useRobuxTransferSubscriptionUpsellListenerEffect(callback)
	React.useEffect(function()
		if not SharedFlags.GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent() then
			return function() end
		end

		local promptRobuxTransferSubscriptionUpsellRequestedConnection = MarketplaceService.PromptRobuxTransferSubscriptionUpsellRequested:Connect(function()
			LoggingProtocol.default:logRobloxTelemetryCounter(
				CurrencyTransferTelemetry.CurrencyTransferEngineUpsellSignalReceivedCounter,
				1,
				{ transferOrigination = tostring(TransferOrigination.InExperience) }
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
