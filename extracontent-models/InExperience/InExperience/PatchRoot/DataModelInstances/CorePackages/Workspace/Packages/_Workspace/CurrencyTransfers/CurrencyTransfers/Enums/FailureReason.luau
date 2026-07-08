local t1 = {
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
local t2 = {
	[0] = t1.Invalid,
	[1] = t1.InvalidInput,
	[2] = t1.TransferNotFound,
	[3] = t1.Unauthorized,
	[4] = t1.InternalError,
	[5] = t1.TransferDailyLimitExceeded,
	[6] = t1.TransferMonthlyLimitExceeded,
	[7] = t1.InsufficientFunds,
	[8] = t1.UserNotAllowed,
	[9] = t1.TransferExpired,
	[10] = t1.TooManyRequests,
	[11] = t1.TransferAlreadyProcessed,
	[12] = t1.InvalidTransferState,
	[13] = t1.AmpRecourseAvailable,
	[14] = t1.TransferDisabledForUser,
	[15] = t1.ReceiverNotAllowed,
	[16] = t1.TransferAmountBelowMinimum,
	[17] = t1.TransferAmountExceedsMaximum,
	[18] = t1.TransferAmountExceedsNonSecuredMaximum,
	[19] = t1.ReceiveLimitExceeded
}

function t1.fromValue(p1) -- line: 71
	-- upvalues: t2 (copy), t1 (copy)
	if p1 == nil then
		return nil
	end

	if type(p1) == "number" then
		return t2[p1]
	end

	if type(p1) == "string" then
		for _, v in pairs(t1) do
			if v == p1 then
				return p1
			end
		end
	end

	return nil
end

return t1
