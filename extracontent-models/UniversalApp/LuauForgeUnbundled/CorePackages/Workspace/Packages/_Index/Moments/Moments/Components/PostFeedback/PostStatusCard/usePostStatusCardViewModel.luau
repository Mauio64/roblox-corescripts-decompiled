local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local buttonVariant = Foundation.Enums.ButtonVariant
local eventNames = MomentsCommon.Analytics.EventNames
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local useTokens = Foundation.Hooks.useTokens
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusCard/PostStatusCardView")
local GetPostStatusCardStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetPostStatusCardStore")
local makePostFeedbackEventFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makePostFeedbackEventFields")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetPostStatusCardStore/createPostStatusCardStore")
local createRecommendationTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/createRecommendationTelemetry")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local makeRecommendationAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeRecommendationAttribution")
local SignalActionType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/SignalActionType")
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local shareMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Share/shareMoment")
local useMomentsTabIsVisible = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMomentsTabIsVisible")
local usePostStatusCardMotion = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusCard/usePostStatusCardMotion")
local usePostFeedbackStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePostFeedbackStrings")
local FFlagMomentsFollowingFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFollowingFeed")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments

local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore") else nil

local FFlagMomentsCreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAnalytics")

local v6 = if FFlagMomentsCreatorAnalytics then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsPageStore") else nil

game:DefineFastInt("MomentsPostStatusLiveDismissSeconds", 5)
game:DefineFastInt("MomentsPostStatusFailedDismissSeconds", 5)

local v7 = {
	shareLinkTitle = "Feature.Moments.Label.ShareLinkTitle",
	linkCopied = "Feature.Moments.Label.LinkCopied",
	linkCopyFailed = "Feature.Moments.Label.LinkCopyFailed"
}

local function isShownCardType(p2): boolean
	return p2.cardType == "Live" or p2.cardType == "UploadFailed"
end

local function getOldestShownCard(list)
	for i = #list, 1, -1 do
		local item = list[i]

		if item.cardType == "Live" or item.cardType == "UploadFailed" then
			return list[i]
		end
	end

	return nil
end

local function getShareFeedItemId(p2)
	local publishedMoment = p2.publishedMoment

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

	local v9 = {
		momentId = data.id,
		content = localContent,
		posterContent = 0,
		captureType = 0
	}

	if captureType == Enum.CaptureType.Video then
		localContent = nil
	end

	v9.posterContent = localContent
	v9.captureType = captureType
	return { kind = "thumbnail", mediaItem = v9 }
end

