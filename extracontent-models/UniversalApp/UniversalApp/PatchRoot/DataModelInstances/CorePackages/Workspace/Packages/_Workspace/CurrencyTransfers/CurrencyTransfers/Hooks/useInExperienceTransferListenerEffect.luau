local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local LoggingProtocol = require(CurrencyTransfersParent.LoggingProtocol)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

require(CurrencyTransfers.Flows.InExperienceTransferFlow)

local function useInExperienceTransferListenerEffect(p1: ((...any) -> ...any)) -- line: 19
	-- upvalues: React (copy), MarketplaceService (copy), Players (copy), HttpService (copy), LoggingProtocol (copy), CurrencyTransferTelemetry (copy), TransferDirection (copy), TransferOrigination (copy)
	React.useEffect(function() -- line: 20
		-- upvalues: MarketplaceService (copy), Players (copy), HttpService (copy), LoggingProtocol (copy), CurrencyTransferTelemetry (copy), TransferDirection (copy), TransferOrigination (copy), p1 (copy)
		local connection = MarketplaceService.PromptRobuxTransferRequested:Connect(function(p2, s1: string) -- line: 22
			-- upvalues: Players (copy), HttpService (copy), LoggingProtocol (copy), CurrencyTransferTelemetry (copy), TransferDirection (copy), TransferOrigination (copy), p1 (copy)
			if p2 == Players.LocalPlayer then
				local ok, result = pcall(function() -- line: 24
					-- upvalues: HttpService (copy), s1 (copy)
					return HttpService:JSONDecode(s1)
				end)

				if not ok then
					warn("[InExperienceTransfer] Failed to decode transfer response")
				end

				if ok and result then
					LoggingProtocol.default:logRobloxTelemetryCounter(CurrencyTransferTelemetry.CurrencyTransferEngineSignalReceivedCounter, 1, {
						direction = tostring(TransferDirection.Send),
						transferOrigination = tostring(TransferOrigination.InExperience)
					})
					p1(result)
				end
			end
		end)

		return function() -- line: 47
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, { p1 })
end

return useInExperienceTransferListenerEffect
