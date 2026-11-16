local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local React = require(parent.React)
local LoggingProtocol = require(parent.LoggingProtocol)

local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

require(CurrencyTransfers.Flows.InExperienceTransferFlow)

local function useInExperienceTransferListenerEffect(callback)
	React.useEffect(function()
		local promptRobuxTransferRequestedConnection = MarketplaceService.PromptRobuxTransferRequested:Connect(function(p, json: string)
			if p == Players.LocalPlayer then
				local success, result = pcall(function()
					return HttpService:JSONDecode(json)
				end)

				if not success then
					warn("[InExperienceTransfer] Failed to decode transfer response")
				end

				if success and result then
					LoggingProtocol.default:logRobloxTelemetryCounter(
						CurrencyTransferTelemetry.CurrencyTransferEngineSignalReceivedCounter,
						1,
						{
							direction = tostring(TransferDirection.Send),
							transferOrigination = tostring(TransferOrigination.InExperience)
						}
					)

					callback(result)
				end
			end
		end)

		return function()
			if promptRobuxTransferRequestedConnection then
				promptRobuxTransferRequestedConnection:Disconnect()
				promptRobuxTransferRequestedConnection = nil
			end
		end
	end, { callback })
end

return useInExperienceTransferListenerEffect
