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
local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local generateMomentText = require(Moments.generateMomentText)
local momentGeneratedTextFeedback = require(Moments.Feedback.momentGeneratedTextFeedback)
local refreshOwnMomentsAfterPublish = require(Moments.Upload.refreshOwnMomentsAfterPublish)
local setPublishedMomentOnUploadStore = require(Moments.Upload.setPublishedMomentOnUploadStore)
local postLifecycleSubscription = require(Moments.Upload.postLifecycleSubscription)
local createPublishedPostResolver = require(Moments.Upload.createPublishedPostResolver)
local FFlagMomentsHydratePublishedFeedItem = require(Moments.Flags.FFlagMomentsHydratePublishedFeedItem)
local FFlagMomentsPostFeedbackIxpEnabled = require(Moments.Flags.FFlagMomentsPostFeedbackIxpEnabled)
local FStringMomentsPostFeedbackIxpLayer = require(Moments.Flags.FStringMomentsPostFeedbackIxpLayer)
local makePostFeedbackEventFields = require(Moments.Analytics.makePostFeedbackEventFields)
local FFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback

local FFlagMomentsRefreshOwnMomentsAfterPublish = SharedFlags.FFlagMomentsRefreshOwnMomentsAfterPublish
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsRefreshProfileOnPostStatus = SharedFlags.FFlagMomentsRefreshProfileOnPostStatus
local FFlagMomentsResolvePublishedPostFeedItem = SharedFlags.FFlagMomentsResolvePublishedPostFeedItem
local FFlagMomentsHidePostStatusToast = SharedFlags.FFlagMomentsHidePostStatusToast

game:DefineFastInt("MomentsPendingMomentTtlSeconds", 300)

