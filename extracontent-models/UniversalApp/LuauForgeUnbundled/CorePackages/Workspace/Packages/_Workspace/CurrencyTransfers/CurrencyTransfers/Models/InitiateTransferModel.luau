require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/types")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")
local FFlagShowRemainingTransfersForNonPlus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagShowRemainingTransfersForNonPlus")
local TransferBenefitSource = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferBenefitSource")

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	local v5 = options or {}
	local robuxTransfer = v5.robuxTransfer or {}
	local sender = robuxTransfer.sender
		or {
			targetDisplayName = "MockSender",
			targetId = 0,
			targetName = "mock",
			type = 1
		}

	local recipient = robuxTransfer.recipient
		or {
			targetDisplayName = "MockRecipient",
			targetId = 0,
			targetName = "mock",
			type = 1
		}

	local userRelationshipDetail = v5.userRelationshipDetail
		or { mutualFriendsCount = 0, userAccountSinceYear = 0, areFriends = false }

	return (class.new({
		transferRequestId = v5.transferRequestId or "RXT-1234567890",
		robuxTransfer = {
			transferId = robuxTransfer.transferId or 1234567890,
			sender = sender,
			recipient = recipient
		},
		userRelationshipDetail = userRelationshipDetail,
		senderRobuxBalance = v5.senderRobuxBalance or 0
	}))
end

function class.format(data)
	local robuxTransfer = data.robuxTransfer
	local sender = robuxTransfer.sender

	local v5 = sender
		and {
			targetDisplayName = sender.targetDisplayName,
			targetId = sender.targetId,
			targetName = sender.targetName,
			type = sender.type
		}
		or { targetDisplayName = "", targetId = 0, targetName = "", type = 0 }

	local new = class.new
	local v6 = {
		transferRequestId = data.transferRequestId,
		robuxTransfer = {
			transferId = robuxTransfer.transferId,
			sender = v5,
			recipient = {
				targetDisplayName = robuxTransfer.recipient.targetDisplayName,
				targetId = robuxTransfer.recipient.targetId,
				targetName = robuxTransfer.recipient.targetName,
				type = robuxTransfer.recipient.type
			}
		},
		senderRobuxBalance = data.senderRobuxBalance,
		minimumTransferAmount = data.minimumTransferAmount,
		maximumTransferAmount = data.maximumTransferAmount,
		userRelationshipDetail = {
			friendSinceYear = data.userRelationshipDetail.friendSinceYear,
			friendSinceDate = data.userRelationshipDetail.friendSinceDate,
			mutualFriendsCount = data.userRelationshipDetail.mutualFriendsCount,
			userAccountSinceYear = data.userRelationshipDetail.userAccountSinceYear,
			areFriends = data.userRelationshipDetail.areFriends
		},
		transferBenefitSource = 0,
		numFreeTransfersRemaining = 0
	}

	local v7 = if FFlagShowRemainingTransfersForNonPlus then TransferBenefitSource.fromValue(data.benefitSource) else nil
	v6.transferBenefitSource = v7

	local v8 = if FFlagShowRemainingTransfersForNonPlus and type(data.numFreeTransfersRemaining) == "number" then data.numFreeTransfersRemaining else nil
	v6.numFreeTransfersRemaining = v8
	return (new(v6))
end

class.isValid = t.strictInterface({
	transferRequestId = t.string,
	robuxTransfer = t.strictInterface({
		transferId = t.number,
		sender = t.strictInterface({
			targetDisplayName = t.string,
			targetId = t.number,
			targetName = t.string,
			type = t.number
		}),
		recipient = t.strictInterface({
			targetDisplayName = t.string,
			targetId = t.number,
			targetName = t.string,
			type = t.number
		})
	}),
	userRelationshipDetail = t.strictInterface({
		friendSinceYear = t.optional(t.number),
		friendSinceDate = t.optional(t.strictInterface({
			year = t.number,
			month = t.number,
			day = t.number
		})),
		mutualFriendsCount = t.number,
		userAccountSinceYear = t.number,
		areFriends = t.boolean
	}),
	senderRobuxBalance = t.number,
	minimumTransferAmount = t.optional(t.number),
	maximumTransferAmount = t.optional(t.number),
	transferBenefitSource = t.optional(t.string),
	numFreeTransfersRemaining = t.optional(t.number)
})

return class
