local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
require(CurrencyTransfers.types)
local t = require(parent.t)

local GetTransferByIdModel = {}

function GetTransferByIdModel.new(p)
	assert(GetTransferByIdModel.isValid(p))

	GetTransferByIdModel.__index = GetTransferByIdModel

	setmetatable(p, GetTransferByIdModel)

	return p
end

function GetTransferByIdModel.mock(options)
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)
	return (GetTransferByIdModel.new({
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
			status = TransferStatus.Completed
		}
	}))
end

local function formatRobuxTransfer(transfer)
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)
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
		status = TransferStatus.fromValue(transfer.status) or TransferStatus.Completed
	}
end

function GetTransferByIdModel.format(p)
	local transfer = p.transfer

	if not transfer then
		error("GetTransferByIdModel.format: transfer is missing from response")
	end

	return (GetTransferByIdModel.new({ transfer = formatRobuxTransfer(transfer) }))
end

GetTransferByIdModel.isValid = t.strictInterface({ transfer = t.table })

return GetTransferByIdModel
