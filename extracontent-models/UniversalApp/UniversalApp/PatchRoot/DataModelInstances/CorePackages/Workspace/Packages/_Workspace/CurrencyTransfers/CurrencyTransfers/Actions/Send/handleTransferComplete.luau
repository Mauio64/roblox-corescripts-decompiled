local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local GetFFlagCurrencyTransferSignalRecipientOnComplete = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferSignalRecipientOnComplete)

local function handleTransferComplete(p1) -- line: 13
	-- upvalues: TransferOrigination (copy), Players (copy), MarketplaceService (copy), GetFFlagCurrencyTransferSignalRecipientOnComplete (copy), PromptState (copy)
	local v9 = p1.getTransferOrigination(false)
	local setPromptState = p1.setPromptState
	local triggerOnClose = p1.triggerOnClose

	if v9 == TransferOrigination.InExperience then
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer then
			pcall(function() -- line: 21
				-- upvalues: MarketplaceService (copy), LocalPlayer (copy)
				MarketplaceService:SignalRobuxTransferCompleted(LocalPlayer.UserId)
			end)
		end

		if GetFFlagCurrencyTransferSignalRecipientOnComplete() then
			local v13 = p1.getRecipient(false)

			if v13 then
				pcall(function() -- line: 29
					-- upvalues: MarketplaceService (copy), v13 (copy)
					MarketplaceService:SignalRobuxTransferCompleted(v13.targetId)
				end)
			end
		end
	end

	setPromptState(PromptState.TransferComplete)
	triggerOnClose()
end

return handleTransferComplete
