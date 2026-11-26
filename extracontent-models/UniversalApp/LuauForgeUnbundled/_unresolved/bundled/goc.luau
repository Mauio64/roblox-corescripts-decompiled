local getFIntAccountRecoverySecondsBetweenResends = require("@luauforge/bundled/god").GetFIntAccountRecoverySecondsBetweenResends
local module = require("@luauforge/bundled/goe")

return {
	UnknownErrorKey = "Authentication.AccountRecovery.MessageUnknownError",
	SecondsBetweenResends = getFIntAccountRecoverySecondsBetweenResends(),
	VerificationCodeLength = 6,
	BackupCodeLength = 9,
	ContentMaxWidth = module()
}
