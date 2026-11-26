local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local useEventCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils").useEventCallback

local FIntMomentsCommentMaxLength = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FIntMomentsCommentMaxLength")
local GetCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore")
local getCommentsListCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/getCommentsListCoordinator")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/CommentsComposerView")
local normalizeCommentText = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/normalizeCommentText")
local truncateToMaxLength = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/truncateToMaxLength")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	textFilterRejected = "Feature.Moments.Label.CommentRejectedByFilter",
	rateLimited = "Feature.Moments.Label.CommentRateLimited",
	submissionFailed = "Feature.Moments.Label.CommentPostFailed",
	outcomeUnknown = "Feature.Moments.Label.CommentPostOutcomeUnknown",
	commentsDisabled = "Feature.Moments.Label.CommentsTurnedOff",
	writeNotAllowed = "Feature.Moments.Label.CommentNotAllowed",
	momentUnavailable = "Feature.Moments.Label.MomentNoLongerAvailable",
	signInRequired = "Feature.Moments.Label.CommentSignInRequired",
	commentsOff = "Feature.Moments.Label.CommentingUnavailable"
}

local v6 = {
	TextFilterRejected = "textFilterRejected",
	RateLimited = "rateLimited",
	CommentsDisabledByCreator = "commentsDisabled",
	ViewerNotEligibleToWrite = "writeNotAllowed",
	ViewerNotEligibleToRead = "momentUnavailable",
	MomentUnavailable = "momentUnavailable",
	AuthenticationRequired = "signInRequired",
	CommentsEndpointDisabled = "commentsOff",
	CommentsEndpointNotImplemented = "commentsOff",
	SubmissionOutcomeUnknown = "outcomeUnknown"
}

local function getSubmissionErrorMessageName(p2)
	return v6[p2] or "submissionFailed"
end

local function isBlank(p2): boolean
	return normalizeCommentText(p2) == ""
end

local function useCommentsComposerViewModel(p2)
	local state, setState = React.useState("")

	local v7, v8 = React.useBinding("")
	local v9 = React.useCallback(function(p3)
		setState(p3)
		v8(p3)
	end, { v8 })
	local v10 = useLocalization(v5)
	local state2, setState2 = React.useState(nil)
	local v11 = GetCommentCollectionStore(false)
	local v12 = React.useMemo(function()
		return v11.getState(p2.feedItemId)
	end, { v11, p2.feedItemId })
	local v13 = SignalsReact.useSignalState(v12)
	local v14 = getCommentsListCoordinator(false)
	local submissionError = v13.submissionError
	local v15 = SignalsReact.useSignalState(v14.getPostCooldownUntilMs) > DateTime.now().UnixTimestampMillis

	local useEffect = React.useEffect
	local function fn()
		if submissionError == nil then
			return
		end

		v9(submissionError.text)
		setState2(v6[submissionError.errorCode] or "submissionFailed")
		v11.clearSubmissionError(p2.feedItemId)
	end

	local feedItemId = p2.feedItemId

	local errorCode = if submissionError ~= nil then submissionError.errorCode else nil
	local v17 = if submissionError ~= nil then submissionError.text else nil
	useEffect(fn, { v11, feedItemId, v9, errorCode, v17 })

	local v18 = v13.pendingSubmission ~= nil
	local v19 = not v18

	if v19 then
		v19 = normalizeCommentText(state) ~= ""
	end

	if v15 then
		v19 = false
	end

	local v20 = React.useCallback(function(p3)
		if FIntMomentsCommentMaxLength > 0 then
			p3 = truncateToMaxLength(p3, FIntMomentsCommentMaxLength)
		end

		v9(p3)

		setState2(nil)
	end, { v9 })

	local v21 = useEventCallback(function()
		if not v19 then
			return
		end

		if v14.submitComment(p2.feedItemId, p2.sessionId, normalizeCommentText(state)) then
			v9("")
			setState2(nil)
		end
	end)

	local v22 = v15 and state2 == nil and "rateLimited" or state2

	local v23 = {
		text = v7,
		isInputDisabled = v18,
		isSubmitEnabled = v19,
		errorMessage = 0,
		onTextChanged = 0,
		onSubmit = 0
	}

	local v24 = if v22 ~= nil then v10[v22] else nil
	v23.errorMessage = v24
	v23.onTextChanged = v20
	v23.onSubmit = v21
	return v23
end

return useCommentsComposerViewModel
