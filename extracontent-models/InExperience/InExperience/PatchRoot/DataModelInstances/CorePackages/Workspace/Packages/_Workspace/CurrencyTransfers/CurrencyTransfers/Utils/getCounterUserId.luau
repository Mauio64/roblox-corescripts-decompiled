local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
require(CurrencyTransfers.Stores.createTransferStore)

local function getCounterUserId(p, p2)
	if p2 == TransferDirection.Send then
		local recipient = p.getRecipient(false)

		if recipient then
			return recipient.targetId
		end
	else
		local sender = p.getSender(false)

		if sender then
			return sender.targetId
		end
	end

	return nil
end

return getCounterUserId
