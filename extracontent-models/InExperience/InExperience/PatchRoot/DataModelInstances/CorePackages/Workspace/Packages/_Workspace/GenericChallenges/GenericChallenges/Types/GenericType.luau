local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local Utils = GenericChallenges.Utils
local addRawValueMethodToEnum = require(Utils.addRawValueMethodToEnum)
local enumerate = require(parent.enumerate)

local v = {
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

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
