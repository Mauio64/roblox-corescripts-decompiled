local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local MomentsTypes = require(parent.MomentsTypes)
local React = require(parent.React)

local useLocalization = Localization.Hooks.useLocalization

local MomentsCreation = require(parent.MomentsCreation)
local SharedFlags = require(parent.SharedFlags)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)
local publishMomentWithUpload = MomentsCreation.publishMomentWithUpload
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GetFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local generateMomentText = require(Moments.generateMomentText)
local momentGeneratedTextFeedback = require(Moments.Feedback.momentGeneratedTextFeedback)
local refreshOwnMomentsAfterPublish = require(Moments.Upload.refreshOwnMomentsAfterPublish)
local setPublishedMomentOnUploadStore = require(Moments.Upload.setPublishedMomentOnUploadStore)
local postLifecycleSubscription = require(Moments.Upload.postLifecycleSubscription)
local createPublishedPostResolver = require(Moments.Upload.createPublishedPostResolver)
local FFlagMomentsHydratePublishedFeedItem = require(Moments.Flags.FFlagMomentsHydratePublishedFeedItem)

local FFlagMomentsRefreshOwnMomentsAfterPublish = SharedFlags.FFlagMomentsRefreshOwnMomentsAfterPublish
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsRefreshProfileOnPostStatus = SharedFlags.FFlagMomentsRefreshProfileOnPostStatus
local FFlagMomentsResolvePublishedPostFeedItem = SharedFlags.FFlagMomentsResolvePublishedPostFeedItem

