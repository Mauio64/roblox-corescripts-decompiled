local parent = script:FindFirstAncestor("MomentsCreation").Parent

local createCoachmarkImpressionCache = require(parent.MomentsCommon.createCoachmarkImpressionCache)

return createCoachmarkImpressionCache({ coachmarkId = "tts", dismissedValue = -1 })
