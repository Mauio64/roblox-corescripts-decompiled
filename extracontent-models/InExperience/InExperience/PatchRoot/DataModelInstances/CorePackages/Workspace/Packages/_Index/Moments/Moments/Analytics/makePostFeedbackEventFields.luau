local parent = script:FindFirstAncestor("Moments").Parent

require(parent.MomentsCommon)
require(parent.MomentsTypes)

local function makePostFeedbackEventFields(data)
	local publishedMoment = data.publishedMoment
	local feedItemId

	if publishedMoment ~= nil then
		feedItemId = publishedMoment.recommendationMetadata.feedItemId
	end

	local postFeedbackEventFields = {
		creationSessionId = data.creationSessionId,
		localId = data.localId,
		captureType = 0,
		momentId = 0,
		feedItemId = 0
	}
	local captureType

	if data.captureType ~= nil then
		captureType = data.captureType.Name
	end

	postFeedbackEventFields.captureType = captureType
	local momentId

	if publishedMoment ~= nil then
		momentId = publishedMoment.momentId
	end

	postFeedbackEventFields.momentId = momentId

	if feedItemId == nil or feedItemId == "" then
		feedItemId = nil
	end

	postFeedbackEventFields.feedItemId = feedItemId
	return postFeedbackEventFields
end

return makePostFeedbackEventFields