local GetUploadStore = require(Moments.Stores.GetUploadStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
require(Moments.Stores.GetToastStore.createToastStore)

local isStudio = require(parent.MomentsCommon.isStudio)
local getLocalUserId = require(Moments.Utils.getLocalUserId)

local v = {
	publishingTitle = "Feature.Moments.Label.RodeoPublishingTitle",
	publishingBody = "Feature.Moments.Label.PublishingRodeoBody",
	publishedTitle = "Feature.Moments.Label.MomentPublishedTitle",
	publishedBody = "Feature.Moments.Label.MomentPublishedBody",
	failedTitle = "Feature.Moments.Label.MomentFailedToPostTitle",
	failedBody = "Feature.Moments.Label.MomentFailedToPostBody",
	removedTitle = "Feature.Moments.Title.MomentRemoved",
	removedBody = "Feature.Moments.Label.PostRemovedBody",
	uploadQuotaReachedBody = "Feature.Moments.Description.TooManyUploads",
	generateInProgressTitle = "Feature.Moments.Label.TextGenerateInProgressTitle",
	generateInProgressBody = "Feature.Moments.Label.TextGenerateInProgressBody",
	generatedTitle = "Feature.Moments.Label.TextGeneratedTitle",
	generatedBody = "Feature.Moments.Label.TextGeneratedBody",
	generateFailedTitle = "Feature.Moments.Label.TextGenerationFailedTitle",
	generateFailedBody = "Feature.Moments.Label.TextGenerationFailedBody",
	generateFilteredTitle = "Feature.Moments.Label.TextGenerationFilteredTitle",
	generateFilteredBody = "Feature.Moments.Label.TextGenerationFilteredBody",
	generateOverrideTitle = "Feature.Moments.Label.TextGenerateOverrideTitle",
	generateOverrideBody = "Feature.Moments.Label.TextGenerateOverrideBody"
}

local studio = isStudio()
local MomentStatus = MomentsTypes.Enums.MomentStatus

local function makeUploadedMomentItem(assetId: number, data, edits, description: string, assetTotalDuration: number?)
	local momentId = tostring(assetId)
	local localPlayer = Players.LocalPlayer
	local uploadedMomentItem = {
		assetId = assetId,
		creatorId = localPlayer == nil and 0 or localPlayer.UserId,
		metadata = 0,
		momentId = 0,
		recommendationMetadata = 0,
		status = 0
	}

	if data.CaptureType == Enum.CaptureType.Screenshot then
		assetTotalDuration = MomentsCreation.Constants.ScreenshotMusicDuration
	elseif assetTotalDuration == nil or not (assetTotalDuration > 0) then
		assetTotalDuration = data.TimeLength
	end

	uploadedMomentItem.metadata = {
		assetTotalDuration = assetTotalDuration,
		captureType = data.CaptureType,
		description = description,
		edits = edits,
		placeId = data.SourcePlaceId,
		universeId = data.SourceUniverseId
	}

	uploadedMomentItem.momentId = momentId

	uploadedMomentItem.recommendationMetadata = {}
	uploadedMomentItem.status = MomentStatus.Public
	return uploadedMomentItem
end

local function makePendingMomentItem(p, edits, description: string, p2: number?) -- 1 equivalent call inferred from this helper
	local uploadedMomentItem = makeUploadedMomentItem(0, p, edits, description, p2)
	uploadedMomentItem.momentId = HttpService:GenerateGUID(false)
	uploadedMomentItem.status = MomentStatus.Pending

	local success, result = pcall(Content.fromObject, p)

	if success then
		uploadedMomentItem.localContent = result
	end

	return uploadedMomentItem
end

local function setPublishedPostOnUploadStore(p, p2, p3: string?)
	local resolved = p.resolve(p3)

	if not p.isCurrent() then
		return
	end

	if FFlagMomentsOptimisticProfilePending and p3 ~= nil then
		p2.reset()
	elseif resolved == nil then
		p2.reset()
	else
		p2.setSuccess(resolved)
	end
end

local function makeUploadStore(data, p, edits, description: string, p2: number?)
	local v2

	if FFlagMomentsResolvePublishedPostFeedItem and GetFFlagMomentsUseUploadPostAsync() then
		v2 = createPublishedPostResolver({
			captureType = p.CaptureType,
			description = description,
			edits = edits,
			placeId = p.SourcePlaceId
		})
	else
		v2 = nil
	end

	local momentId = nil
	local v3 = nil
	local setUploading

	if FFlagMomentsRefreshProfileOnPostStatus or v2 ~= nil then
		setUploading = function()
			if FFlagMomentsRefreshProfileOnPostStatus or FFlagMomentsOptimisticProfilePending and v2 ~= nil then
				postLifecycleSubscription.subscribe()
			end

			if v2 ~= nil then
				v2.captureSnapshot()
			end

			data.setUploading()

			if FFlagMomentsOptimisticProfilePending and v2 ~= nil and momentId == nil then
				local localUserId = getLocalUserId()

				if localUserId ~= nil then
					local pendingMomentItem = makePendingMomentItem(p, edits, description, p2) -- inferred equivalent call
					momentId = pendingMomentItem.momentId
					v3 = localUserId
					MomentsGetMomentsUserStore(false).prependPendingUserMoment(localUserId, pendingMomentItem)
				end
			end
		end
	else
		setUploading = data.setUploading
	end

	local setFailed

	if FFlagMomentsOptimisticProfilePending and v2 ~= nil then
		setFailed = function(p3)
			if v3 ~= nil and momentId ~= nil then
				MomentsGetMomentsUserStore(false).removePendingUserMoment(v3, momentId)
			end

			if v2.isCurrent() then
				data.setFailed(p3)
			end
		end
	else
		setFailed = data.setFailed
	end

	return {
		setUploading = setUploading,
		setFailed = setFailed,
		setSuccess = function(assetId)
			if type(assetId) ~= "number" then
				data.setSuccess(assetId)
				return
			end

			if FFlagMomentsOptimisticProfilePending and v3 ~= nil and momentId ~= nil then
				local v4 = v3
				local v5 = momentId

				task.delay(300, function()
					local momentsGetMomentsUserStore = MomentsGetMomentsUserStore(false)
					momentsGetMomentsUserStore.removePendingUserMoment(v4, v5)
					momentsGetMomentsUserStore.invalidateUser(v4)
				end)
			end

			if v2 ~= nil then
				task.spawn(setPublishedPostOnUploadStore, v2, data, momentId)
				return
			end

			if FFlagMomentsHydratePublishedFeedItem then
				task.spawn(setPublishedMomentOnUploadStore, assetId, data)
				return
			end

			data.setSuccess(makeUploadedMomentItem(assetId, p, edits, description, p2))

			if FFlagMomentsRefreshOwnMomentsAfterPublish then
				task.spawn(refreshOwnMomentsAfterPublish, assetId)
			end
		end
	}
end

local function useUploadHost(p)
	local onExit = p.onExit
	local captureSource = p.captureSource

	local localizations = useLocalization(v)
	local ref

	if GetFFlagEnableMomentTextGeneration() then
		ref = React.useRef({})
	else
		ref = nil
	end

	return (React.useMemo(function()
		local uploadStore = GetUploadStore(false)
		local toastStore = GetToastStore(false)

		local fFlagEnableMomentTextGeneration = GetFFlagEnableMomentTextGeneration()

		local function triggerGenerationToast(p2) -- 5 equivalent calls inferred from this helper
			local v2 = toastStore.triggerToast(p2)

			if ref ~= nil then
				table.insert(ref.current, v2)
			end
		end

		local v2 = {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			generateMomentText = nil,
			momentGeneratedTextFeedback = nil,
			onGenerateTextManualEditBlocked = 0,
			onGenerateTextSuccess = 0,
			onGenerateTextFailure = 0,
			onGenerateTextFiltered = 0,
			onGenerateTextWillReplaceInput = 0,
			dismissGenerationToasts = 0,
			isTextFiltered = 0,
			createMoment = 0
		}
		local generateMomentText2

		if fFlagEnableMomentTextGeneration then
			generateMomentText2 = generateMomentText
		end

		v2.generateMomentText = generateMomentText2
		local momentGeneratedTextFeedback2

		if fFlagEnableMomentTextGeneration then
			momentGeneratedTextFeedback2 = momentGeneratedTextFeedback
		end

		v2.momentGeneratedTextFeedback = momentGeneratedTextFeedback2
		v2.onGenerateTextManualEditBlocked = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateInProgressTitle,
				text = localizations.generateInProgressBody
			})
		end or nil

		v2.onGenerateTextSuccess = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generatedTitle,
				text = localizations.generatedBody
			})
		end or nil

		v2.onGenerateTextFailure = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateFailedTitle,
				text = localizations.generateFailedBody
			})
		end or nil

		v2.onGenerateTextFiltered = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateFilteredTitle,
				text = localizations.generateFilteredBody
			})
		end or nil

		v2.onGenerateTextWillReplaceInput = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateOverrideTitle,
				text = localizations.generateOverrideBody
			})
		end or nil

		v2.dismissGenerationToasts = fFlagEnableMomentTextGeneration and function()
			if ref ~= nil then
				for _, v3 in ref.current do
					toastStore.dismissToast(v3)
				end

				ref.current = {}
			end
		end or nil

		v2.isTextFiltered = MomentsCreation.isTextFiltered
		v2.createMoment = studio and function(_, _, p2: string, _: string?, _: number?)
			print(`[moments-creation] dev publish (not uploaded): "{p2}"`)
		end or function(p2, edits, description: string, creationSessionId: string?, resolvedTimeLength: number?, commentsEnabled: boolean?)
			publishMomentWithUpload(p2, edits, description, {
				localizations = localizations,
				uploadStore = makeUploadStore(uploadStore, p2, edits, description, resolvedTimeLength),
				toastStore = toastStore,
				creationSessionId = creationSessionId,
				resolvedTimeLength = resolvedTimeLength,
				commentsEnabled = commentsEnabled
			})
		end
		return v2
	end, { onExit, captureSource, localizations }))
end

return useUploadHost
