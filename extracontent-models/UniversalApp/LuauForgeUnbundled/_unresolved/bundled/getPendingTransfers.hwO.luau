local module = require("@luauforge/bundled/hwP")
local module2 = require("@luauforge/bundled/hwR")

local function getPendingTransfers()
	local v5 = module2()
	local transfers = if v5 then v5.transfers else nil

	if transfers == nil then
		return { transfers = {}, acceptText = "" }
	end

	local v6 = {}

	for k, pending_transfer_id in transfers.pending_transfer_ids do
		local pendingTransfer = module.getPendingTransfer(pending_transfer_id)
		local sender = if pendingTransfer then pendingTransfer.sender else nil
		local user_id = if sender then tonumber(sender.user_id) else nil
		local netTransferRobuxAmount = if pendingTransfer then tonumber(pendingTransfer.netTransferRobuxAmount) else nil

		if pendingTransfer and sender and user_id and sender.display_name and netTransferRobuxAmount then
			table.insert(v6, {
				transferRequestId = pending_transfer_id,
				senderUserId = user_id,
				senderDisplayName = sender.display_name,
				robuxAmount = netTransferRobuxAmount,
				createdTimestampMs = tonumber(pendingTransfer.createdTimestampMs) or 0
			})
		end
	end

	return { transfers = v6, acceptText = transfers.accept_transfers_text }
end

return getPendingTransfers
