local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent

require(CurrencyTransfers.types)

local t = require(CurrencyTransfersParent.t)
local t1 = {}

function t1.new(p1) -- line: 15
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 27
	-- upvalues: CurrencyTransfers (copy), t1 (copy)
	local v7 = p2 or {}
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)

	return (t1.new({
		robuxTransfer = v7.robuxTransfer or {
			transferId = 123456,
			transferAmount = 100,
			creationTime = "2025-01-01T00:00:00Z",
			requireRecipientAction = false,
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
			status = TransferStatus.Completed
		},
		isAlreadyAccepted = v7.isAlreadyAccepted ~= nil and v7.isAlreadyAccepted
	}))
end
function t1.format(p3) -- line: 57
	-- upvalues: CurrencyTransfers (copy), t1 (copy)
	local v10 = p3.robuxTransfer or p3.RobuxTransfer
	local v11 = if p3.isAlreadyAccepted == nil then p3.IsAlreadyAccepted == true else p3.isAlreadyAccepted
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)

	if not v10 then
		error("AcceptTransferModel.format: robuxTransfer is missing from response")
	end

	return (t1.new({
		isAlreadyAccepted = v11,
		robuxTransfer = {
			transferId = v10.transferId or v10.TransferId,
			sender = {
				type = v10.sender.type or v10.Sender.Type,
				targetId = v10.sender.targetId or v10.Sender.TargetId,
				targetName = v10.sender.targetName or v10.Sender.TargetName,
				targetDisplayName = v10.sender.targetDisplayName or v10.Sender.TargetDisplayName
			},
			recipient = {
				type = v10.recipient.type or v10.Recipient.Type,
				targetId = v10.recipient.targetId or v10.Recipient.TargetId,
				targetName = v10.recipient.targetName or v10.Recipient.TargetName,
				targetDisplayName = v10.recipient.targetDisplayName or v10.Recipient.TargetDisplayName
			},
			transferAmount = v10.transferAmount or v10.TransferAmount,
			receivingAmount = v10.receivingAmount or v10.ReceivingAmount,
			creationTime = v10.creationTime or v10.CreationTime,
			requireRecipientAction = v10.requireRecipientAction or v10.RequireRecipientAction,
			status = TransferStatus.fromValue(v10.status or v10.Status) or TransferStatus.Completed
		}
	}))
end

t1.isValid = t.strictInterface({
	robuxTransfer = t.table,
	isAlreadyAccepted = t.boolean
})

return t1
