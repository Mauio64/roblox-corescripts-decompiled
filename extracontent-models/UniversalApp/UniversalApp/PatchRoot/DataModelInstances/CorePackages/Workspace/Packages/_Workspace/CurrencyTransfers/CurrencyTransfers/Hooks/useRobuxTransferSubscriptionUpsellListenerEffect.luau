local MarketplaceService = game:GetService("MarketplaceService")
local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local LoggingProtocol = require(CurrencyTransfersParent.LoggingProtocol)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

local function useRobuxTransferSubscriptionUpsellListenerEffect(p1: ((...any) -> ...any)) -- line: 14
	-- upvalues: React (copy), SharedFlags (copy), MarketplaceService (copy), LoggingProtocol (copy), CurrencyTransferTelemetry (copy), TransferOrigination (copy)
	React.useEffect(function() -- line: 15
		-- upvalues: SharedFlags (copy), MarketplaceService (copy), LoggingProtocol (copy), CurrencyTransferTelemetry (copy), TransferOrigination (copy), p1 (copy)
		if not SharedFlags.GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent() then
			return function() -- line: 19
			end
		end

		local connection = MarketplaceService.PromptRobuxTransferSubscriptionUpsellRequested:Connect(function() -- line: 22
			-- upvalues: LoggingProtocol (copy), CurrencyTransferTelemetry (copy), TransferOrigination (copy), p1 (copy)
			LoggingProtocol.default:logRobloxTelemetryCounter(CurrencyTransferTelemetry.CurrencyTransferEngineUpsellSignalReceivedCounter, 1, {
				transferOrigination = tostring(TransferOrigination.InExperience)
			})
			p1()
		end)

		return function() -- line: 33
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, { p1 })
end

return useRobuxTransferSubscriptionUpsellListenerEffect
