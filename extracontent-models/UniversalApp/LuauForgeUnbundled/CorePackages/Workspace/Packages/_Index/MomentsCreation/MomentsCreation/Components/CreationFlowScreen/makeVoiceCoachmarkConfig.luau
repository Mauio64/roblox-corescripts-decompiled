require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local MomentsTTSCoachmarkImpressionCache = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Storage/MomentsTTSCoachmarkImpressionCache")

local function makeVoiceCoachmarkConfig(p2, p3)
	if p2 and p3 then
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
