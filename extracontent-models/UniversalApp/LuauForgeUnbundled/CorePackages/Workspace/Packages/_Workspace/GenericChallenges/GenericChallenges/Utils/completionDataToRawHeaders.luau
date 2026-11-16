local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/constants")

local base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AuthCommon").Utils.Base64

local HttpService = game:GetService("HttpService")

return function(data)
	assert(data.challengeId ~= nil, "challenge id must not be nil")
	assert(data.challengeType ~= nil, "challenge type must not be nil")
	assert(data.metadata ~= nil, "metadata must not be nil")
	return {
		[constants.challengeIdHeader] = data.challengeId,
		[constants.challengeTypeHeader] = data.challengeType,
		[constants.challengeMetadataHeader] = base64.Encode(HttpService:JSONEncode(data.metadata))
	}
end
