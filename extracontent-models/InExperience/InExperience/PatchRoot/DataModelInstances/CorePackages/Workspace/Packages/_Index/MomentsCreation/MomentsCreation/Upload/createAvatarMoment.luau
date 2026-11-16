local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local Promise = require(parent.Promise)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local createAvatarMomentLook = require(MomentsCreation.Requests.createAvatarMomentLook)
local makePostMetadata = require(MomentsCreation.Utils.makePostMetadata)
require(MomentsCreation.Types.CreationFlowTypes)

local function fireAvatarMomentFailure(p: string, p2: string, p3: string?)
	local v = { status = "GenericFailure", error = `{p}: {p2}` }

	for k, v2 in makeCreationEventFields.makeCreationBaseFields(p3) do
		v[k] = v2
	end

	fireAnalyticsEvent(EventNames.UploadCaptureFailed, v)
end

local function postAvatarMoment(p, outfitId: number, edits, description: string, p2: string?, commentsEnabled: boolean?, p3): boolean
	local postMetadata = makePostMetadata(
		{ description = description, edits = edits, commentsEnabled = commentsEnabled },
		nil,
		p2
	)

	postMetadata.media = {
		{
			avatar = { outfitId = outfitId, cameraData = p.AvatarPost.cameraData }
		}
	}

	local success, result = pcall(function()
		(p3 or game:GetService("MomentsService")):CreatePostAsync(postMetadata)
	end)

	if success then
		local creationBaseFields = makeCreationEventFields.makeCreationBaseFields(p2)
		creationBaseFields.captureType = "avatar"
		fireAnalyticsEvent(EventNames.EditingFlowMomentPublished, creationBaseFields)
		return true
	end

	warn(`[MomentsCreation] Avatar Moment post failed: {tostring(result)}`)
	fireAvatarMomentFailure("AvatarPostFailed", tostring(result), p2)
	return false
end

local function createAvatarMoment(p, edits, description: string, p2: string?, commentsEnabled: boolean?, p3)
	local success, result = pcall(p.AvatarPost.getLookRequest)

	if success then
		return createAvatarMomentLook(result):andThen(function(p4)
			if p4.statusCode < 200 or p4.statusCode >= 300 then
				warn(`[MomentsCreation] Avatar Look creation failed with HTTP {p4.statusCode}`)
				fireAvatarMomentFailure("AvatarPostLookCreationFailed", `HTTP {p4.statusCode}`, p2)
				return false
			else
				if p4.outfitId ~= nil and not (p4.outfitId <= 0) then
					return postAvatarMoment(p, p4.outfitId, edits, description, p2, commentsEnabled, p3)
				end

				warn("[MomentsCreation] Avatar Look response is missing a positive outfitId")
				local v = {
					status = "GenericFailure",
					error = "AvatarPostLookCreationFailed: MissingPositiveOutfitId"
				}

				for k, v2 in makeCreationEventFields.makeCreationBaseFields(p2) do
					v[k] = v2
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, v)

				return false
			end
		end):catch(function(p4): boolean
			warn(`[MomentsCreation] Avatar Look request failed: {tostring(p4)}`)
			local v = {
				status = "GenericFailure",
				error = `AvatarPostLookCreationFailed: {tostring(p4)}`
			}

			for k, v2 in makeCreationEventFields.makeCreationBaseFields(p2) do
				v[k] = v2
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, v)

			return false
		end)
	end

	warn(`[MomentsCreation] Failed to build Avatar Look request: {tostring(result)}`)
	local v = {
		status = "GenericFailure",
		error = `AvatarPostLookCreationFailed: {tostring(result)}`
	}

	for k, v2 in makeCreationEventFields.makeCreationBaseFields(p2) do
		v[k] = v2
	end

	fireAnalyticsEvent(EventNames.UploadCaptureFailed, v)

	return Promise.resolve(false)
end

return createAvatarMoment
