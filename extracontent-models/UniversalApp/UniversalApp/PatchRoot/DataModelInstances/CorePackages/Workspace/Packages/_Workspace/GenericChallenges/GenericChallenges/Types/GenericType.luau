local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericChallengesParent = GenericChallenges.Parent
local Utils = GenericChallenges.Utils
local addRawValueMethodToEnum = require(Utils.addRawValueMethodToEnum)
local enumerate = require(GenericChallengesParent.enumerate)
local t1 = {
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
	Turnstile = "turnstile"
}
local v7 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v7, t1)

return v7