local GetUploadStore = require(Moments.Stores.GetUploadStore)
local GetPostStatusCardStore = require(Moments.Stores.GetPostStatusCardStore)
require(Moments.Stores.GetPostStatusCardStore.createPostStatusCardStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
require(Moments.Stores.GetToastStore.createToastStore)

local isStudio = require(parent.MomentsCommon.isStudio)
local getLocalUserId = require(Moments.Utils.getLocalUserId)
local usePostFeedbackStrings = require(Moments.Components.PostFeedback.usePostFeedbackStrings)

local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new("Moments.Upload")

local v2 = {
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

local function makePendingMomentItem(data, edits, description: string, p: number?) -- 1 equivalent call inferred from this helper
	local uploadedMomentItem = makeUploadedMomentItem(0, data, edits, description, p)
	uploadedMomentItem.momentId = HttpService:GenerateGUID(false)
	uploadedMomentItem.status = MomentStatus.Pending

	local success, result = pcall(Content.fromObject, data)

	if success then
		uploadedMomentItem.localContent = result
	end

	return uploadedMomentItem
end

local function isPendingMomentModerated(p: number, p2: string): boolean
	local v3 = MomentsGetMomentsUserStore(false).getPendingUserMoments(false)[p]

	if v3 == nil then
		return false
	end

	for _, v4 in v3 do
		if v4.moment.momentId == p2 then
			return v4.status == "Moderated"
		end
	end

	return false
end

local function isModerationFailure(p): boolean
	return p == "Moderated" or p == tostring(Enum.UploadCaptureResult.CaptureModerated)
end

local function setPublishedPostOnUploadStore(p, p2, p3: string?, callback, callback2)
	local resolved = p.resolve(p3)

	if callback ~= nil and resolved ~= nil then
		callback(resolved)
	end

	if callback2 ~= nil and resolved == nil then
		callback2()
	end

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

local function makeUploadStore(data, data2, edits, description: string, resolvedTimeLength: number?, creationSessionId: string?, flag: boolean?, flag2: boolean?)
	local v3

	if FFlagMomentsResolvePublishedPostFeedItem and GetFFlagMomentsUseUploadPostAsync() then
		v3 = createPublishedPostResolver({
			captureType = data2.CaptureType,
			description = description,
			edits = edits,
			placeId = data2.SourcePlaceId
		})
	else
		v3 = nil
	end

	local momentId = nil
	local v4 = nil
	local localContent = nil
	local startedAtClock = 0
	local v5 = nil

	local function makePostStatusCard(momentId2: string, cardType, publishedMoment) -- 1 equivalent call inferred from this helper
		local postStatusCard = {
			id = momentId2,
			cardType = cardType,
			localContent = localContent,
			publishedMoment = publishedMoment,
			captureType = data2.CaptureType,
			creationSessionId = creationSessionId,
			localId = 0,
			startedAtClock = 0
		}
		local localId

		if data2.LocalId ~= nil then
			localId = tostring(data2.LocalId)
		end

		postStatusCard.localId = localId
		postStatusCard.startedAtClock = startedAtClock
		return postStatusCard
	end

	local function dismissPostingSnackbar() -- 2 equivalent calls inferred from this helper
		if v5 ~= nil then
			GetToastStore(false).dismissToast(v5)
			v5 = nil
		end
	end

	local function addPostStatusCard(cardType, publishedMoment) -- 2 equivalent calls inferred from this helper
		if momentId == nil then
			return
		end

		GetPostStatusCardStore(false).add(makePostStatusCard(momentId, cardType, publishedMoment)) -- inferred equivalent call
		dismissPostingSnackbar() -- inferred equivalent call
	end

	local function stopAwaitingLiveCard()
		if momentId == nil then
			return
		end

		local v6

		if v4 == nil then
			v6 = false
		else
			v6 = isPendingMomentModerated(v4, momentId)
		end

		local postStatusCardStore = GetPostStatusCardStore(false)
		local stopAwaitingLiveCard2 = postStatusCardStore.stopAwaitingLiveCard
		local v7 = momentId
		local v8

		if not v6 then
			v8 = {
				id = momentId,
				cardType = "Live",
				localContent = localContent,
				publishedMoment = nil,
				captureType = data2.CaptureType,
				creationSessionId = creationSessionId,
				localId = 0,
				startedAtClock = 0
			}
			local localId

			if data2.LocalId ~= nil then
				localId = tostring(data2.LocalId)
			end

			v8.localId = localId
			v8.startedAtClock = startedAtClock
		end

		stopAwaitingLiveCard2(v7, v8)

		if postStatusCardStore.hasHadLiveCard(momentId) then
			dismissPostingSnackbar() -- inferred equivalent call
		end
	end

	local setUploading

	if FFlagMomentsRefreshProfileOnPostStatus or v3 ~= nil then
		setUploading = function()
			if FFlagMomentsRefreshProfileOnPostStatus or FFlagMomentsOptimisticProfilePending and v3 ~= nil then
				postLifecycleSubscription.subscribe()
			end

			if v3 ~= nil then
				v3.captureSnapshot()
			end

			data.setUploading()

			if FFlagMomentsOptimisticProfilePending and v3 ~= nil and momentId == nil then
				local localUserId = getLocalUserId()

				if localUserId ~= nil then
					local pendingMomentItem = makePendingMomentItem(data2, edits, description, resolvedTimeLength) -- inferred equivalent call
					momentId = pendingMomentItem.momentId
					v4 = localUserId

					if FFlagMomentsPostFeedbackIxpEnabled and flag2 then
						logMomentsLayerExposure(FStringMomentsPostFeedbackIxpLayer)
					end

					local now

					if FFlagMomentsPostFeedback then
						now = os.clock()
					end

					MomentsGetMomentsUserStore(false).prependPendingUserMoment(localUserId, pendingMomentItem, now)

					if FFlagMomentsPostFeedback then
						v:debug("event=pending_moment_added momentId={}", pendingMomentItem.momentId)
						localContent = pendingMomentItem.localContent
						startedAtClock = now or os.clock()
					end

					if FFlagMomentsHidePostStatusToast and flag then
						GetPostStatusCardStore(false).markUploading(pendingMomentItem.momentId)
					end
				end
			end
		end
	else
		setUploading = data.setUploading
	end

	local setFailed

	if FFlagMomentsOptimisticProfilePending and v3 ~= nil then
		setFailed = function(p)
			if v4 ~= nil and momentId ~= nil then
				MomentsGetMomentsUserStore(false).removePendingUserMoment(v4, momentId)
			end

			if
				FFlagMomentsPostFeedback
				and flag
				and p ~= "Moderated"
				and p ~= tostring(Enum.UploadCaptureResult.CaptureModerated)
			then
				addPostStatusCard("UploadFailed") -- inferred equivalent call
			end

			if FFlagMomentsHidePostStatusToast and flag and momentId ~= nil then
				GetPostStatusCardStore(false).stopAwaitingLiveCard(momentId, nil)
			end

			if v3.isCurrent() then
				data.setFailed(p)
			end
		end
	else
		setFailed = data.setFailed
	end

	return {
		setUploading = setUploading,
		setFailed = setFailed,
		setSuccess = function(assetId)
			if type(assetId) == "number" then
				if FFlagMomentsOptimisticProfilePending and v4 ~= nil and momentId ~= nil then
					local v6 = v4
					local v7 = momentId

					if FFlagMomentsHidePostStatusToast and flag then
						GetPostStatusCardStore(false).awaitLiveCard(v7)
					end

					task.delay(game:GetFastInt("MomentsPendingMomentTtlSeconds"), function()
						if FFlagMomentsPostFeedback and isPendingMomentModerated(v6, v7) then
							v:debug("event=pending_moment_ttl_skipped momentId={} reason=moderated", v7)
							return
						end

						if FFlagMomentsPostFeedback then
							v:debug("event=pending_moment_ttl_expired momentId={}", v7)
						end

						if FFlagMomentsHidePostStatusToast and flag then
							stopAwaitingLiveCard()
						end

						local momentsGetMomentsUserStore = MomentsGetMomentsUserStore(false)
						momentsGetMomentsUserStore.removePendingUserMoment(v6, v7)
						momentsGetMomentsUserStore.invalidateUser(v6)
					end)
				end

				if v3 == nil then
					if FFlagMomentsHydratePublishedFeedItem then
						task.spawn(setPublishedMomentOnUploadStore, assetId, data)
						return
					end

					data.setSuccess(makeUploadedMomentItem(assetId, data2, edits, description, resolvedTimeLength))

					if FFlagMomentsRefreshOwnMomentsAfterPublish then
						task.spawn(refreshOwnMomentsAfterPublish, assetId)
					end
				else
					local v6 = momentId

					local fn = FFlagMomentsPostFeedback and flag and function(publishedMoment)
						addPostStatusCard("Live", publishedMoment) -- inferred equivalent call
					end or nil
					local v7

					if FFlagMomentsHidePostStatusToast and flag then
						v7 = stopAwaitingLiveCard
					end

					task.spawn(setPublishedPostOnUploadStore, v3, data, v6, fn, v7)
				end
			else
				if FFlagMomentsHidePostStatusToast and flag and momentId ~= nil then
					GetPostStatusCardStore(false).stopAwaitingLiveCard(momentId, nil)
				end

				data.setSuccess(assetId)
			end
		end,
		hasPendingRecord = function(): boolean
			return momentId ~= nil
		end,
		setPostingSnackbarId = function(p: number)
			v5 = p
		end
	}
end

local function makePostFeedbackToastStore(p, callback, callback2, p2: string, p3: string, p4: string, title: string, p5)
	local clone = table.clone(p)
	function clone.triggerToast(p6)
		if p6.title == p2 and callback() then
			local v3 = p.triggerToast({
				title = title,
				text = "",
				variant = "snackbar",
				placement = "bottom"
			})

			callback2(v3)
			fireAnalyticsEvent(EventNames.MomentPostSnackbarShown, p5)
			return v3
		elseif p6.title == p3 and p6.text == p4 and callback() then
			return 0
		else
			return p.triggerToast(p6)
		end
	end

	return clone
end

local function useUploadHost(data)
	local onExit = data.onExit
	local captureSource = data.captureSource
	local v3

	if FFlagMomentsPostFeedback then
		v3 = data.postFeedback == true
	else
		v3 = nil
	end

	local v4

	if FFlagMomentsPostFeedbackIxpEnabled then
		v4 = data.logsPostFeedbackExposure == true
	else
		v4 = nil
	end

	local localizations = useLocalization(v2)
	local postingSnackbar

	if FFlagMomentsPostFeedback then
		postingSnackbar = usePostFeedbackStrings().postingSnackbar
	else
		postingSnackbar = nil
	end

	local ref

	if GetFFlagEnableMomentTextGeneration() then
		ref = React.useRef({})
	else
		ref = nil
	end

	return (React.useMemo(function()
		local uploadStore2 = GetUploadStore(false)
		local toastStore = GetToastStore(false)

		local fFlagEnableMomentTextGeneration = GetFFlagEnableMomentTextGeneration()

		local function triggerGenerationToast(p) -- 5 equivalent calls inferred from this helper
			local v5 = toastStore.triggerToast(p)

			if ref ~= nil then
				table.insert(ref.current, v5)
			end
		end

		local v5 = {
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

		v5.generateMomentText = generateMomentText2
		local momentGeneratedTextFeedback2

		if fFlagEnableMomentTextGeneration then
			momentGeneratedTextFeedback2 = momentGeneratedTextFeedback
		end

		v5.momentGeneratedTextFeedback = momentGeneratedTextFeedback2
		v5.onGenerateTextManualEditBlocked = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateInProgressTitle,
				text = localizations.generateInProgressBody
			})
		end or nil

		v5.onGenerateTextSuccess = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generatedTitle,
				text = localizations.generatedBody
			})
		end or nil

		v5.onGenerateTextFailure = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateFailedTitle,
				text = localizations.generateFailedBody
			})
		end or nil

		v5.onGenerateTextFiltered = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateFilteredTitle,
				text = localizations.generateFilteredBody
			})
		end or nil

		v5.onGenerateTextWillReplaceInput = fFlagEnableMomentTextGeneration and function()
			triggerGenerationToast({ -- inferred equivalent call
				title = localizations.generateOverrideTitle,
				text = localizations.generateOverrideBody
			})
		end or nil

		v5.dismissGenerationToasts = fFlagEnableMomentTextGeneration and function()
			if ref ~= nil then
				for _, v6 in ref.current do
					toastStore.dismissToast(v6)
				end

				ref.current = {}
			end
		end or nil

		v5.isTextFiltered = MomentsCreation.isTextFiltered
		v5.createMoment = studio and function(_, _, p: string, _: string?, _: number?)
			print(`[moments-creation] dev publish (not uploaded): "{p}"`)
		end or function(p, edits, description: string, creationSessionId: string?, resolvedTimeLength: number?, commentsEnabled: boolean?)
			local v6

			if FFlagMomentsPostFeedback then
				v6 = v3
			end

			local v7

			if FFlagMomentsPostFeedbackIxpEnabled then
				v7 = v4
			end

			local uploadStore = makeUploadStore(
				uploadStore2,
				p,
				edits,
				description,
				resolvedTimeLength,
				creationSessionId,
				v6,
				v7
			)

			local v8 = {
				localizations = localizations,
				uploadStore = uploadStore,
				toastStore = 0,
				creationSessionId = 0,
				resolvedTimeLength = 0,
				commentsEnabled = 0
			}
			local toastStore2

			if v3 and postingSnackbar ~= nil then
				local toastStore3 = toastStore
				local hasPendingRecord = uploadStore.hasPendingRecord
				local setPostingSnackbarId = uploadStore.setPostingSnackbarId
				local publishingTitle = localizations.publishingTitle
				local failedTitle = localizations.failedTitle
				local failedBody = localizations.failedBody
				local title = postingSnackbar
				local localId

				if p.LocalId ~= nil then
					localId = tostring(p.LocalId)
				end

				local postFeedbackEventFields = makePostFeedbackEventFields({
					creationSessionId = creationSessionId,
					localId = localId,
					captureType = p.CaptureType
				})
				toastStore2 = table.clone(toastStore3)
				function toastStore2.triggerToast(p2)
					if p2.title == publishingTitle and hasPendingRecord() then
						local v9 = toastStore3.triggerToast({
							title = title,
							text = "",
							variant = "snackbar",
							placement = "bottom"
						})

						setPostingSnackbarId(v9)
						fireAnalyticsEvent(EventNames.MomentPostSnackbarShown, postFeedbackEventFields)
						return v9
					elseif p2.title == failedTitle and p2.text == failedBody and hasPendingRecord() then
						return 0
					else
						return toastStore3.triggerToast(p2)
					end
				end
			else
				toastStore2 = toastStore
			end

			v8.toastStore = toastStore2

			v8.creationSessionId = creationSessionId
			v8.resolvedTimeLength = resolvedTimeLength
			v8.commentsEnabled = commentsEnabled
			publishMomentWithUpload(p, edits, description, v8)
		end
		return v5
	end, { onExit, captureSource, localizations, postingSnackbar, v3, v4 }))
end

return useUploadHost
