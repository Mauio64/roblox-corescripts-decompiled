local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useLocalization = Localization.Hooks.useLocalization

local MomentsCreation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCreation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")
local publishMomentWithUpload = MomentsCreation.publishMomentWithUpload
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local getFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/generateMomentText")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Feedback/momentGeneratedTextFeedback")
local refreshOwnMomentsAfterPublish = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/refreshOwnMomentsAfterPublish")
local setPublishedMomentOnUploadStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/setPublishedMomentOnUploadStore")
local postLifecycleSubscription = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/postLifecycleSubscription")
local createPublishedPostResolver = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/createPublishedPostResolver")
local FFlagMomentsHydratePublishedFeedItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsHydratePublishedFeedItem")

local fFlagMomentsRefreshOwnMomentsAfterPublish = SharedFlags.FFlagMomentsRefreshOwnMomentsAfterPublish
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsRefreshProfileOnPostStatus = SharedFlags.FFlagMomentsRefreshProfileOnPostStatus
local fFlagMomentsResolvePublishedPostFeedItem = SharedFlags.FFlagMomentsResolvePublishedPostFeedItem

local GetUploadStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetUploadStore")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore/createToastStore")

local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")

local v5 = {
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

local v6 = isStudio()
local momentStatus = MomentsTypes.Enums.MomentStatus

local function makeUploadedMomentItem(p2, data, edits, description, assetTotalDuration)
	local v7 = tostring(p2)
	local localPlayer = Players.LocalPlayer
	local uploadedMomentItem = {
		assetId = p2,
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

	uploadedMomentItem.momentId = v7

	uploadedMomentItem.recommendationMetadata = {}
	uploadedMomentItem.status = momentStatus.Public
	return uploadedMomentItem
end

local function makePendingMomentItem(p2, p3, p4, p5)
	local uploadedMomentItem = makeUploadedMomentItem(0, p2, p3, p4, p5)
	uploadedMomentItem.momentId = HttpService:GenerateGUID(false)
	uploadedMomentItem.status = momentStatus.Pending

	local success, result = pcall(Content.fromObject, p2)

	if success then
		uploadedMomentItem.localContent = result
	end

	return uploadedMomentItem
end

local function setPublishedPostOnUploadStore(p2, p3, p4)
	local resolved = p2.resolve(p4)

	if not p2.isCurrent() then
		return
	end

	if fFlagMomentsOptimisticProfilePending and p4 ~= nil then
		p3.reset()
	elseif resolved == nil then
		p3.reset()
	else
		p3.setSuccess(resolved)
	end
end

local function makeUploadStore(data, p2, p3, p4, p5)
	local v7

	if fFlagMomentsResolvePublishedPostFeedItem and getFFlagMomentsUseUploadPostAsync() then
		v7 = createPublishedPostResolver({
			captureType = p2.CaptureType,
			description = p4,
			edits = p3,
			placeId = p2.SourcePlaceId
		})
	else
		v7 = nil
	end

	local momentId = nil
	local v8 = nil
	local v9

	if fFlagMomentsRefreshProfileOnPostStatus or v7 ~= nil then
		v9 = function()
			if
				fFlagMomentsRefreshProfileOnPostStatus
				or fFlagMomentsOptimisticProfilePending and v7 ~= nil
			then
				postLifecycleSubscription.subscribe()
			end

			if v7 ~= nil then
				v7.captureSnapshot()
			end

			data.setUploading()

			if fFlagMomentsOptimisticProfilePending and v7 ~= nil and momentId == nil then
				local v10 = getLocalUserId()

				if v10 ~= nil then
					local v11 = p2
					local uploadedMomentItem = makeUploadedMomentItem(0, v11, p3, p4, p5)
					uploadedMomentItem.momentId = HttpService:GenerateGUID(false)
					uploadedMomentItem.status = momentStatus.Pending

					local success, result = pcall(Content.fromObject, v11)

					if success then
						uploadedMomentItem.localContent = result
					end

					momentId = uploadedMomentItem.momentId
					v8 = v10
					MomentsGetMomentsUserStore(false).prependPendingUserMoment(v10, uploadedMomentItem)
				end
			end
		end
	else
		v9 = data.setUploading
	end

	local v10

	if fFlagMomentsOptimisticProfilePending and v7 ~= nil then
		v10 = function(p6)
			if v8 ~= nil and momentId ~= nil then
				MomentsGetMomentsUserStore(false).removePendingUserMoment(v8, momentId)
			end

			if v7.isCurrent() then
				data.setFailed(p6)
			end
		end
	else
		v10 = data.setFailed
	end

	return {
		setUploading = v9,
		setFailed = v10,
		setSuccess = function(value)
			if type(value) ~= "number" then
				data.setSuccess(value)
				return
			end

			if fFlagMomentsOptimisticProfilePending and v8 ~= nil and momentId ~= nil then
				local v11 = v8
				local v12 = momentId

				task.delay(300, function()
					local v13 = MomentsGetMomentsUserStore(false)
					v13.removePendingUserMoment(v11, v12)
					v13.invalidateUser(v11)
				end)
			end

			if v7 ~= nil then
				task.spawn(setPublishedPostOnUploadStore, v7, data, momentId)
				return
			end

			if FFlagMomentsHydratePublishedFeedItem then
				task.spawn(setPublishedMomentOnUploadStore, value, data)
				return
			end

			data.setSuccess(makeUploadedMomentItem(value, p2, p3, p4, p5))

			if fFlagMomentsRefreshOwnMomentsAfterPublish then
				task.spawn(refreshOwnMomentsAfterPublish, value)
			end
		end
	}
end

local function useUploadHost(p2)
	local onExit = p2.onExit
	local captureSource = p2.captureSource

	local v7 = useLocalization(v5)

	local ref = if getFFlagEnableMomentTextGeneration() then React.useRef({}) else nil

	return (React.useMemo(function()
		local v8 = GetUploadStore(false)
		local v9 = GetToastStore(false)

		local fFlagEnableMomentTextGeneration = getFFlagEnableMomentTextGeneration()

		local function triggerGenerationToast(p3)
			local v10 = v9.triggerToast(p3)

			if ref ~= nil then
				table.insert(ref.current, v10)
			end
		end

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			generateMomentText = if fFlagEnableMomentTextGeneration then module8 else nil,
			momentGeneratedTextFeedback = if fFlagEnableMomentTextGeneration then module9 else nil,
			onGenerateTextManualEditBlocked = fFlagEnableMomentTextGeneration and function()
				local v13 = {
					title = v7.generateInProgressTitle,
					text = v7.generateInProgressBody
				}
				local v14 = v9.triggerToast(v13)

				if ref ~= nil then
					table.insert(ref.current, v14)
				end
			end or nil,
			onGenerateTextSuccess = fFlagEnableMomentTextGeneration and function()
				local v13 = { title = v7.generatedTitle, text = v7.generatedBody }
				local v14 = v9.triggerToast(v13)

				if ref ~= nil then
					table.insert(ref.current, v14)
				end
			end or nil,
			onGenerateTextFailure = fFlagEnableMomentTextGeneration and function()
				local v13 = {
					title = v7.generateFailedTitle,
					text = v7.generateFailedBody
				}
				local v14 = v9.triggerToast(v13)

				if ref ~= nil then
					table.insert(ref.current, v14)
				end
			end or nil,
			onGenerateTextFiltered = fFlagEnableMomentTextGeneration and function()
				local v13 = {
					title = v7.generateFilteredTitle,
					text = v7.generateFilteredBody
				}
				local v14 = v9.triggerToast(v13)

				if ref ~= nil then
					table.insert(ref.current, v14)
				end
			end or nil,
			onGenerateTextWillReplaceInput = fFlagEnableMomentTextGeneration and function()
				local v13 = {
					title = v7.generateOverrideTitle,
					text = v7.generateOverrideBody
				}
				local v14 = v9.triggerToast(v13)

				if ref ~= nil then
					table.insert(ref.current, v14)
				end
			end or nil,
			dismissGenerationToasts = fFlagEnableMomentTextGeneration and function()
				if ref ~= nil then
					for k, v13 in ref.current do
						v9.dismissToast(v13)
					end

					ref.current = {}
				end
			end or nil,
			isTextFiltered = MomentsCreation.isTextFiltered,
			createMoment = v6 and function(p3, p4, p5, p6, p7)
				print(`[moments-creation] dev publish (not uploaded): "{p5}"`)
			end or function(p3, p4, p5, p6, p7, p8)
				publishMomentWithUpload(p3, p4, p5, {
					localizations = v7,
					uploadStore = makeUploadStore(v8, p3, p4, p5, p7),
					toastStore = v9,
					creationSessionId = p6,
					resolvedTimeLength = p7,
					commentsEnabled = p8
				})
			end
		}
	end, { onExit, captureSource, v7 }))
end

return useUploadHost
