local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

local Players = game:GetService("Players")

require(CurrencyTransfers.Stores.createTransferStore)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)

local function buildRobuxTransferFlowPayload(data, event_name: string)
	local localPlayer = Players.LocalPlayer
	local v = not localPlayer and 0 or localPlayer.UserId

	local direction = data.getDirection(false)
	local sender_user_id = 0
	local recipient_user_id = 0

	if direction == TransferDirection.Send then
		local recipient = data.getRecipient(false)

		if recipient then
			recipient_user_id = recipient.targetId
		else
			recipient_user_id = data.getRecipientUserId(false)
		end

		sender_user_id = v
	elseif direction == TransferDirection.Receive then
		local sender = data.getSender(false)

		if sender then
			sender_user_id = sender.targetId
			recipient_user_id = v
		else
			recipient_user_id = v
			sender_user_id = 0
		end
	end

	local transferRequestId = data.getTransferRequestId(false)
	local transfer_amount = data.getSelectedAmount(false)
	local robuxTransfer = data.getRobuxTransfer(false)

	if transfer_amount == nil and robuxTransfer then
		transfer_amount = robuxTransfer.transferAmount
	end

	local gameId = game.GameId

	if not (gameId > 0) then
		gameId = nil
	end

	local transferOrigination = data.getTransferOrigination(false)
	local transfer_direction = not direction and "" or tostring(direction)
	local transfer_origination = not transferOrigination and "" or tostring(transferOrigination)

	local robuxTransferFlowPayload = {
		transfer_request_id = transferRequestId or "",
		transfer_client_session_id = data.getTransferClientSessionId(false),
		event_name = event_name,
		sender_user_id = sender_user_id,
		recipient_user_id = recipient_user_id,
		transfer_amount = transfer_amount,
		transfer_prompt_state = tostring(data.getPromptState(false)),
		transfer_origination = transfer_origination,
		transfer_direction = transfer_direction,
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
