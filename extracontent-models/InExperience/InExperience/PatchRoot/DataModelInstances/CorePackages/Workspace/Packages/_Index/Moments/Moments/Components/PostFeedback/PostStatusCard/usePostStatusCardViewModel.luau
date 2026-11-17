local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local ButtonVariant = Foundation.Enums.ButtonVariant
local EventNames = MomentsCommon.Analytics.EventNames
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local useTokens = Foundation.Hooks.useTokens
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus

require(script.Parent.PostStatusCardView)
local GetPostStatusCardStore = require(Moments.Stores.GetPostStatusCardStore)
local makePostFeedbackEventFields = require(Moments.Analytics.makePostFeedbackEventFields)
require(Moments.Stores.GetPostStatusCardStore.createPostStatusCardStore)
local createRecommendationTelemetry = require(Moments.Components.Feed.createRecommendationTelemetry)
require(Moments.Components.Feed.FeedTypes)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local SignalActionType = require(Moments.Enums.SignalActionType)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local shareMoment = require(Moments.Share.shareMoment)
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
local usePostStatusCardMotion = require(script.Parent.usePostStatusCardMotion)
local usePostFeedbackStrings = require(Moments.Components.PostFeedback.usePostFeedbackStrings)
local FFlagMomentsFollowingFeed = require(Moments.Flags.FFlagMomentsFollowingFeed)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local getCommentsSheetStore

if FFlagMomentsComments then
	getCommentsSheetStore = require(Moments.Components.Comments.Sheet.getCommentsSheetStore)
else
	getCommentsSheetStore = nil
end

local FFlagMomentsCreatorAnalytics = require(Moments.Flags.FFlagMomentsCreatorAnalytics)
local getPostInsightsPageStore

if FFlagMomentsCreatorAnalytics then
	getPostInsightsPageStore = require(Moments.Components.PostInsights.getPostInsightsPageStore)
else
	getPostInsightsPageStore = nil
end

game:DefineFastInt("MomentsPostStatusLiveDismissSeconds", 5)
game:DefineFastInt("MomentsPostStatusFailedDismissSeconds", 5)

local v = {
	shareLinkTitle = "Feature.Moments.Label.ShareLinkTitle",
	linkCopied = "Feature.Moments.Label.LinkCopied",
	linkCopyFailed = "Feature.Moments.Label.LinkCopyFailed"
}

local function isShownCardType(p): boolean -- 2 equivalent calls inferred from this helper
	return p.cardType == "Live" or p.cardType == "UploadFailed"
end

local function getOldestShownCard(list)
	for i = #list, 1, -1 do
		if isShownCardType(list[i]) then -- inferred equivalent call
			return list[i]
		end
	end

	return nil
end

local function getShareFeedItemId(p)
	local publishedMoment = p.publishedMoment

	if publishedMoment == nil then
		return nil
	end

	local feedItemId = publishedMoment.recommendationMetadata.feedItemId

	if feedItemId == nil or feedItemId == "" then
		return nil
	end

	return feedItemId
end

local function makeMedia(data)
	if data.cardType ~= "Live" then
		return { kind = "unavailable" }
	end

	local localContent = data.localContent

	if localContent == nil then
		return { kind = "momentsIcon" }
	end

	local captureType = data.captureType or Enum.CaptureType.Screenshot

	local mediaItem = {
		momentId = data.id,
		content = localContent,
		posterContent = 0,
		captureType = 0
	}

	if captureType == Enum.CaptureType.Video then
		localContent = nil
	end

	mediaItem.posterContent = localContent
	mediaItem.captureType = captureType
	return { kind = "thumbnail", mediaItem = mediaItem }
end

