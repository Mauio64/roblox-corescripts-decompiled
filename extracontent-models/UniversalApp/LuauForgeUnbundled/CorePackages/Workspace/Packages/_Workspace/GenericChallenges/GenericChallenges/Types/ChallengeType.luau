local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/addRawValueMethodToEnum")

local v5 = {
	Captcha = "captcha",
	TwoStepVerification = "two-step-verification",
	SecurityQuestions = "security-questions",
	Reauthentication = "reauthentication",
	Generic = "generic"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/enumerate")("ChallengeType", v5)

addRawValueMethodToEnum(v6, v5)

return v6
