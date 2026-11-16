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
	local v5 = options or {}
	local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferStatus")

	return (class.new({
		robuxTransfer = v5.robuxTransfer or {
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
		},
		isAlreadyAccepted = v5.isAlreadyAccepted ~= nil and v5.isAlreadyAccepted
	}))
end

function class.format(data)
	local robuxTransfer = data.robuxTransfer or data.RobuxTransfer
	local v5

	if data.isAlreadyAccepted == nil then
		v5 = data.IsAlreadyAccepted == true
	else
		v5 = data.isAlreadyAccepted
	end

	local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferStatus")

	if not robuxTransfer then
		error("AcceptTransferModel.format: robuxTransfer is missing from response")
	end

	return (class.new({
		isAlreadyAccepted = v5,
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
			status = module2.fromValue(robuxTransfer.status or robuxTransfer.Status) or module2.Completed
		}
	}))
end

class.isValid = t.strictInterface({
	robuxTransfer = t.table,
	isAlreadyAccepted = t.boolean
})

return class
