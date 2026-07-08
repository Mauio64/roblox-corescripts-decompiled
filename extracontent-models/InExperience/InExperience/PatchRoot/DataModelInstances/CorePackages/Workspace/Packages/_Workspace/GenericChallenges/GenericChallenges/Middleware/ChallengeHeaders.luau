local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local constants = require(GenericChallenges.Utils.constants)
local GenericType = require(GenericChallenges.Types.GenericType)
local GenericChallengesParent = GenericChallenges.Parent
local Base64 = require(GenericChallengesParent.AuthCommon).Utils.Base64
local HttpService = game:GetService("HttpService")
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 41
	-- upvalues: constants (copy), Base64 (copy), HttpService (copy), GenericType (copy), t1 (copy)
	local t3 = {
		challengeId = t2[constants.challengeIdHeader]
	}
	local v10 = Base64.Decode(t2[constants.challengeMetadataHeader])

	t3.challengeMetadata = {
		raw = t2[constants.challengeMetadataHeader],
		decoded = v10,
		typed = HttpService:JSONDecode(v10)
	}
	t3.challengeType = {
		raw = t2[constants.challengeTypeHeader],
		typed = GenericType.fromRawValue(t2[constants.challengeTypeHeader])
	}

	return (setmetatable(t3, t1))
end

return t1
