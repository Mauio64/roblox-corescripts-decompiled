local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")

local function getCounterUserId(p2, p3)
	if p3 == TransferDirection.Send then
		local recipient = p2.getRecipient(false)

		if recipient then
			return recipient.targetId
		end
	else
		local sender = p2.getSender(false)

		if sender then
			return sender.targetId
		end
	end

	return nil
end

return getCounterUserId
