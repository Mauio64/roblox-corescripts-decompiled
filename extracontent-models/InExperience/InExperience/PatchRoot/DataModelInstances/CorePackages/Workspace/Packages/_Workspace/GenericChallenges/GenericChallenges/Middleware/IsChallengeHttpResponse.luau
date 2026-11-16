local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local constants = require(GenericChallenges.Utils.constants)

return function(p: number, p2): boolean
	return p == constants.forbiddenStatusCode
		and p2[constants.challengeTypeHeader] ~= nil
		and p2[constants.challengeIdHeader] ~= nil
		and p2[constants.challengeMetadataHeader] ~= nil
end
