local LocalizationService = game:GetService("LocalizationService")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UIBlox = require(parent.UIBlox)
local UserProfile = require(parent.DataHydration.UserProfile)

local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
local GetCommentReactionsStore = require(Moments.Stores.GetCommentReactionsStore)
local useMomentGestures = require(Moments.Components.Feed.Items.Moment.Reactions.useMomentGestures)
local usePreferredInput = require(Moments.Hooks.usePreferredInput)
local CommentLongPressTiming = require(script.Parent.CommentLongPressTiming)
require(script.Parent.CommentRowView)
local useCommentActionsMenu = require(script.Parent.useCommentActionsMenu)
local useCommentBodyClamp = require(script.Parent.useCommentBodyClamp)
local useCommentBodyPressFeedback = require(script.Parent.useCommentBodyPressFeedback)
local useCommentBodyToggle = require(script.Parent.useCommentBodyToggle)
local useCommentBodyTranslationFade = require(script.Parent.useCommentBodyTranslationFade)
local useCommentTimestamp = require(script.Parent.useCommentTimestamp)
require(script.Parent.Parent.CommentRowTypes)

local FFlagMomentsEngagementMetricsFeature = MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities

local FeedbackManagerInjectionContext = UIBlox.Core.Control.FeedbackManagerInjectionContext
local useLocalization = Localization.Hooks.useLocalization

local v = {
	info = Signals.createComputed(function(_): nil
		return nil
	end),
	status = Signals.createComputed(function(_): string
		return "Ready"
	end)
}

local function nonEmpty(p: string?) -- 5 equivalent calls inferred from this helper
	return if not (p == nil or p == "") then p else nil
end

local function getTranslationToggle(translationState, onToggle) -- 1 equivalent call inferred from this helper
	if translationState == nil or onToggle == nil then
		return nil
	end

	return {
		isShowingTranslation = translationState == "Translated",
		onToggle = onToggle
	}
end

local function countForEmote(reactions, thumbsUpEmoteId: string?) -- 1 equivalent call inferred from this helper
	if reactions == nil or thumbsUpEmoteId == nil then
		return 0
	end

	for _, count in reactions.counts do
		if count.emoteId == thumbsUpEmoteId then
			return count.count
		end
	end

	return 0
end

