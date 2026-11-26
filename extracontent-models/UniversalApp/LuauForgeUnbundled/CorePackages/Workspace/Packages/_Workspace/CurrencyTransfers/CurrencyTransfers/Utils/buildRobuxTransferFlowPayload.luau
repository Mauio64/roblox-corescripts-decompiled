local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")

local function buildRobuxTransferFlowPayload(data, p2)
	local localPlayer = Players.LocalPlayer
	local v5 = not localPlayer and 0 or localPlayer.UserId

	local direction = data.getDirection(false)
	local v6 = 0
	local v7 = 0

	if direction == TransferDirection.Send then
		local recipient = data.getRecipient(false)
		v7 = if recipient then recipient.targetId else data.getRecipientUserId(false)
		v6 = v5
	elseif direction == TransferDirection.Receive then
		local sender = data.getSender(false)

		if sender then
			v6 = sender.targetId
			v7 = v5
		else
			v7 = v5
			v6 = 0
		end
	end

	local transferRequestId = data.getTransferRequestId(false)
	local v8 = data.getSelectedAmount(false)
	local robuxTransfer = data.getRobuxTransfer(false)

	if v8 == nil and robuxTransfer then
		v8 = robuxTransfer.transferAmount
	end

	local gameId = game.GameId

	if not (gameId > 0) then
		gameId = nil
	end

	local transferOrigination = data.getTransferOrigination(false)
	local v9 = not direction and "" or tostring(direction)
	local v10 = not transferOrigination and "" or tostring(transferOrigination)

	local robuxTransferFlowPayload = {
		transfer_request_id = transferRequestId or "",
		transfer_client_session_id = data.getTransferClientSessionId(false),
		event_name = p2,
		sender_user_id = v6,
		recipient_user_id = v7,
		transfer_amount = v8,
		transfer_prompt_state = tostring(data.getPromptState(false)),
		transfer_origination = v10,
		transfer_direction = v9,
		ingest_timestamp_milliseconds = DateTime.now().UnixTimestampMillis
	}

	if direction == TransferDirection.Send and data.getBalanceReceivedFromApi(false) then
		robuxTransferFlowPayload.user_balance = data.getRobuxBalanceAmount(false)
	end

	if gameId ~= nil then
		robuxTransferFlowPayload.universe_id = gameId
	end

	return robuxTransferFlowPayload
end

return buildRobuxTransferFlowPayload
