local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsTypes)

require(Moments.Components.Feed.FeedTypes)

local function getContentType(data): string -- 1 equivalent call inferred from this helper
	if data.postAsset ~= nil and data.postAsset.isAvatar == true or data.metadata.isMomentScene then
		return "Avatar"
	end

	if data.entityType == "edpVideo" then
		return "GamePreviewVideo"
	end

	if data.metadata.partnerUploadType == "influencer" then
		return "DynamicUpload"
	end

	if data.metadata.captureType == Enum.CaptureType.Screenshot then
		return "Static"
	end

	return "Dynamic"
end

local function makeRecommendationAttribution(p, data, p2)
	if p == nil then
		return nil
	end

	local feedItemId = p.feedItemId

	if feedItemId == nil or feedItemId == "" then
		return nil
	end

	return {
		itemId = feedItemId,
		tracingId = p.tracingId,
		contentType = p2 or data ~= nil and getContentType(data) or nil -- inferred equivalent call
	}
end

return makeRecommendationAttribution
