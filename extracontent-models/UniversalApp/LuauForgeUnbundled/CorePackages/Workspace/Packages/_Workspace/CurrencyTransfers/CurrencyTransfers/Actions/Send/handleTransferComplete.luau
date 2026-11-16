local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")

local GetFFlagCurrencyTransferSignalRecipientOnComplete = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferSignalRecipientOnComplete")

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

		local v5 = GetFFlagCurrencyTransferSignalRecipientOnComplete() and data.getRecipient(false)

		if v5 then
			pcall(function()
				MarketplaceService:SignalRobuxTransferCompleted(v5.targetId)
			end)
		end
	end

	setPromptState(PromptState.TransferComplete)
	triggerOnClose()
end

return handleTransferComplete
