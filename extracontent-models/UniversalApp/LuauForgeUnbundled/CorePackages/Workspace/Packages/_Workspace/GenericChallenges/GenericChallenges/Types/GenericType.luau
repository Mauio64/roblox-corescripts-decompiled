local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/addRawValueMethodToEnum")

local v5 = {
	Captcha = "captcha",
	TwoStepVerification = "twostepverification",
	SecurityQuestions = "securityquestions",
	Reauthentication = "reauthentication",
	ProofOfWork = "proofofwork",
	ForceAuthenticator = "forceauthenticator",
	ForceTwoStepVerification = "forcetwostepverification",
	DeviceIntegrity = "deviceintegrity",
	DeviceAccessToken = "deviceaccesstoken",
	Denied = "denied",
	EmailVerification = "emailverification",
	PhoneVerification = "phoneverification",
	PrivateAccessToken = "privateaccesstoken",
	BlockSession = "blocksession",
	CaptchaV2 = "captchav2",
	Turnstile = "turnstile",
	RoCaptcha = "rocaptcha"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/enumerate")("GenericType", v5)

addRawValueMethodToEnum(v6, v5)

return v6
