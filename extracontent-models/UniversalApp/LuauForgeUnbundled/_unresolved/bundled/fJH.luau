local getFIntAccountRecoverySecondsBetweenResends = require("@luauforge/bundled/fJI").GetFIntAccountRecoverySecondsBetweenResends
local module = require("@luauforge/bundled/fJJ")

return {
	UnknownErrorKey = "Authentication.AccountRecovery.MessageUnknownError",
	SecondsBetweenResends = getFIntAccountRecoverySecondsBetweenResends(),
	VerificationCodeLength = 6,
	BackupCodeLength = 9,
	ContentMaxWidth = module()
}
