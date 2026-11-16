local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/UIBlox")
local UserProfile = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/UserProfile")

local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")
local GetCommentReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetCommentReactionsStore")
local useMomentGestures = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/useMomentGestures")
local usePreferredInput = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/usePreferredInput")
local CommentLongPressTiming = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentLongPressTiming")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentRowView")
local useCommentActionsMenu = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentActionsMenu")
local useCommentBodyClamp = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentBodyClamp")
local useCommentBodyPressFeedback = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentBodyPressFeedback")
local useCommentBodyToggle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentBodyToggle")
local useCommentBodyTranslationFade = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentBodyTranslationFade")
local useCommentTimestamp = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentTimestamp")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")

local fFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities

local feedbackManagerInjectionContext = UIBlox.Core.Control.FeedbackManagerInjectionContext
local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	info = Signals.createComputed(function(p2): nil
		return nil
	end),
	status = Signals.createComputed(function(p2): string
		return "Ready"
	end)
}

local function nonEmpty(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return p2
end

local function getTranslationToggle(p2, onToggle)
	if p2 == nil or onToggle == nil then
		return nil
	end

	return {
		isShowingTranslation = p2 == "Translated",
		onToggle = onToggle
	}
end

local function countForEmote(p2, p3)
	if p2 == nil or p3 == nil then
		return 0
	end

	for k, count in p2.counts do
		if count.emoteId == p3 then
			return count.count
		end
	end

	return 0
end

local function useCommentRowViewModel(data)
	local v6 = React.useMemo(function()
		return MomentsGetMomentsCommentsStore(false).getCachedComment(data.commentId)
	end, { data.commentId })
	local v7 = SignalsReact.useSignalState(v6.data)
	local userId = if not (v7 == nil or v7.author == nil) then v7.author.userId else nil
	local v8 = if userId ~= nil then tonumber(userId) else nil

	if v8 ~= nil and v8 <= 0 then
		v8 = nil
	end

	local v9 = React.useMemo(function()
		if v8 == nil then
			return v5
		end

		return UserProfile.getAndFetchUserInfo(v8)
	end, { v8 })
	local v10 = SignalsReact.useSignalState(v9.info)
	local v11 = SignalsReact.useSignalState(v9.status)
	local username

	if not (v7 == nil or v7.author == nil) then
		username = v7.author.username

		if username == nil or username == "" then
			username = nil
		end
	end

	local displayName

	if not (v7 == nil or v7.author == nil) then
		displayName = v7.author.displayName

		if displayName == nil or displayName == "" then
			displayName = nil
		end
	end

	local username2

	if v10 ~= nil then
		username2 = v10.username

		if username2 == nil or username2 == "" then
			username2 = nil
		end
	end

	local displayName2

	if v10 ~= nil then
		displayName2 = v10.displayName

		if displayName2 == nil or displayName2 == "" then
			displayName2 = nil
		end
	end

	local label = useLocalization({
		label = userId == nil and "Feature.Moments.Label.CommentAuthorUnknown" or {
			"Feature.Moments.Label.CommentAuthorFallback",
			userId = userId
		}
	}).label
	local viewerUsername = data.viewerUsername

	if viewerUsername == nil or viewerUsername == "" then
		viewerUsername = nil
	end

	if v7 == nil or not v7.isAuthoredByViewer then
		viewerUsername = nil
	end

	local v13 = if data.createdAt == "" then v7 == nil and "" or v7.createdAt else data.createdAt
	local v14 = useCommentTimestamp(v13)
	local reactions = if v7 ~= nil then v7.reactions else nil
	local v15 = GetCommentReactionsStore(false)
	local v16 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return v15.getProjection(data.feedItemId, data.commentId, reactions, p2)
		end)
	end, {
		v15,
		data.feedItemId,
		data.commentId,
		reactions or false
	})
	local v17 = SignalsReact.useSignalState(v16)
	local v18 = SignalsReact.useSignalState(v15.getCooldownUntilMs)
	local reactions2 = v17.reactions
	local thumbsUpEmoteId = data.thumbsUpEmoteId
	local v19 = not (reactions == nil or reactions2 == nil) and thumbsUpEmoteId ~= nil
	local emoteId

	if not (reactions2 == nil or reactions2.userReaction == nil) then
		emoteId = reactions2.userReaction.emoteId
	end

	local v20 = not (thumbsUpEmoteId == nil) and emoteId == thumbsUpEmoteId
	local v21 = emoteId ~= nil and not v20
	local v22 = not data.creatorEnabled
		or not data.viewerCanWrite
		or v17.restriction ~= nil
		or DateTime.now().UnixTimestampMillis < v18
		or v21
	local v23

	if reactions2 == nil or thumbsUpEmoteId == nil then
		v23 = 0
	else
		local flag = true

		for k, count in reactions2.counts do
			if count.emoteId == thumbsUpEmoteId then
				v23 = count.count
				flag = false
				break
			end
		end

		if flag then
			v23 = 0
		end
	end

	local v24 = Localization.abbreviateCount(v23, LocalizationService.RobloxLocaleId) or tostring(v23)
	local v25

	if fFlagMomentsEngagementMetricsFeature then
		v25 = not SignalsReact.useSignalState(getMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	local v26 = v19 and not (v22 or v20)
	local v27 = React.useCallback(function()
		if not v19 or v22 or reactions == nil or thumbsUpEmoteId == nil then
			return
		end

		data.onToggleReaction(data.commentId, thumbsUpEmoteId, reactions, v20)
	end, {
		v19,
		v22,
		reactions,
		thumbsUpEmoteId,
		data.onToggleReaction,
		data.commentId,
		v20
	})

	local v28 = React.useCallback(function()
		if not v19 or v22 or v20 or reactions == nil or thumbsUpEmoteId == nil then
			return
		end

		data.onAddReaction(data.commentId, thumbsUpEmoteId, reactions)
	end, {
		v19,
		v22,
		v20,
		reactions,
		thumbsUpEmoteId,
		data.onAddReaction,
		data.commentId
	})

	local v29 = usePreferredInput() == Enum.PreferredInput.Touch
	local v30 = React.useContext(feedbackManagerInjectionContext)
	local v32 = {
		commentId = data.commentId,
		isAuthoredByViewer = v7 ~= nil and v7.isAuthoredByViewer,
		authorUserId = 0,
		onReportComment = 0,
		onBlockCommentAuthor = 0,
		onDeleteComment = 0
	}
	local v34 = if v7 ~= nil and v8 ~= nil then tostring(v8) else nil
	v32.authorUserId = v34
	v32.onReportComment = data.onReportComment
	v32.onBlockCommentAuthor = data.onBlockCommentAuthor
	v32.onDeleteComment = data.onDeleteComment
	local v35 = useCommentActionsMenu(v32)

	local v36 = #v35.items > 0
	local v37 = v29 and v36
	local isExpanded = data.isExpanded == true
	local v38 = useCommentBodyClamp(data.text, isExpanded)

	local v39 = useCommentBodyToggle(v38, data.onToggleExpanded, data.commentId, isExpanded, v26)
	local v40 = useCommentBodyPressFeedback(data.commentId, v39.canToggle)

	local v41 = useCommentBodyTranslationFade(data.commentId, data.translationState, v40.textStyle)
	local v42 = v26 or v37 or v39.isActive

	local state, setState = React.useState(nil)
	React.useLayoutEffect(function()
		setState(nil)
	end, { data.commentId })
	local v43 = React.useCallback(function()
		setState(data.commentId)
	end, { data.commentId })
	local v44 = React.useCallback(function()
		setState(nil)
	end, {})
	local openMenu = v35.openMenu
	local v45 = React.useCallback(function()
		setState(nil)
		v30("TileLongPress", "Press")
		openMenu()
	end, { v30, openMenu })

	local v47 = {
		onTap = v39.onTap,
		onSingleTapConfirmed = v39.onSingleTapConfirmed,
		onDoubleTap = v28,
		onLongPress = 0,
		onLongPressStart = 0,
		onLongPressCancel = 0
	}

	if not v37 then
		v45 = nil
	end

	v47.onLongPress = v45

	if not v37 then
		v43 = nil
	end

	v47.onLongPressStart = v43

	if not v37 then
		v44 = nil
	end

	v47.onLongPressCancel = v44
	local v48 = useMomentGestures(v42, v47, nil, {
		scrollingFrameRef = data.scrollingFrameRef,
		cancelWhenInactive = true,
		cancelOnUserScroll = true,
		longPressThreshold = CommentLongPressTiming.HOLD_SECONDS
	})

	local v49 = {
		commentId = data.commentId,
		avatarUserId = v8,
		authorLabel = username or viewerUsername or username2 or displayName or displayName2 or label,
		isAuthorLoading = (username or viewerUsername or displayName) == nil and v10 == nil and v11 == "NotReady",
		text = data.text,
		bodyText = v38.bodyText,
		bodyRef = v38.bodyRef,
		bodyMeasureRef = v38.measureRef,
		onBodyAbsoluteSizeChanged = v38.onBodyAbsoluteSizeChanged,
		bodyTextStyle = v41,
		metadataLabel = v14,
		avatarBackgroundStyle = data.avatarBackgroundStyle,
		gestureRef = v48.ref,
		showReactionControl = v19,
		isReactionSelected = v20,
		isReactionDisabled = v22,
		reactionCountLabel = v24,
		isReactionCountHidden = v25,
		onReactionActivated = v27,
		actionsMenu = 0,
		deleteConfirmation = 0,
		translationToggle = 0,
		isLongPressCharging = 0,
		isGestureSurfaceActive = 0,
		onContentStateChanged = 0
	}
	local v51

	if v36 then
		v51 = {
			items = v35.items,
			isOpen = v35.isOpen,
			anchorRef = 0,
			onButtonActivated = 0,
			onClose = 0
		}
		local v52 = if v29 then v48.ref else nil
		v51.anchorRef = v52
		v51.onButtonActivated = v35.toggleMenu
		v51.onClose = v35.closeMenu
	end

	v49.actionsMenu = v51

	v49.deleteConfirmation = v35.deleteConfirmation
	local translationState = data.translationState
	local onToggleTranslation = data.onToggleTranslation
	v49.translationToggle = translationState ~= nil and onToggleTranslation ~= nil and {
		isShowingTranslation = translationState == "Translated",
		onToggle = onToggleTranslation
	} or nil

	if state ~= data.commentId then
		v37 = false
	end

	v49.isLongPressCharging = v37
	v49.isGestureSurfaceActive = v42
	v49.onContentStateChanged = v40.onStateChanged
	return v49
end

return useCommentRowViewModel
