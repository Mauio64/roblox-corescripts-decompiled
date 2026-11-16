local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/LoggingProtocol")

local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flows/InExperienceTransferFlow")

local function useInExperienceTransferListenerEffect(callback)
	React.useEffect(function()
		local promptRobuxTransferRequestedConnection = MarketplaceService.PromptRobuxTransferRequested:Connect(function(p2, json)
			if p2 == Players.LocalPlayer then
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
