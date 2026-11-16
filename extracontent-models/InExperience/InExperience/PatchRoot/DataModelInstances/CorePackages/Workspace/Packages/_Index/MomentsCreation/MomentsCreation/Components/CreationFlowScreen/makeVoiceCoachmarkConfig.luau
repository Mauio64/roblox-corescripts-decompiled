local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsCommon)
local MomentsTTSCoachmarkImpressionCache = require(MomentsCreation.Storage.MomentsTTSCoachmarkImpressionCache)

local function makeVoiceCoachmarkConfig(flag: boolean, flag2: boolean)
	if flag and flag2 then
		return {
			kind = "voice",
			titleKey = "Feature.Moments.Label.VoiceCoachmarkTitle",
			textKey = "Feature.Moments.Label.VoiceCoachmarkBody",
			impressionCache = MomentsTTSCoachmarkImpressionCache
		}
	end

	return nil
end

return makeVoiceCoachmarkConfig
