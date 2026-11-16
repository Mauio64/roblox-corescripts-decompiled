local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
require(CurrencyTransfers.types)
local t = require(parent.t)

local AcceptTransferModel = {}

function AcceptTransferModel.new(p)
	assert(AcceptTransferModel.isValid(p))

	AcceptTransferModel.__index = AcceptTransferModel

	setmetatable(p, AcceptTransferModel)

	return p
end

function AcceptTransferModel.mock(options)
	local v = options or {}
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)

	return (AcceptTransferModel.new({
		robuxTransfer = v.robuxTransfer or {
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
		},
		isAlreadyAccepted = v.isAlreadyAccepted ~= nil and v.isAlreadyAccepted
	}))
end

function AcceptTransferModel.format(data)
	local robuxTransfer = data.robuxTransfer or data.RobuxTransfer
	local isAlreadyAccepted

	if data.isAlreadyAccepted == nil then
		isAlreadyAccepted = data.IsAlreadyAccepted == true
	else
		isAlreadyAccepted = data.isAlreadyAccepted
	end

	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)

	if not robuxTransfer then
		error("AcceptTransferModel.format: robuxTransfer is missing from response")
	end

	return (AcceptTransferModel.new({
		isAlreadyAccepted = isAlreadyAccepted,
		robuxTransfer = {
			transferId = robuxTransfer.transferId or robuxTransfer.TransferId,
			sender = {
				type = robuxTransfer.sender.type or robuxTransfer.Sender.Type,
				targetId = robuxTransfer.sender.targetId or robuxTransfer.Sender.TargetId,
				targetName = robuxTransfer.sender.targetName or robuxTransfer.Sender.TargetName,
				targetDisplayName = robuxTransfer.sender.targetDisplayName or robuxTransfer.Sender.TargetDisplayName
			},
			recipient = {
				type = robuxTransfer.recipient.type or robuxTransfer.Recipient.Type,
				targetId = robuxTransfer.recipient.targetId or robuxTransfer.Recipient.TargetId,
				targetName = robuxTransfer.recipient.targetName or robuxTransfer.Recipient.TargetName,
				targetDisplayName = robuxTransfer.recipient.targetDisplayName or robuxTransfer.Recipient.TargetDisplayName
			},
			transferAmount = robuxTransfer.transferAmount or robuxTransfer.TransferAmount,
			receivingAmount = robuxTransfer.receivingAmount or robuxTransfer.ReceivingAmount,
			creationTime = robuxTransfer.creationTime or robuxTransfer.CreationTime,
			requireRecipientAction = robuxTransfer.requireRecipientAction or robuxTransfer.RequireRecipientAction,
			status = TransferStatus.fromValue(robuxTransfer.status or robuxTransfer.Status) or TransferStatus.Completed
		}
	}))
end

AcceptTransferModel.isValid = t.strictInterface({
	robuxTransfer = t.table,
	isAlreadyAccepted = t.boolean
})

return AcceptTransferModel
