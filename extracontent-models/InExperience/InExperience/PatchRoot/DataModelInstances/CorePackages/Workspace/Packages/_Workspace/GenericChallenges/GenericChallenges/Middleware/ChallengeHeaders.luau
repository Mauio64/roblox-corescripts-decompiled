local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local constants = require(GenericChallenges.Utils.constants)
local GenericType = require(GenericChallenges.Types.GenericType)
local parent = GenericChallenges.Parent

local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64

local HttpService = game:GetService("HttpService")

local ChallengeHeaders = {}
ChallengeHeaders.__index = ChallengeHeaders

function ChallengeHeaders.new(p)
	local v = {}
	v.challengeId = p[constants.challengeIdHeader]
	local decoded = Base64.Decode(p[constants.challengeMetadataHeader])
	v.challengeMetadata = {
		raw = p[constants.challengeMetadataHeader],
		decoded = decoded,
		typed = HttpService:JSONDecode(decoded)
	}

	v.challengeType = {
		raw = p[constants.challengeTypeHeader],
		typed = GenericType.fromRawValue(p[constants.challengeTypeHeader])
	}

	return (setmetatable(v, ChallengeHeaders))
end

return ChallengeHeaders
