local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
require(CurrencyTransfers.types)
local t = require(parent.t)
local FFlagShowRemainingTransfersForNonPlus = require(CurrencyTransfers.Flags.FFlagShowRemainingTransfersForNonPlus)
local TransferBenefitSource = require(CurrencyTransfers.Enums.TransferBenefitSource)

local InitiateTransferModel = {}

function InitiateTransferModel.new(p)
	assert(InitiateTransferModel.isValid(p))

	InitiateTransferModel.__index = InitiateTransferModel

	setmetatable(p, InitiateTransferModel)

	return p
end

function InitiateTransferModel.mock(options)
	local v = options or {}
	local robuxTransfer = v.robuxTransfer or {}
	local sender = robuxTransfer.sender
		or { targetDisplayName = "MockSender", targetId = 0, targetName = "mock", type = 1 }

	local recipient = robuxTransfer.recipient
		or { targetDisplayName = "MockRecipient", targetId = 0, targetName = "mock", type = 1 }

	local userRelationshipDetail = v.userRelationshipDetail
		or { mutualFriendsCount = 0, userAccountSinceYear = 0, areFriends = false }

	return (InitiateTransferModel.new({
		transferRequestId = v.transferRequestId or "RXT-1234567890",
		robuxTransfer = {
			transferId = robuxTransfer.transferId or 1234567890,
			sender = sender,
			recipient = recipient
		},
		userRelationshipDetail = userRelationshipDetail,
		senderRobuxBalance = v.senderRobuxBalance or 0
	}))
end

function InitiateTransferModel.format(data)
	local robuxTransfer = data.robuxTransfer
	local sender = robuxTransfer.sender

	local sender2 = sender
		and {
			targetDisplayName = sender.targetDisplayName,
			targetId = sender.targetId,
			targetName = sender.targetName,
			type = sender.type
		}
		or { targetDisplayName = "", targetId = 0, targetName = "", type = 0 }

	local new = InitiateTransferModel.new
	local v = {
		transferRequestId = data.transferRequestId,
		robuxTransfer = {
			transferId = robuxTransfer.transferId,
			sender = sender2,
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
	local transferBenefitSource

	if FFlagShowRemainingTransfersForNonPlus then
		transferBenefitSource = TransferBenefitSource.fromValue(data.benefitSource)
	end

	v.transferBenefitSource = transferBenefitSource
	local numFreeTransfersRemaining

	if FFlagShowRemainingTransfersForNonPlus and type(data.numFreeTransfersRemaining) == "number" then
		numFreeTransfersRemaining = data.numFreeTransfersRemaining
	end

	v.numFreeTransfersRemaining = numFreeTransfersRemaining
	return (new(v))
end

InitiateTransferModel.isValid = t.strictInterface({
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

return InitiateTransferModel
