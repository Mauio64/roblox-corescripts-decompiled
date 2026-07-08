local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent

require(CurrencyTransfers.types)

local t = require(CurrencyTransfersParent.t)
local t1 = {}

function t1.new(p1) -- line: 14
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 26
	-- upvalues: CurrencyTransfers (copy), t1 (copy)
	local v8 = p2 or {}
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)

	return (t1.new({
		transfer = v8.transfer or {
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
		}
	}))
end

local function formatRobuxTransfer(p3) -- line: 56
	-- upvalues: CurrencyTransfers (copy)
	local TransferStatus = require(CurrencyTransfers.Enums.TransferStatus)
	local sender = p3.sender
	local recipient = p3.recipient

	return {
		transferId = p3.transferId,
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
		transferAmount = p3.transferAmount,
		creationTime = p3.creationTime,
		requireRecipientAction = p3.requireRecipientAction,
		status = TransferStatus.fromValue(p3.status) or TransferStatus.Completed
	}
end

function t1.format(p4) -- line: 81
	-- upvalues: t1 (copy), formatRobuxTransfer (copy)
	local transfer = p4.transfer

	if not transfer then
		error("GetTransferByIdModel.format: transfer is missing from response")
	end

	return (t1.new({
		transfer = formatRobuxTransfer(transfer)
	}))
end

t1.isValid = t.strictInterface({
	transfer = t.table
})

return t1
