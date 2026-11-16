local constants = require(script.Parent.constants)
local parent = script:FindFirstAncestor("GenericChallenges").Parent

local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64

local HttpService = game:GetService("HttpService")

return function(data)
	assert(data.challengeId ~= nil, "challenge id must not be nil")
	assert(data.challengeType ~= nil, "challenge type must not be nil")
	assert(data.metadata ~= nil, "metadata must not be nil")
	return {
		[constants.challengeIdHeader] = data.challengeId,
		[constants.challengeTypeHeader] = data.challengeType,
		[constants.challengeMetadataHeader] = Base64.Encode(HttpService:JSONEncode(data.metadata))
	}
end
