local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local constants = require(GenericChallenges.Utils.constants)

return function(n1: number, t1: {[any]: any}) -- line: 7
	-- upvalues: constants (copy)
	return n1 == constants.forbiddenStatusCode and (t1[constants.challengeTypeHeader] ~= nil and (t1[constants.challengeIdHeader] ~= nil and t1[constants.challengeMetadataHeader] ~= nil))
end
