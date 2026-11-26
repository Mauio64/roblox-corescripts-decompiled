require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/types")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferStatus")
	return (class.new({
		transfer = (options or {}).transfer or {
			transferId = 123456,
			sender = {
				type = 1,
				targetId = 100,
				targetName = "SenderUser",
				targetDisplayName = "Sender Display"
			},
			recipient = {
				type = 1,
				targetId = 200,
				targetName = "RecipientUser",
				targetDisplayName = "Recipient Display"
			},
			transferAmount = 100,
			creationTime = "2025-01-01T00:00:00Z",
			requireRecipientAction = false,
			status = module2.Completed
		}
	}))
end

local function formatRobuxTransfer(transfer)
	local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferStatus")
	local sender = transfer.sender
	local recipient = transfer.recipient
	return {
		transferId = transfer.transferId,
		sender = {
			type = sender.type,
			targetId = sender.targetId,
			targetName = sender.targetName,
			targetDisplayName = sender.targetDisplayName
		},
		recipient = {
			type = recipient.type,
			targetId = recipient.targetId,
			targetName = recipient.targetName,
			targetDisplayName = recipient.targetDisplayName
		},
		transferAmount = transfer.transferAmount,
		creationTime = transfer.creationTime,
		requireRecipientAction = transfer.requireRecipientAction,
		status = module2.fromValue(transfer.status) or module2.Completed
	}
end

function class.format(p2)
	local transfer = p2.transfer

	if not transfer then
		error("GetTransferByIdModel.format: transfer is missing from response")
	end

	return (class.new({ transfer = formatRobuxTransfer(transfer) }))
end

class.isValid = t.strictInterface({ transfer = t.table })

return class
