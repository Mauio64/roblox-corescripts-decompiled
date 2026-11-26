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
local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/generateMomentText")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Feedback/momentGeneratedTextFeedback")
local refreshOwnMomentsAfterPublish = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/refreshOwnMomentsAfterPublish")
local setPublishedMomentOnUploadStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/setPublishedMomentOnUploadStore")
local postLifecycleSubscription = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/postLifecycleSubscription")
local createPublishedPostResolver = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/createPublishedPostResolver")
local FFlagMomentsHydratePublishedFeedItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsHydratePublishedFeedItem")
local FFlagMomentsPostFeedbackIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPostFeedbackIxpEnabled")
local FStringMomentsPostFeedbackIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsPostFeedbackIxpLayer")
local makePostFeedbackEventFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makePostFeedbackEventFields")
local fFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback

local fFlagMomentsRefreshOwnMomentsAfterPublish = SharedFlags.FFlagMomentsRefreshOwnMomentsAfterPublish
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsRefreshProfileOnPostStatus = SharedFlags.FFlagMomentsRefreshProfileOnPostStatus
local fFlagMomentsResolvePublishedPostFeedItem = SharedFlags.FFlagMomentsResolvePublishedPostFeedItem
local fFlagMomentsHidePostStatusToast = SharedFlags.FFlagMomentsHidePostStatusToast

game:DefineFastInt("MomentsPendingMomentTtlSeconds", 300)

local GetUploadStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetUploadStore")
local GetPostStatusCardStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetPostStatusCardStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetPostStatusCardStore/createPostStatusCardStore")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore/createToastStore")

local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")
local usePostFeedbackStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePostFeedbackStrings")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")

