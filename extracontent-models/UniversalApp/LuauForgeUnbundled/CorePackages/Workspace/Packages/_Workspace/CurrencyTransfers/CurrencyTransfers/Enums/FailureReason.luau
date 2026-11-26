local v5 = {
	Invalid = "Invalid",
	InvalidInput = "InvalidInput",
	TransferNotFound = "TransferNotFound",
	Unauthorized = "Unauthorized",
	InternalError = "InternalError",
	TransferDailyLimitExceeded = "TransferDailyLimitExceeded",
	TransferMonthlyLimitExceeded = "TransferMonthlyLimitExceeded",
	InsufficientFunds = "InsufficientFunds",
	UserNotAllowed = "UserNotAllowed",
	TransferExpired = "TransferExpired",
	TooManyRequests = "TooManyRequests",
	TransferAlreadyProcessed = "TransferAlreadyProcessed",
	InvalidTransferState = "InvalidTransferState",
	AmpRecourseAvailable = "AmpRecourseAvailable",
	TransferDisabledForUser = "TransferDisabledForUser",
	ReceiverNotAllowed = "ReceiverNotAllowed",
	ReceiveLimitExceeded = "ReceiveLimitExceeded",
	TransferAmountBelowMinimum = "TransferAmountBelowMinimum",
	TransferAmountExceedsMaximum = "TransferAmountExceedsMaximum",
	TransferAmountExceedsNonSecuredMaximum = "TransferAmountExceedsNonSecuredMaximum",
	NoFreeTransfersRemaining = "NoFreeTransfersRemaining"
}

local v6 = {
	[0] = v5.Invalid,
	[1] = v5.InvalidInput,
	[2] = v5.TransferNotFound,
	[3] = v5.Unauthorized,
	[4] = v5.InternalError,
	[5] = v5.TransferDailyLimitExceeded,
	[6] = v5.TransferMonthlyLimitExceeded,
	[7] = v5.InsufficientFunds,
	[8] = v5.UserNotAllowed,
	[9] = v5.TransferExpired,
	[10] = v5.TooManyRequests,
	[11] = v5.TransferAlreadyProcessed,
	[12] = v5.InvalidTransferState,
	[13] = v5.AmpRecourseAvailable,
	[14] = v5.TransferDisabledForUser,
	[15] = v5.ReceiverNotAllowed,
	[16] = v5.TransferAmountBelowMinimum,
	[17] = v5.TransferAmountExceedsMaximum,
	[18] = v5.TransferAmountExceedsNonSecuredMaximum,
	[19] = v5.ReceiveLimitExceeded,
	[21] = v5.NoFreeTransfersRemaining
}

function v5.fromValue(value)
	if value == nil then
		return nil
	end

	if type(value) == "number" then
		return v6[value]
	end

	if type(value) == "string" then
		for k, v7 in pairs(v5) do
			if v7 == value then
				return value
			end
		end
	end

	return nil
end

return v5
