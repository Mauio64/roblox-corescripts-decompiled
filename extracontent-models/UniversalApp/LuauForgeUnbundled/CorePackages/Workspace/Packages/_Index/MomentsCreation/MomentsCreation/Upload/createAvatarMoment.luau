local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Promise")

local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local createAvatarMomentLook = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Requests/createAvatarMomentLook")
local makePostMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makePostMetadata")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function fireAvatarMomentFailure(p2, p3, p4)
	local v5 = { status = "GenericFailure", error = `{p2}: {p3}` }

	for k, v6 in makeCreationEventFields.makeCreationBaseFields(p4) do
		v5[k] = v6
	end

	fireAnalyticsEvent(eventNames.UploadCaptureFailed, v5)
end

local function postAvatarMoment(p2, outfitId, p3, p4, p5, p6, p7): boolean
	local v5 = makePostMetadata({ description = p4, edits = p3, commentsEnabled = p6 }, nil, p5)

	v5.media = {
		{
			avatar = { outfitId = outfitId, cameraData = p2.AvatarPost.cameraData }
		}
	}

	local success, result = pcall(function()
		(p7 or game:GetService("MomentsService")):CreatePostAsync(v5)
	end)

	if success then
		local creationBaseFields = makeCreationEventFields.makeCreationBaseFields(p5)
		creationBaseFields.captureType = "avatar"
		fireAnalyticsEvent(eventNames.EditingFlowMomentPublished, creationBaseFields)
		return true
	end

	warn(`[MomentsCreation] Avatar Moment post failed: {tostring(result)}`)
	fireAvatarMomentFailure("AvatarPostFailed", tostring(result), p5)
	return false
end

local function createAvatarMoment(p2, p3, p4, p5, p6, p7)
	local success, result = pcall(p2.AvatarPost.getLookRequest)

	if success then
		return createAvatarMomentLook(result):andThen(function(p8)
			if p8.statusCode < 200 or p8.statusCode >= 300 then
				warn(`[MomentsCreation] Avatar Look creation failed with HTTP {p8.statusCode}`)
				fireAvatarMomentFailure("AvatarPostLookCreationFailed", `HTTP {p8.statusCode}`, p5)
				return false
			else
				if p8.outfitId ~= nil and not (p8.outfitId <= 0) then
					return postAvatarMoment(p2, p8.outfitId, p3, p4, p5, p6, p7)
				end

				warn("[MomentsCreation] Avatar Look response is missing a positive outfitId")
				local v6 = {
					status = "GenericFailure",
					error = "AvatarPostLookCreationFailed: MissingPositiveOutfitId"
				}

				for k, v7 in makeCreationEventFields.makeCreationBaseFields(p5) do
					v6[k] = v7
				end

				fireAnalyticsEvent(eventNames.UploadCaptureFailed, v6)

				return false
			end
		end):catch(function(p8): boolean
			warn(`[MomentsCreation] Avatar Look request failed: {tostring(p8)}`)
			local v7 = {
				status = "GenericFailure",
				error = `AvatarPostLookCreationFailed: {tostring(p8)}`
			}

			for k, v8 in makeCreationEventFields.makeCreationBaseFields(p5) do
				v7[k] = v8
			end

			fireAnalyticsEvent(eventNames.UploadCaptureFailed, v7)

			return false
		end)
	end

	warn(`[MomentsCreation] Failed to build Avatar Look request: {tostring(result)}`)
	local v5 = {
		status = "GenericFailure",
		error = `AvatarPostLookCreationFailed: {tostring(result)}`
	}

	for k, v6 in makeCreationEventFields.makeCreationBaseFields(p5) do
		v5[k] = v6
	end

	fireAnalyticsEvent(eventNames.UploadCaptureFailed, v5)

	return Promise.resolve(false)
end

return createAvatarMoment
