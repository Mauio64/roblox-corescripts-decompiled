local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/constants")
local GenericType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/GenericType")

local base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AuthCommon").Utils.Base64

local HttpService = game:GetService("HttpService")

local class = {}
class.__index = class

function class.new(p2)
	local v5 = {}
	v5.challengeId = p2[constants.challengeIdHeader]
	local decoded = base64.Decode(p2[constants.challengeMetadataHeader])
	v5.challengeMetadata = {
		raw = p2[constants.challengeMetadataHeader],
		decoded = decoded,
		typed = HttpService:JSONDecode(decoded)
	}

	v5.challengeType = {
		raw = p2[constants.challengeTypeHeader],
		typed = GenericType.fromRawValue(p2[constants.challengeTypeHeader])
	}

	return (setmetatable(v5, class))
end

return class
