local FailureReason = {
	Invalid = "Invalid",
	InvalidInput = "InvalidInput",
	GiftNotFound = "GiftNotFound",
	Unauthorized = "Unauthorized",
	InternalError = "InternalError",
	InsufficientFunds = "InsufficientFunds",
	GiftingDisabledForUser = "GiftingDisabledForUser",
	ReceiverNotAllowed = "ReceiverNotAllowed",
	AmpRecourseAvailable = "AmpRecourseAvailable",
	ChallengeRequired = "ChallengeRequired",
	InvalidGiftState = "InvalidGiftState",
	GiftExpired = "GiftExpired",
	TooManyRequests = "TooManyRequests",
	AllItemsInvalid = "AllItemsInvalid",
	ItemUnavailable = "ItemUnavailable",
	MaxGiftItemsExceeded = "MaxGiftItemsExceeded",
	EndpointDisabled = "EndpointDisabled",
	DependencyUnavailable = "DependencyUnavailable"
}

local set = {}

for _, v in pairs(FailureReason) do
	set[v] = true
end

function FailureReason.fromValue(p: string?)
	return if not (p == nil or not set[p]) then p else nil
end

return FailureReason
