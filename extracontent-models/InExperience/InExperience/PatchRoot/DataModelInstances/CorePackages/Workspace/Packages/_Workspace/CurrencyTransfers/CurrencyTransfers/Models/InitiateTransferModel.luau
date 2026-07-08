local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent

require(CurrencyTransfers.types)

local t = require(CurrencyTransfersParent.t)
local t1 = {}

function t1.new(p1) -- line: 24
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 36
	-- upvalues: t1 (copy)
	local v7 = p2 or {}
	local v8 = v7.robuxTransfer or {}
	local v9 = v8.sender or {
		targetDisplayName = "MockSender",
		targetId = 0,
		targetName = "mock",
		type = 1
	}
	local v10 = v8.recipient or {
		targetDisplayName = "MockRecipient",
		targetId = 0,
		targetName = "mock",
		type = 1
	}
	local v11 = v7.userRelationshipDetail or {
		mutualFriendsCount = 0,
		userAccountSinceYear = 0,
		areFriends = false
	}

	return (t1.new({
		transferRequestId = v7.transferRequestId or "RXT-1234567890",
		robuxTransfer = {
			transferId = v8.transferId or 1234567890,
			sender = v9,
			recipient = v10
		},
		userRelationshipDetail = v11,
		senderRobuxBalance = v7.senderRobuxBalance or 0
	}))
end
function t1.format(p3) -- line: 73
	-- upvalues: t1 (copy)
	local robuxTransfer = p3.robuxTransfer
	local sender = robuxTransfer.sender
	local v15 = if not sender then {
		targetDisplayName = "",
		targetId = 0,
		targetName = "",
		type = 0
	} else {
		targetDisplayName = sender.targetDisplayName,
		targetId = sender.targetId,
		targetName = sender.targetName,
		type = sender.type
	}

	return (t1.new({
		transferRequestId = p3.transferRequestId,
		robuxTransfer = {
			transferId = robuxTransfer.transferId,
			sender = v15,
			recipient = {
				targetDisplayName = robuxTransfer.recipient.targetDisplayName,
				targetId = robuxTransfer.recipient.targetId,
				targetName = robuxTransfer.recipient.targetName,
				type = robuxTransfer.recipient.type
			}
		},
		senderRobuxBalance = p3.senderRobuxBalance,
		minimumTransferAmount = p3.minimumTransferAmount,
		maximumTransferAmount = p3.maximumTransferAmount,
		userRelationshipDetail = {
			friendSinceYear = p3.userRelationshipDetail.friendSinceYear,
			friendSinceDate = p3.userRelationshipDetail.friendSinceDate,
			mutualFriendsCount = p3.userRelationshipDetail.mutualFriendsCount,
			userAccountSinceYear = p3.userRelationshipDetail.userAccountSinceYear,
			areFriends = p3.userRelationshipDetail.areFriends
		}
	}))
end

t1.isValid = t.strictInterface({
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
	maximumTransferAmount = t.optional(t.number)
})

return t1
