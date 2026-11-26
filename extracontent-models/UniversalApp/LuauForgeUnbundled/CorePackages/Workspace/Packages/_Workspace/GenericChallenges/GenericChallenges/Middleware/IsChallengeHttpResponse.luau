local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/constants")

return function(p2, p3): boolean
	return p2 == constants.forbiddenStatusCode
		and p3[constants.challengeTypeHeader] ~= nil
		and p3[constants.challengeIdHeader] ~= nil
		and p3[constants.challengeMetadataHeader] ~= nil
end
