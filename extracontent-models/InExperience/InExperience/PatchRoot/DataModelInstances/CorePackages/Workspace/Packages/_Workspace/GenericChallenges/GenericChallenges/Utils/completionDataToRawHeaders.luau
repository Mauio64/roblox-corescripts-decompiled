local constants = require(script.Parent.constants)
local Parent = script:FindFirstAncestor("GenericChallenges").Parent
local Base64 = require(Parent.AuthCommon).Utils.Base64
local HttpService = game:GetService("HttpService")

return function(t1: {[any]: any}) -- line: 11
	-- upvalues: constants (copy), Base64 (copy), HttpService (copy)
	assert(t1.challengeId ~= nil, "challenge id must not be nil")
	assert(t1.challengeType ~= nil, "challenge type must not be nil")
	assert(t1.metadata ~= nil, "metadata must not be nil")

	return {
		[constants.challengeIdHeader] = t1.challengeId,
		[constants.challengeTypeHeader] = t1.challengeType,
		[constants.challengeMetadataHeader] = Base64.Encode(HttpService:JSONEncode(t1.metadata))
	}
end
