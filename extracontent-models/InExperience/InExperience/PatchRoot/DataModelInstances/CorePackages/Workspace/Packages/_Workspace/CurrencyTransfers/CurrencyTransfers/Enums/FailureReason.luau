local FailureReason = {
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
	TransferAmountExceedsNonSecuredMaximum = "TransferAmountExceedsNonSecuredMaximum"
}

local v = {
	[0] = FailureReason.Invalid,
	[1] = FailureReason.InvalidInput,
	[2] = FailureReason.TransferNotFound,
	[3] = FailureReason.Unauthorized,
	[4] = FailureReason.InternalError,
	[5] = FailureReason.TransferDailyLimitExceeded,
	[6] = FailureReason.TransferMonthlyLimitExceeded,
	[7] = FailureReason.InsufficientFunds,
	[8] = FailureReason.UserNotAllowed,
	[9] = FailureReason.TransferExpired,
	[10] = FailureReason.TooManyRequests,
	[11] = FailureReason.TransferAlreadyProcessed,
	[12] = FailureReason.InvalidTransferState,
	[13] = FailureReason.AmpRecourseAvailable,
	[14] = FailureReason.TransferDisabledForUser,
	[15] = FailureReason.ReceiverNotAllowed,
	[16] = FailureReason.TransferAmountBelowMinimum,
	[17] = FailureReason.TransferAmountExceedsMaximum,
	[18] = FailureReason.TransferAmountExceedsNonSecuredMaximum,
	[19] = FailureReason.ReceiveLimitExceeded
}

function FailureReason.fromValue(value)
	if value == nil then
		return nil
	end

	if type(value) == "number" then
		return v[value]
	end

	if type(value) == "string" then
		for _, v2 in pairs(FailureReason) do
			if v2 == value then
				return value
			end
		end
	end

	return nil
end

return FailureReason
