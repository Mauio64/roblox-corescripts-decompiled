require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function makePostFeedbackEventFields(data)
	local publishedMoment = data.publishedMoment
	local feedItemId = if publishedMoment ~= nil then publishedMoment.recommendationMetadata.feedItemId else nil
	local postFeedbackEventFields = {
		creationSessionId = data.creationSessionId,
		localId = data.localId,
		captureType = 0,
		momentId = 0,
		feedItemId = 0
	}

	local v5 = if data.captureType ~= nil then data.captureType.Name else nil
	postFeedbackEventFields.captureType = v5
	local v6 = if publishedMoment ~= nil then publishedMoment.momentId else nil
	postFeedbackEventFields.momentId = v6

	if feedItemId == nil or feedItemId == "" then
		feedItemId = nil
	end

	postFeedbackEventFields.feedItemId = feedItemId
	return postFeedbackEventFields
end

return makePostFeedbackEventFields
