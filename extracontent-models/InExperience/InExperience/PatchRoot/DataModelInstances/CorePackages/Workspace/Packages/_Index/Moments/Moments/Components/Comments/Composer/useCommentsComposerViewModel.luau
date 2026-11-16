local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ReactUtils = require(parent.ReactUtils)
local useEventCallback = ReactUtils.useEventCallback

local FIntMomentsCommentMaxLength = require(Moments.Flags.FIntMomentsCommentMaxLength)
local GetCommentCollectionStore = require(Moments.Components.Comments.GetCommentCollectionStore)
local getCommentsListCoordinator = require(Moments.Components.Comments.List.getCommentsListCoordinator)
require(script.Parent.CommentsComposerView)
local normalizeCommentText = require(script.Parent.normalizeCommentText)
local truncateToMaxLength = require(script.Parent.truncateToMaxLength)

local useLocalization = Localization.Hooks.useLocalization

local v = {
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

local v2 = {
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

local function getSubmissionErrorMessageName(errorCode: string) -- 1 equivalent call inferred from this helper
	return v2[errorCode] or "submissionFailed"
end

local function isBlank(state: string): boolean -- 1 equivalent call inferred from this helper
	return normalizeCommentText(state) == ""
end

local function useCommentsComposerViewModel(p)
	local state, setState = React.useState("")

	local text, v3 = React.useBinding("")
	local v4 = React.useCallback(function(p2: string)
		setState(p2)
		v3(p2)
	end, { v3 })
	local v5 = useLocalization(v)
	local state2, setState2 = React.useState(nil)
	local commentCollectionStore = GetCommentCollectionStore(false)
	local v6 = React.useMemo(function()
		return commentCollectionStore.getState(p.feedItemId)
	end, { commentCollectionStore, p.feedItemId })
	local v7 = SignalsReact.useSignalState(v6)
	local commentsListCoordinator = getCommentsListCoordinator(false)
	local submissionError = v7.submissionError
	local v8 = SignalsReact.useSignalState(commentsListCoordinator.getPostCooldownUntilMs) > DateTime.now().UnixTimestampMillis

	local useEffect = React.useEffect
	local function fn()
		if submissionError == nil then
			return
		end

		v4(submissionError.text)
		setState2(getSubmissionErrorMessageName(submissionError.errorCode)) -- inferred equivalent call
		commentCollectionStore.clearSubmissionError(p.feedItemId)
	end

	local feedItemId = p.feedItemId
	local errorCode

	if submissionError ~= nil then
		errorCode = submissionError.errorCode
	end

	local v9

	if submissionError ~= nil then
		v9 = submissionError.text
	end

	useEffect(fn, { commentCollectionStore, feedItemId, v4, errorCode, v9 })

	local isInputDisabled = v7.pendingSubmission ~= nil
	local isSubmitEnabled = not isInputDisabled and not isBlank(state) -- inferred equivalent call

	if v8 then
		isSubmitEnabled = false
	end

	local onTextChanged = React.useCallback(function(p2: string)
		if FIntMomentsCommentMaxLength > 0 then
			p2 = truncateToMaxLength(p2, FIntMomentsCommentMaxLength)
		end

		v4(p2)

		setState2(nil)
	end, { v4 })

	local onSubmit = useEventCallback(function()
		if not isSubmitEnabled then
			return
		end

		if commentsListCoordinator.submitComment(p.feedItemId, p.sessionId, normalizeCommentText(state)) then
			v4("")
			setState2(nil)
		end
	end)

	local v10 = v8 and state2 == nil and "rateLimited" or state2

	local v11 = {
		text = text,
		isInputDisabled = isInputDisabled,
		isSubmitEnabled = isSubmitEnabled,
		errorMessage = 0,
		onTextChanged = 0,
		onSubmit = 0
	}
	local errorMessage

	if v10 ~= nil then
		errorMessage = v5[v10]
	end

	v11.errorMessage = errorMessage
	v11.onTextChanged = onTextChanged
	v11.onSubmit = onSubmit
	return v11
end

return useCommentsComposerViewModel
