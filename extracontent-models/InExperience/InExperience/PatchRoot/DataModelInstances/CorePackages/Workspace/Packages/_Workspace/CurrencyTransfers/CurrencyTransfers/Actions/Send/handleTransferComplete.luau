local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)

local GetFFlagCurrencyTransferSignalRecipientOnComplete = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferSignalRecipientOnComplete)

local function handleTransferComplete(data)
	local transferOrigination = data.getTransferOrigination(false)
	local setPromptState = data.setPromptState
	local triggerOnClose = data.triggerOnClose

	if transferOrigination == TransferOrigination.InExperience then
		local localPlayer = Players.LocalPlayer

		if localPlayer then
			pcall(function()
				MarketplaceService:SignalRobuxTransferCompleted(localPlayer.UserId)
			end)
		end

		local v = GetFFlagCurrencyTransferSignalRecipientOnComplete() and data.getRecipient(false)

		if v then
			pcall(function()
				MarketplaceService:SignalRobuxTransferCompleted(v.targetId)
			end)
		end
	end

	setPromptState(PromptState.TransferComplete)
	triggerOnClose()
end

return handleTransferComplete
