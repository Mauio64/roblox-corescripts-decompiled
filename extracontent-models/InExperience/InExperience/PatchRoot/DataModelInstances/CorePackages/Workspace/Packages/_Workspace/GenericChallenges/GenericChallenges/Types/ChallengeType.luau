local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local Utils = GenericChallenges.Utils
local addRawValueMethodToEnum = require(Utils.addRawValueMethodToEnum)
local enumerate = require(parent.enumerate)

local v = {
	Captcha = "captcha",
	TwoStepVerification = "two-step-verification",
	SecurityQuestions = "security-questions",
	Reauthentication = "reauthentication",
	Generic = "generic"
}

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