local function usePostStatusCardViewModel()
	local postStatusCardStore = GetPostStatusCardStore(false)
	local v2 = useSignalState(postStatusCardStore.getCards)
	local v3 = useMomentsTabIsVisible()

	local v4 = useSignalState(reportModalCovering.getCovering)
	local v5 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v6

	if FFlagMomentsComments and getCommentsSheetStore ~= nil then
		v6 = useSignalState(getCommentsSheetStore(false).getIsExpanded)
	else
		v6 = false
	end

	local v7

	if FFlagMomentsCreatorAnalytics and getPostInsightsPageStore ~= nil then
		v7 = useSignalState(getPostInsightsPageStore(false).getIsOpen)
	else
		v7 = false
	end

	local v8 = usePostFeedbackStrings()
	local v9 = useLocalization(v)
	local v10 = useTokens()
	local v11 = useStatusBarHeight()
	local v12 = useDeviceInsets()
	local v13 = useMomentsSession()

	local v14 = React.useMemo(function()
		if FFlagEnableArgus then
			return createRecommendationTelemetry({ getMomentsSessionId = v13.getMomentsSessionId })
		end

		return nil
	end, { v13 })

	local ref = React.useRef(nil)
	local current2

	if v3 and not (v4 or v5 or v6 or v7) then
		local flag = true

		for i = #v2, 1, -1 do
			if isShownCardType(v2[i]) then -- inferred equivalent call
				current2 = v2[i]
				flag = false
				break
			end
		end

		if flag then
			current2 = nil
		end
	else
		current2 = nil
	end

	local id

	if current2 == nil then
		id = nil
	else
		id = current2.id
	end

	local cardType

	if current2 == nil then
		cardType = nil
	else
		cardType = current2.cardType
	end

	local v15 = usePostStatusCardMotion(id)
	local hide = v15.hide

	React.useEffect(function()
		if id == nil then
			return nil
		end

		local v16

		if cardType == "Live" then
			v16 = game:GetFastInt("MomentsPostStatusLiveDismissSeconds")
		else
			v16 = game:GetFastInt("MomentsPostStatusFailedDismissSeconds")
		end

		local thread = task.delay(v16, function()
			ref.current = id
			hide(function()
				postStatusCardStore.dismiss(id)
			end)
		end)
		return function()
			task.cancel(thread)
		end
	end, { postStatusCardStore, id, cardType, hide })

	local ref2 = React.useRef(current2)
	ref2.current = current2
	React.useEffect(function()
		local current = ref2.current

		if current == nil or not postStatusCardStore.markShown(current.id) then
			return
		end

		local postFeedbackEventFields = makePostFeedbackEventFields(current)
		postFeedbackEventFields.cardType = current.cardType
		fireAnalyticsEvent(EventNames.MomentPostStatusCardShown, postFeedbackEventFields)
	end, { postStatusCardStore, id })

	local media = React.useMemo(function()
		if current2 == nil then
			return nil
		end

		return makeMedia(current2)
	end, { current2 })

	if current2 == nil then
		return nil
	end

	local function close(): boolean -- 2 equivalent calls inferred from this helper
		if ref.current == current2.id then
			return false
		end

		ref.current = current2.id
		hide(function()
			postStatusCardStore.dismiss(current2.id)
		end)
		return true
	end

	local actions = {}
	local publishedMoment = current2.publishedMoment
	local feedItemId

	if publishedMoment == nil then
		feedItemId = nil
	else
		feedItemId = publishedMoment.recommendationMetadata.feedItemId

		if feedItemId == nil or feedItemId == "" then
			feedItemId = nil
		end
	end

	local publishedMoment2 = current2.publishedMoment

	if current2.cardType == "Live" and publishedMoment2 ~= nil and feedItemId ~= nil then
		table.insert(actions, {
			text = v8.share,
			variant = ButtonVariant.SoftEmphasis,
			onActivated = function()
				if not close() then -- inferred equivalent call
					return
				end

				fireAnalyticsEvent(EventNames.MomentPostStatusCardShareTapped, makePostFeedbackEventFields(current2))
				local recommendationAttribution = makeRecommendationAttribution(
					publishedMoment2.recommendationMetadata,
					publishedMoment2
				)
				shareMoment({
					momentId = publishedMoment2.momentId,
					feedItemId = feedItemId,
					feedSessionId = publishedMoment2.recommendationMetadata.tracingId,
					description = publishedMoment2.metadata.description,
					logAction = v14 ~= nil and recommendationAttribution ~= nil and function(p)
						return v14.logAction(SignalActionType.Share, recommendationAttribution, p)
					end or nil,
					strings = {
						linkPreviewTitle = v9.shareLinkTitle,
						linkCopied = v9.linkCopied,
						linkCopyFailed = v9.linkCopyFailed
					}
				})
			end
		})
	end

	table.insert(actions, {
		text = v8.dismiss,
		variant = ButtonVariant.Standard,
		onActivated = function()
			if close() then -- inferred equivalent call
				local postFeedbackEventFields = makePostFeedbackEventFields(current2)
				postFeedbackEventFields.cardType = current2.cardType
				postFeedbackEventFields.dismissMethod = "button"
				fireAnalyticsEvent(EventNames.MomentPostStatusCardDismissed, postFeedbackEventFields)
			end
		end
	})

	local v16 = current2.cardType == "Live"

	local title = if v16 then v8.liveTitle else v8.failedTitle
	local body = if v16 then v8.liveBody else v8.failedBody
	return {
		title = title,
		body = body,
		media = media,
		actions = actions,
		shown = v15.shown,
		topInset = v11 + v10.Size.Size_1400 + (not FFlagMomentsFollowingFeed and 0 or v10.Size.Size_800) + v10.Padding.Small,
		leftInset = v12.left,
		rightInset = v12.right
	}
end

return usePostStatusCardViewModel
