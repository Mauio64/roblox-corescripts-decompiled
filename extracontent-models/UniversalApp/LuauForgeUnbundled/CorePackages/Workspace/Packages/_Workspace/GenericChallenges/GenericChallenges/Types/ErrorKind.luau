local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/addRawValueMethodToEnum")

local v5 = {
	Unknown = "Unknown",
	Invalidated = "Invalidated",
	Abandoned = "Abandoned",
	LoadFailed = "LoadFailed"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/enumerate")("ErrorKind", v5)

addRawValueMethodToEnum(v6, v5)

return v6
