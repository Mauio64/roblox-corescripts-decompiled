local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local GetFIntAccountRecoverySecondsBetweenResends = require(Parent.SharedFlags).GetFIntAccountRecoverySecondsBetweenResends

return {
	UnknownErrorKey = "Authentication.AccountRecovery.MessageUnknownError",
	VerificationCodeLength = 6,
	BackupCodeLength = 9,
	SecondsBetweenResends = GetFIntAccountRecoverySecondsBetweenResends()
}