local function usePostStatusCardViewModel()
	local v8 = GetPostStatusCardStore(false)
	local v9 = useSignalState(v8.getCards)
	local v10 = useMomentsTabIsVisible()

	local v11 = useSignalState(reportModalCovering.getCovering)
	local v12 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v13

	if fFlagMomentsComments and v5 ~= nil then
		v13 = useSignalState(v5(false).getIsExpanded)
	else
		v13 = false
	end

	local v14 = if FFlagMomentsCreatorAnalytics and v6 ~= nil then useSignalState(v6(false).getIsOpen) else false

	local v15 = usePostFeedbackStrings()
	local v16 = useLocalization(v7)
	local v17 = useTokens()
	local v18 = useStatusBarHeight()
	local v19 = useDeviceInsets()
	local v20 = useMomentsSession()

	local v21 = React.useMemo(function()
		if fFlagEnableArgus then
			return createRecommendationTelemetry({ getMomentsSessionId = v20.getMomentsSessionId })
		end

		return nil
	end, { v20 })

	local ref = React.useRef(nil)
	local v22

	if v10 and not (v11 or v12 or v13 or v14) then
		local flag = true

		for i = #v9, 1, -1 do
			local v23 = v9[i]

			if v23.cardType == "Live" or v23.cardType == "UploadFailed" then
				v22 = v9[i]
				flag = false
				break
			end
		end

		if flag then
			v22 = nil
		end
	else
		v22 = nil
	end

	local id = if v22 ~= nil then v22.id else nil
	local cardType = if v22 ~= nil then v22.cardType else nil
	local v23 = usePostStatusCardMotion(id)
	local hide = v23.hide

	React.useEffect(function()
		if id == nil then
			return nil
		end

		local v24

		if cardType == "Live" then
			v24 = game:GetFastInt("MomentsPostStatusLiveDismissSeconds")
		else
			v24 = game:GetFastInt("MomentsPostStatusFailedDismissSeconds")
		end

		local thread = task.delay(v24, function()
			ref.current = id
			hide(function()
				v8.dismiss(id)
			end)
		end)
		return function()
			task.cancel(thread)
		end
	end, { v8, id, cardType, hide })

	local ref2 = React.useRef(v22)
	ref2.current = v22
	React.useEffect(function()
		local current = ref2.current

		if current == nil or not v8.markShown(current.id) then
			return
		end

		local v24 = makePostFeedbackEventFields(current)
		v24.cardType = current.cardType
		fireAnalyticsEvent(eventNames.MomentPostStatusCardShown, v24)
	end, { v8, id })

	local v24 = React.useMemo(function()
		if v22 == nil then
			return nil
		end

		return makeMedia(v22)
	end, { v22 })

	if v22 == nil then
		return nil
	end

	local function close(): boolean
		if ref.current == v22.id then
			return false
		end

		ref.current = v22.id
		hide(function()
			v8.dismiss(v22.id)
		end)
		return true
	end

	local v25 = {}
	local publishedMoment = v22.publishedMoment
	local feedItemId

	if publishedMoment == nil then
		feedItemId = nil
	else
		feedItemId = publishedMoment.recommendationMetadata.feedItemId

		if feedItemId == nil or feedItemId == "" then
			feedItemId = nil
		end
	end

	local publishedMoment2 = v22.publishedMoment

	if v22.cardType == "Live" and publishedMoment2 ~= nil and feedItemId ~= nil then
		table.insert(v25, {
			text = v15.share,
			variant = buttonVariant.SoftEmphasis,
			onActivated = function()
				local v26

				if ref.current == v22.id then
					v26 = false
				else
					ref.current = v22.id
					hide(function()
						v8.dismiss(v22.id)
					end)
					v26 = true
				end

				if not v26 then
					return
				end

				fireAnalyticsEvent(eventNames.MomentPostStatusCardShareTapped, makePostFeedbackEventFields(v22))
				local v27 = makeRecommendationAttribution(publishedMoment2.recommendationMetadata, publishedMoment2)
				shareMoment({
					momentId = publishedMoment2.momentId,
					feedItemId = feedItemId,
					feedSessionId = publishedMoment2.recommendationMetadata.tracingId,
					description = publishedMoment2.metadata.description,
					logAction = v21 ~= nil and v27 ~= nil and function(p2)
						return v21.logAction(SignalActionType.Share, v27, p2)
					end or nil,
					strings = {
						linkPreviewTitle = v16.shareLinkTitle,
						linkCopied = v16.linkCopied,
						linkCopyFailed = v16.linkCopyFailed
					}
				})
			end
		})
	end

	table.insert(v25, {
		text = v15.dismiss,
		variant = buttonVariant.Standard,
		onActivated = function()
			local flag

			if ref.current == v22.id then
				flag = false
			else
				ref.current = v22.id
				hide(function()
					v8.dismiss(v22.id)
				end)
				flag = true
			end

			if flag then
				local v26 = makePostFeedbackEventFields(v22)
				v26.cardType = v22.cardType
				v26.dismissMethod = "button"
				fireAnalyticsEvent(eventNames.MomentPostStatusCardDismissed, v26)
			end
		end
	})

	local v26 = v22.cardType == "Live"

	local v28 = if v26 then v15.liveTitle else v15.failedTitle
	local v29 = if v26 then v15.liveBody else v15.failedBody
	return {
		title = v28,
		body = v29,
		media = v24,
		actions = v25,
		shown = v23.shown,
		topInset = v18 + v17.Size.Size_1400 + (not FFlagMomentsFollowingFeed and 0 or v17.Size.Size_800) + v17.Padding.Small,
		leftInset = v19.left,
		rightInset = v19.right
	}
end

return usePostStatusCardViewModel
