local v5 = {
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

for k, v6 in pairs(v5) do
	set[v6] = true
end

function v5.fromValue(p2)
	if p2 == nil or not set[p2] then
		return nil
	end

	return p2
end

return v5
