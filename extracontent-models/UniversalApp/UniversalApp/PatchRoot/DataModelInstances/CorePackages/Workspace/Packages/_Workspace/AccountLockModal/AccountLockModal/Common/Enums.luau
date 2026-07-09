local t1 = {
	Locked = "Locked",
	Error = "Error",
	RateLimited = "RateLimited"
}
local t2 = {
	Init = "accountLockModalInit",
	Unlock = "accountUnlockFlowStart",
	Success = "accountUnlockFlowSuccess",
	Error = "accountUnlockFlowError",
	Abandoned = "accountUnlockFlowAbandoned",
	RateLimited = "accountUnlockFlowRateLimited",
	Logout = "accountLockModalLogout",
	DeepLinkReceived = "accountUnlockDeepLinkReceived",
	DeepLinkMismatch = "accountUnlockDeepLinkMismatch"
}

return {
	AccountLockStatusEnum = t1,
	AccountLockEventContextEnum = t2
}
