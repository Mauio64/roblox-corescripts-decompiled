local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local Players = game:GetService("Players")

require(CurrencyTransfers.Stores.createTransferStore)

local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)

local function buildRobuxTransferFlowPayload(p1, s1: string) -- line: 10
	-- upvalues: Players (copy), TransferDirection (copy)
	local LocalPlayer = Players.LocalPlayer
	local v8 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v9 = p1.getDirection(false)
	local n1 = 0
	local n2 = 0

	if v9 == TransferDirection.Send then
		n1 = v8

		local v12 = p1.getRecipient(false)

		n2 = if not v12 then p1.getRecipientUserId(false) else v12.targetId
	elseif v9 == TransferDirection.Receive then
		n2 = v8

		local v13 = p1.getSender(false)

		n1 = not v13 and 0 or v13.targetId
	end

	local v14 = p1.getTransferRequestId(false)
	local v15 = p1.getSelectedAmount(false)
	local v16 = p1.getRobuxTransfer(false)

	if v15 == nil and v16 then
		v15 = v16.transferAmount
	end

	local v17 = nil
	local GameId = game.GameId

	if GameId > 0 then
		v17 = GameId
	end

	local v19 = p1.getTransferOrigination(false)
	local v20 = not v9 and "" or tostring(v9)
	local v21 = not v19 and "" or tostring(v19)
	local t1 = {
		transfer_request_id = v14 or "",
		transfer_client_session_id = p1.getTransferClientSessionId(false),
		event_name = s1,
		sender_user_id = n1,
		recipient_user_id = n2,
		transfer_amount = v15,
		transfer_prompt_state = tostring(p1.getPromptState(false)),
		transfer_origination = v21,
		transfer_direction = v20,
		ingest_timestamp_milliseconds = DateTime.now().UnixTimestampMillis
	}

	if v9 == TransferDirection.Send and p1.getBalanceReceivedFromApi(false) then
		t1.user_balance = p1.getRobuxBalanceAmount(false)
	end

	if v17 ~= nil then
		t1.universe_id = v17
	end

	return t1
end

return buildRobuxTransferFlowPayload
