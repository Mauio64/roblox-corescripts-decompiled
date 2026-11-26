require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local function getContentType(data): string
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

local function makeRecommendationAttribution(p2, data, p3)
	if p2 == nil then
		return nil
	end

	local feedItemId = p2.feedItemId

	if feedItemId == nil or feedItemId == "" then
		return nil
	end

	return {
		itemId = feedItemId,
		tracingId = p2.tracingId,
		contentType = p3 or data ~= nil and ((data.postAsset == nil or data.postAsset.isAvatar ~= true) and not data.metadata.isMomentScene and (data.entityType == "edpVideo" and "GamePreviewVideo" or data.metadata.partnerUploadType == "influencer" and "DynamicUpload" or data.metadata.captureType == Enum.CaptureType.Screenshot and "Static" or "Dynamic") or "Avatar") or nil
	}
end

return makeRecommendationAttribution
