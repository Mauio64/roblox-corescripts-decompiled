local parent = script:FindFirstAncestor("Moments").Parent

local createCoachmarkImpressionCache = require(parent.MomentsCommon.createCoachmarkImpressionCache)

return createCoachmarkImpressionCache({ coachmarkId = "post_insights", dismissedValue = -1 })
