local t1 = {
	Unknown = 0,
	Success = 1,
	Failure = 2,
	RequiresManualReview = 3,
	RequiresRetry = 4,
	Started = 5,
	Submitted = 6,
	Stored = 7,
	Expired = 8
}
local t2 = {
	None = 0,
	UnknownError = 1,
	InvalidDocument = 2,
	InvalidSelfie = 3,
	BelowMinimumAge = 4,
	LowQualityMedia = 5
}

return {
	IDVSessionStatusEnum = t1,
	IDVSessionErrorEnum = t2
}