local v6 = {
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

local v7 = isStudio()
local momentStatus = MomentsTypes.Enums.MomentStatus

local function makeUploadedMomentItem(p2, data, edits, description, assetTotalDuration)
	local v8 = tostring(p2)
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

	uploadedMomentItem.momentId = v8

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

local function isPendingMomentModerated(p2, p3): boolean
	local v8 = MomentsGetMomentsUserStore(false).getPendingUserMoments(false)[p2]

	if v8 == nil then
		return false
	end

	for k, v9 in v8 do
		if v9.moment.momentId == p3 then
			return v9.status == "Moderated"
		end
	end

	return false
end

local function isModerationFailure(p2): boolean
	return p2 == "Moderated" or p2 == tostring(Enum.UploadCaptureResult.CaptureModerated)
end

local function setPublishedPostOnUploadStore(p2, p3, p4, callback, callback2)
	local resolved = p2.resolve(p4)

	if callback ~= nil and resolved ~= nil then
		callback(resolved)
	end

	if callback2 ~= nil and resolved == nil then
		callback2()
	end

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

local function makeUploadStore(data, data2, p2, p3, p4, p5, p6, p7)
	local v8

	if fFlagMomentsResolvePublishedPostFeedItem and getFFlagMomentsUseUploadPostAsync() then
		v8 = createPublishedPostResolver({
			captureType = data2.CaptureType,
			description = p3,
			edits = p2,
			placeId = data2.SourcePlaceId
		})
	else
		v8 = nil
	end

	local momentId = nil
	local v9 = nil
	local localContent = nil
	local v10 = 0
	local v11 = nil

	local function makePostStatusCard(p8, p9, p10)
		local postStatusCard = {
			id = p8,
			cardType = p9,
			localContent = localContent,
			publishedMoment = p10,
			captureType = data2.CaptureType,
			creationSessionId = p5,
			localId = 0,
			startedAtClock = 0
		}

		local v12 = if data2.LocalId ~= nil then tostring(data2.LocalId) else nil
		postStatusCard.localId = v12
		postStatusCard.startedAtClock = v10
		return postStatusCard
	end

	local function dismissPostingSnackbar()
		if v11 ~= nil then
			GetToastStore(false).dismissToast(v11)
			v11 = nil
		end
	end

	local function addPostStatusCard(p8, p9)
		if momentId == nil then
			return
		end

		local add = GetPostStatusCardStore(false).add
		local v12 = {
			id = momentId,
			cardType = p8,
			localContent = localContent,
			publishedMoment = p9,
			captureType = data2.CaptureType,
			creationSessionId = p5,
			localId = 0,
			startedAtClock = 0
		}

		local v13 = if data2.LocalId ~= nil then tostring(data2.LocalId) else nil
		v12.localId = v13
		v12.startedAtClock = v10

		add(v12)

		if v11 ~= nil then
			GetToastStore(false).dismissToast(v11)
			v11 = nil
		end
	end

	local function stopAwaitingLiveCard()
		if momentId == nil then
			return
		end

		local v12 = not (v9 == nil) and isPendingMomentModerated(v9, momentId)
		local v13 = GetPostStatusCardStore(false)
		local stopAwaitingLiveCard2 = v13.stopAwaitingLiveCard
		local v14 = momentId
		local v15

		if not v12 then
			v15 = {
				id = momentId,
				cardType = "Live",
				localContent = localContent,
				publishedMoment = nil,
				captureType = data2.CaptureType,
				creationSessionId = p5,
				localId = 0,
				startedAtClock = 0
			}

			local v16 = if data2.LocalId ~= nil then tostring(data2.LocalId) else nil
			v15.localId = v16
			v15.startedAtClock = v10
		end

		stopAwaitingLiveCard2(v14, v15)

		if v13.hasHadLiveCard(momentId) and v11 ~= nil then
			GetToastStore(false).dismissToast(v11)
			v11 = nil
		end
	end

	local v12

	if fFlagMomentsRefreshProfileOnPostStatus or v8 ~= nil then
		v12 = function()
			if
				fFlagMomentsRefreshProfileOnPostStatus
				or fFlagMomentsOptimisticProfilePending and v8 ~= nil
			then
				postLifecycleSubscription.subscribe()
			end

			if v8 ~= nil then
				v8.captureSnapshot()
			end

			data.setUploading()

			if fFlagMomentsOptimisticProfilePending and v8 ~= nil and momentId == nil then
				local v13 = getLocalUserId()

				if v13 ~= nil then
					local v14 = data2
					local uploadedMomentItem = makeUploadedMomentItem(0, v14, p2, p3, p4)
					uploadedMomentItem.momentId = HttpService:GenerateGUID(false)
					uploadedMomentItem.status = momentStatus.Pending

					local success, result = pcall(Content.fromObject, v14)

					if success then
						uploadedMomentItem.localContent = result
					end

					momentId = uploadedMomentItem.momentId
					v9 = v13

					if FFlagMomentsPostFeedbackIxpEnabled and p7 then
						logMomentsLayerExposure(FStringMomentsPostFeedbackIxpLayer)
					end

					local now = if fFlagMomentsPostFeedback then os.clock() else nil
					MomentsGetMomentsUserStore(false).prependPendingUserMoment(v13, uploadedMomentItem, now)

					if fFlagMomentsPostFeedback then
						v5:debug("event=pending_moment_added momentId={}", uploadedMomentItem.momentId)
						localContent = uploadedMomentItem.localContent
						v10 = now or os.clock()
					end

					if fFlagMomentsHidePostStatusToast and p6 then
						GetPostStatusCardStore(false).markUploading(uploadedMomentItem.momentId)
					end
				end
			end
		end
	else
		v12 = data.setUploading
	end

	local v13

	if fFlagMomentsOptimisticProfilePending and v8 ~= nil then
		v13 = function(p8)
			if v9 ~= nil and momentId ~= nil then
				MomentsGetMomentsUserStore(false).removePendingUserMoment(v9, momentId)
			end

			if
				fFlagMomentsPostFeedback
				and p6
				and p8 ~= "Moderated"
				and p8 ~= tostring(Enum.UploadCaptureResult.CaptureModerated)
				and momentId ~= nil
			then
				local add = GetPostStatusCardStore(false).add
				local v14 = {
					id = momentId,
					cardType = "UploadFailed",
					localContent = localContent,
					publishedMoment = nil,
					captureType = data2.CaptureType,
					creationSessionId = p5,
					localId = 0,
					startedAtClock = 0
				}

				local v15 = if data2.LocalId ~= nil then tostring(data2.LocalId) else nil
				v14.localId = v15
				v14.startedAtClock = v10

				add(v14)

				if v11 ~= nil then
					GetToastStore(false).dismissToast(v11)
					v11 = nil
				end
			end

			if fFlagMomentsHidePostStatusToast and p6 and momentId ~= nil then
				GetPostStatusCardStore(false).stopAwaitingLiveCard(momentId, nil)
			end

			if v8.isCurrent() then
				data.setFailed(p8)
			end
		end
	else
		v13 = data.setFailed
	end

	return {
		setUploading = v12,
		setFailed = v13,
		setSuccess = function(value)
			if type(value) == "number" then
				if fFlagMomentsOptimisticProfilePending and v9 ~= nil and momentId ~= nil then
					local v14 = v9
					local v15 = momentId

					if fFlagMomentsHidePostStatusToast and p6 then
						GetPostStatusCardStore(false).awaitLiveCard(v15)
					end

					task.delay(game:GetFastInt("MomentsPendingMomentTtlSeconds"), function()
						if fFlagMomentsPostFeedback and isPendingMomentModerated(v14, v15) then
							v5:debug("event=pending_moment_ttl_skipped momentId={} reason=moderated", v15)
							return
						end

						if fFlagMomentsPostFeedback then
							v5:debug("event=pending_moment_ttl_expired momentId={}", v15)
						end

						if fFlagMomentsHidePostStatusToast and p6 then
							stopAwaitingLiveCard()
						end

						local v16 = MomentsGetMomentsUserStore(false)
						v16.removePendingUserMoment(v14, v15)
						v16.invalidateUser(v14)
					end)
				end

				if v8 == nil then
					if FFlagMomentsHydratePublishedFeedItem then
						task.spawn(setPublishedMomentOnUploadStore, value, data)
						return
					end

					data.setSuccess(makeUploadedMomentItem(value, data2, p2, p3, p4))

					if fFlagMomentsRefreshOwnMomentsAfterPublish then
						task.spawn(refreshOwnMomentsAfterPublish, value)
					end
				else
					local spawn2 = task.spawn

					local fn = fFlagMomentsPostFeedback and p6 and function(p8)
						if momentId == nil then
							return
						end

						local add = GetPostStatusCardStore(false).add
						local v18 = {
							id = momentId,
							cardType = "Live",
							localContent = localContent,
							publishedMoment = p8,
							captureType = data2.CaptureType,
							creationSessionId = p5,
							localId = 0,
							startedAtClock = 0
						}

						local v19 = if data2.LocalId ~= nil then tostring(data2.LocalId) else nil
						v18.localId = v19
						v18.startedAtClock = v10

						add(v18)

						if v11 ~= nil then
							GetToastStore(false).dismissToast(v11)
							v11 = nil
						end
					end or nil
					local v18 = if fFlagMomentsHidePostStatusToast and p6 then stopAwaitingLiveCard else nil
					spawn2(setPublishedPostOnUploadStore, v8, data, momentId, fn, v18)
				end
			else
				if fFlagMomentsHidePostStatusToast and p6 and momentId ~= nil then
					GetPostStatusCardStore(false).stopAwaitingLiveCard(momentId, nil)
				end

				data.setSuccess(value)
			end
		end,
		hasPendingRecord = function(): boolean
			return momentId ~= nil
		end,
		setPostingSnackbarId = function(p8)
			v11 = p8
		end
	}
end

local function makePostFeedbackToastStore(p2, callback, callback2, p3, p4, p5, p6, p7)
	local clone = table.clone(p2)
	function clone.triggerToast(p8)
		if p8.title == p3 and callback() then
			local v8 = p2.triggerToast({
				title = p6,
				text = "",
				variant = "snackbar",
				placement = "bottom"
			})

			callback2(v8)
			fireAnalyticsEvent(eventNames.MomentPostSnackbarShown, p7)
			return v8
		elseif p8.title == p4 and p8.text == p5 and callback() then
			return 0
		else
			return p2.triggerToast(p8)
		end
	end

	return clone
end

local function useUploadHost(data)
	local onExit = data.onExit
	local captureSource = data.captureSource

	local v8 = if fFlagMomentsPostFeedback then data.postFeedback == true else nil
	local v9 = if FFlagMomentsPostFeedbackIxpEnabled then data.logsPostFeedbackExposure == true else nil

	local v10 = useLocalization(v6)

	local postingSnackbar = if fFlagMomentsPostFeedback then usePostFeedbackStrings().postingSnackbar else nil

	local ref = if getFFlagEnableMomentTextGeneration() then React.useRef({}) else nil

	return (React.useMemo(function()
		local v11 = GetUploadStore(false)
		local v12 = GetToastStore(false)

		local fFlagEnableMomentTextGeneration = getFFlagEnableMomentTextGeneration()

		local function triggerGenerationToast(p2)
			local v13 = v12.triggerToast(p2)

			if ref ~= nil then
				table.insert(ref.current, v13)
			end
		end

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			generateMomentText = if fFlagEnableMomentTextGeneration then module8 else nil,
			momentGeneratedTextFeedback = if fFlagEnableMomentTextGeneration then module9 else nil,
			onGenerateTextManualEditBlocked = fFlagEnableMomentTextGeneration and function()
				local v16 = {
					title = v10.generateInProgressTitle,
					text = v10.generateInProgressBody
				}
				local v17 = v12.triggerToast(v16)

				if ref ~= nil then
					table.insert(ref.current, v17)
				end
			end or nil,
			onGenerateTextSuccess = fFlagEnableMomentTextGeneration and function()
				local v16 = { title = v10.generatedTitle, text = v10.generatedBody }
				local v17 = v12.triggerToast(v16)

				if ref ~= nil then
					table.insert(ref.current, v17)
				end
			end or nil,
			onGenerateTextFailure = fFlagEnableMomentTextGeneration and function()
				local v16 = {
					title = v10.generateFailedTitle,
					text = v10.generateFailedBody
				}
				local v17 = v12.triggerToast(v16)

				if ref ~= nil then
					table.insert(ref.current, v17)
				end
			end or nil,
			onGenerateTextFiltered = fFlagEnableMomentTextGeneration and function()
				local v16 = {
					title = v10.generateFilteredTitle,
					text = v10.generateFilteredBody
				}
				local v17 = v12.triggerToast(v16)

				if ref ~= nil then
					table.insert(ref.current, v17)
				end
			end or nil,
			onGenerateTextWillReplaceInput = fFlagEnableMomentTextGeneration and function()
				local v16 = {
					title = v10.generateOverrideTitle,
					text = v10.generateOverrideBody
				}
				local v17 = v12.triggerToast(v16)

				if ref ~= nil then
					table.insert(ref.current, v17)
				end
			end or nil,
			dismissGenerationToasts = fFlagEnableMomentTextGeneration and function()
				if ref ~= nil then
					for k, v16 in ref.current do
						v12.dismissToast(v16)
					end

					ref.current = {}
				end
			end or nil,
			isTextFiltered = MomentsCreation.isTextFiltered,
			createMoment = v7 and function(p2, p3, p4, p5, p6)
				print(`[moments-creation] dev publish (not uploaded): "{p4}"`)
			end or function(p2, p3, p4, creationSessionId, resolvedTimeLength, commentsEnabled)
				local v18 = if fFlagMomentsPostFeedback then v8 else nil
				local v19 = if FFlagMomentsPostFeedbackIxpEnabled then v9 else nil
				local v20 = makeUploadStore(
					v11,
					p2,
					p3,
					p4,
					resolvedTimeLength,
					creationSessionId,
					v18,
					v19
				)

				local v22 = {
					localizations = v10,
					uploadStore = v20,
					toastStore = 0,
					creationSessionId = 0,
					resolvedTimeLength = 0,
					commentsEnabled = 0
				}
				local v23

				if v8 and postingSnackbar ~= nil then
					local v24 = v12
					local hasPendingRecord = v20.hasPendingRecord
					local setPostingSnackbarId = v20.setPostingSnackbarId
					local publishingTitle = v10.publishingTitle
					local failedTitle = v10.failedTitle
					local failedBody = v10.failedBody
					local v25 = postingSnackbar

					local v28 = if p2.LocalId ~= nil then tostring(p2.LocalId) else nil
					local v29 = makePostFeedbackEventFields({
						creationSessionId = creationSessionId,
						localId = v28,
						captureType = p2.CaptureType
					})
					v23 = table.clone(v24)
					function v23.triggerToast(p5)
						if p5.title == publishingTitle and hasPendingRecord() then
							local v30 = v24.triggerToast({
								title = v25,
								text = "",
								variant = "snackbar",
								placement = "bottom"
							})

							setPostingSnackbarId(v30)
							fireAnalyticsEvent(eventNames.MomentPostSnackbarShown, v29)
							return v30
						elseif p5.title == failedTitle and p5.text == failedBody and hasPendingRecord() then
							return 0
						else
							return v24.triggerToast(p5)
						end
					end
				else
					v23 = v12
				end

				v22.toastStore = v23

				v22.creationSessionId = creationSessionId
				v22.resolvedTimeLength = resolvedTimeLength
				v22.commentsEnabled = commentsEnabled
				publishMomentWithUpload(p2, p3, p4, v22)
			end
		}
	end, { onExit, captureSource, v10, postingSnackbar, v8, v9 }))
end

return useUploadHost