local function useCommentRowViewModel(data)
	local v2 = React.useMemo(function()
		return MomentsGetMomentsCommentsStore(false).getCachedComment(data.commentId)
	end, { data.commentId })
	local v3 = SignalsReact.useSignalState(v2.data)
	local userId

	if not (v3 == nil or v3.author == nil) then
		userId = v3.author.userId
	end

	local avatarUserId

	if userId == nil then
		avatarUserId = nil
	else
		avatarUserId = tonumber(userId)
	end

	if avatarUserId ~= nil and avatarUserId <= 0 then
		avatarUserId = nil
	end

	local v4 = React.useMemo(function()
		if avatarUserId == nil then
			return v
		end

		return UserProfile.getAndFetchUserInfo(avatarUserId)
	end, { avatarUserId })
	local v5 = SignalsReact.useSignalState(v4.info)
	local v6 = SignalsReact.useSignalState(v4.status)
	local username

	if not (v3 == nil or v3.author == nil) then
		username = v3.author.username
		username = nonEmpty(username) -- inferred equivalent call
	end

	local displayName

	if not (v3 == nil or v3.author == nil) then
		displayName = v3.author.displayName
		displayName = nonEmpty(displayName) -- inferred equivalent call
	end

	local username2

	if v5 ~= nil then
		username2 = v5.username
		username2 = nonEmpty(username2) -- inferred equivalent call
	end

	local displayName2

	if v5 ~= nil then
		displayName2 = v5.displayName
		displayName2 = nonEmpty(displayName2) -- inferred equivalent call
	end

	local label = useLocalization({
		label = userId == nil and "Feature.Moments.Label.CommentAuthorUnknown" or {
			"Feature.Moments.Label.CommentAuthorFallback",
			userId = userId
		}
	}).label
	local v7 = nonEmpty(data.viewerUsername) -- inferred equivalent call

	if v3 == nil or not v3.isAuthoredByViewer then
		v7 = nil
	end

	local v8

	if data.createdAt == "" then
		v8 = v3 == nil and "" or v3.createdAt
	else
		v8 = data.createdAt
	end

	local metadataLabel = useCommentTimestamp(v8)
	local reactions

	if v3 == nil then
		reactions = nil
	else
		reactions = v3.reactions
	end

	local commentReactionsStore = GetCommentReactionsStore(false)
	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return commentReactionsStore.getProjection(data.feedItemId, data.commentId, reactions, p)
		end)
	end, {
		commentReactionsStore,
		data.feedItemId,
		data.commentId,
		reactions or false
	})
	local v10 = SignalsReact.useSignalState(v9)
	local v11 = SignalsReact.useSignalState(commentReactionsStore.getCooldownUntilMs)
	local reactions2 = v10.reactions
	local thumbsUpEmoteId = data.thumbsUpEmoteId
	local showReactionControl

	if reactions == nil or reactions2 == nil then
		showReactionControl = false
	else
		showReactionControl = thumbsUpEmoteId ~= nil
	end

	local emoteId

	if not (reactions2 == nil or reactions2.userReaction == nil) then
		emoteId = reactions2.userReaction.emoteId
	end

	local isReactionSelected

	if thumbsUpEmoteId == nil then
		isReactionSelected = false
	else
		isReactionSelected = emoteId == thumbsUpEmoteId
	end

	local v12 = emoteId ~= nil and not isReactionSelected
	local isReactionDisabled = not data.creatorEnabled
		or not data.viewerCanWrite
		or v10.restriction ~= nil
		or DateTime.now().UnixTimestampMillis < v11
		or v12
	local v13 = countForEmote(reactions2, thumbsUpEmoteId) -- inferred equivalent call
	local reactionCountLabel = Localization.abbreviateCount(v13, LocalizationService.RobloxLocaleId) or tostring(v13)
	local isReactionCountHidden

	if FFlagMomentsEngagementMetricsFeature then
		isReactionCountHidden = not SignalsReact.useSignalState(GetMomentsCapabilities(false).getIsEngagementMetricsEnabled)
	end

	local v14 = showReactionControl and not (isReactionDisabled or isReactionSelected)
	local onReactionActivated = React.useCallback(function()
		if not showReactionControl or isReactionDisabled or reactions == nil or thumbsUpEmoteId == nil then
			return
		end

		data.onToggleReaction(data.commentId, thumbsUpEmoteId, reactions, isReactionSelected)
	end, {
		showReactionControl,
		isReactionDisabled,
		reactions,
		thumbsUpEmoteId,
		data.onToggleReaction,
		data.commentId,
		isReactionSelected
	})

	local onDoubleTap = React.useCallback(function()
		if
			not showReactionControl
			or isReactionDisabled
			or isReactionSelected
			or reactions == nil
			or thumbsUpEmoteId == nil
		then
			return
		end

		data.onAddReaction(data.commentId, thumbsUpEmoteId, reactions)
	end, {
		showReactionControl,
		isReactionDisabled,
		isReactionSelected,
		reactions,
		thumbsUpEmoteId,
		data.onAddReaction,
		data.commentId
	})

	local v15 = usePreferredInput() == Enum.PreferredInput.Touch
	local v16 = React.useContext(FeedbackManagerInjectionContext)
	local v17 = {
		commentId = data.commentId,
		isAuthoredByViewer = v3 ~= nil and v3.isAuthoredByViewer,
		authorUserId = 0,
		onReportComment = 0,
		onBlockCommentAuthor = 0,
		onDeleteComment = 0
	}
	local authorUserId

	if not (v3 == nil or avatarUserId == nil) then
		authorUserId = tostring(avatarUserId)
	end

	v17.authorUserId = authorUserId
	v17.onReportComment = data.onReportComment
	v17.onBlockCommentAuthor = data.onBlockCommentAuthor
	v17.onDeleteComment = data.onDeleteComment
	local v18 = useCommentActionsMenu(v17)

	local v19 = #v18.items > 0
	local isLongPressCharging = v15 and v19
	local isExpanded = data.isExpanded == true
	local v20 = useCommentBodyClamp(data.text, isExpanded)

	local v21 = useCommentBodyToggle(v20, data.onToggleExpanded, data.commentId, isExpanded, v14)
	local v22 = useCommentBodyPressFeedback(data.commentId, v21.canToggle)

	local bodyTextStyle = useCommentBodyTranslationFade(data.commentId, data.translationState, v22.textStyle)
	local isGestureSurfaceActive = v14 or isLongPressCharging or v21.isActive

	local state, setState = React.useState(nil)
	React.useLayoutEffect(function()
		setState(nil)
	end, { data.commentId })
	local onLongPressStart = React.useCallback(function()
		setState(data.commentId)
	end, { data.commentId })
	local onLongPressCancel = React.useCallback(function()
		setState(nil)
	end, {})
	local openMenu = v18.openMenu
	local onLongPress = React.useCallback(function()
		setState(nil)
		v16("TileLongPress", "Press")
		openMenu()
	end, { v16, openMenu })

	local v23 = {
		onTap = v21.onTap,
		onSingleTapConfirmed = v21.onSingleTapConfirmed,
		onDoubleTap = onDoubleTap,
		onLongPress = 0,
		onLongPressStart = 0,
		onLongPressCancel = 0
	}

	if not isLongPressCharging then
		onLongPress = nil
	end

	v23.onLongPress = onLongPress

	if not isLongPressCharging then
		onLongPressStart = nil
	end

	v23.onLongPressStart = onLongPressStart

	if not isLongPressCharging then
		onLongPressCancel = nil
	end

	v23.onLongPressCancel = onLongPressCancel
	local v24 = useMomentGestures(isGestureSurfaceActive, v23, nil, {
		scrollingFrameRef = data.scrollingFrameRef,
		cancelWhenInactive = true,
		cancelOnUserScroll = true,
		longPressThreshold = CommentLongPressTiming.HOLD_SECONDS
	})

	local v25 = {
		commentId = data.commentId,
		avatarUserId = avatarUserId,
		authorLabel = username or v7 or username2 or displayName or displayName2 or label,
		isAuthorLoading = (username or v7 or displayName) == nil and v5 == nil and v6 == "NotReady",
		text = data.text,
		bodyText = v20.bodyText,
		bodyRef = v20.bodyRef,
		bodyMeasureRef = v20.measureRef,
		onBodyAbsoluteSizeChanged = v20.onBodyAbsoluteSizeChanged,
		bodyTextStyle = bodyTextStyle,
		metadataLabel = metadataLabel,
		avatarBackgroundStyle = data.avatarBackgroundStyle,
		gestureRef = v24.ref,
		showReactionControl = showReactionControl,
		isReactionSelected = isReactionSelected,
		isReactionDisabled = isReactionDisabled,
		reactionCountLabel = reactionCountLabel,
		isReactionCountHidden = isReactionCountHidden,
		onReactionActivated = onReactionActivated,
		actionsMenu = 0,
		deleteConfirmation = 0,
		translationToggle = 0,
		isLongPressCharging = 0,
		isGestureSurfaceActive = 0,
		onContentStateChanged = 0
	}
	local actionsMenu

	if v19 then
		actionsMenu = {
			items = v18.items,
			isOpen = v18.isOpen,
			anchorRef = 0,
			onButtonActivated = 0,
			onClose = 0
		}
		local anchorRef

		if v15 then
			anchorRef = v24.ref
		end

		actionsMenu.anchorRef = anchorRef
		actionsMenu.onButtonActivated = v18.toggleMenu
		actionsMenu.onClose = v18.closeMenu
	end

	v25.actionsMenu = actionsMenu

	v25.deleteConfirmation = v18.deleteConfirmation
	v25.translationToggle = getTranslationToggle(data.translationState, data.onToggleTranslation) -- inferred equivalent call

	if state ~= data.commentId then
		isLongPressCharging = false
	end

	v25.isLongPressCharging = isLongPressCharging
	v25.isGestureSurfaceActive = isGestureSurfaceActive
	v25.onContentStateChanged = v22.onStateChanged
	return v25
end

return useCommentRowViewModel
