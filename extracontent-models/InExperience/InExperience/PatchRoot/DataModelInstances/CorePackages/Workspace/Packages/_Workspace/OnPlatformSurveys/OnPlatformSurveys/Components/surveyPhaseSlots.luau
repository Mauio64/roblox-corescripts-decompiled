local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ButtonVariant = Foundation.Enums.ButtonVariant
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements

local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local Phase = require(OnPlatformSurveys.Enums.Phase)
local questionRenderers = require(OnPlatformSurveys.Components.Questions.questionRenderers)
require(OnPlatformSurveys.Hooks.inlineSurveyReducer)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function LoadingBody(p)
	local size_600 = p.tokens.Size.Size_600
	return React.createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, {
		Line1 = React.createElement(Skeleton, {
			radius = Radius.Medium,
			Size = UDim2.new(1, 0, 0, size_600),
			LayoutOrder = 1
		}),
		Line2 = React.createElement(Skeleton, {
			radius = Radius.Medium,
			Size = UDim2.new(1, 0, 0, size_600),
			LayoutOrder = 2
		}),
		Line3 = React.createElement(Skeleton, {
			radius = Radius.Medium,
			Size = UDim2.new(0.6, 0, 0, size_600),
			LayoutOrder = 3
		})
	})
end

local function QuestionBody(p)
	local question = p.state.questions[p.state.index]
	local question2 = questionRenderers.renderQuestion({
		question = question,
		answer = p.state.answer,
		onAnswerChanged = p.onAnswerChanged,
		isDisabled = p.state.phase == Phase.Submitting,
		layoutOrder = 2
	})

	return React.createElement(View, { tag = "col gap-xlarge size-full-0 auto-y" }, {
		Title = React.createElement(Text, {
			Text = question.title,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Input = question2
	})
end

return {
	getSlots = function(props, props2, tokens, props3)
		if props.phase == Phase.Invite then
			return {
				headerTitle = props2.surveyTitle,
				body = React.createElement(Text, {
					Text = props2.inviteBody,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
				}),
				primaryAction = {
					text = props2.inviteAccept,
					variant = ButtonVariant.Emphasis,
					onActivated = props3.onAccept
				}
			}
		end

		if props.phase == Phase.Loading then
			return {
				headerTitle = nil,
				body = React.createElement(LoadingBody, { tokens = tokens }),
				primaryAction = nil
			}
		end

		if props.phase == Phase.Error then
			return {
				headerTitle = nil,
				body = React.createElement(Text, {
					Text = props2.errorText,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				}),
				primaryAction = {
					text = props2.retry,
					variant = ButtonVariant.Standard,
					onActivated = props3.onRetry
				}
			}
		end

		if props.phase == Phase.Completed then
			return {
				headerTitle = props2.completedTitle,
				body = nil,
				primaryAction = {
					text = props2.done,
					variant = ButtonVariant.Emphasis,
					onActivated = props3.onDismiss
				}
			}
		end

		if props.phase ~= Phase.Started and props.phase ~= Phase.Submitting or props.questions[props.index] == nil then
			return { headerTitle = nil, body = nil, primaryAction = nil }
		end

		local isLoading = props.phase == Phase.Submitting
		local element = React.createElement(QuestionBody, {
			state = props,
			onAnswerChanged = props3.onAnswerChanged
		})

		if FFlagInlineSurveyEnhancements then
			local lastQuestion = inlineSurveyHelpers.isLastQuestion(props.questions, props.index, props.answer)

			local isDisabled = isLoading
				or not inlineSurveyHelpers.canAdvance(
					props.questions,
					props.index,
					props.answersByQuestionId,
					props.answer
				)
			local v = { headerTitle = props2.surveyTitle, body = element, primaryAction = 0 }
			local text

			if lastQuestion then
				text = props2.send
			else
				text = props2.next
			end

			v.primaryAction = {
				text = text,
				variant = ButtonVariant.Emphasis,
				onActivated = props3.onSubmit,
				isLoading = isLoading,
				isDisabled = isDisabled
			}
			return v
		else
			local mergeCurrentAnswerIntoBatch = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(
				props.answersByQuestionId,
				props.questions[props.index],
				props.answer
			)
			local isDisabled = isLoading
				or not inlineSurveyHelpers.canSubmitAll(props.questions, mergeCurrentAnswerIntoBatch)
			return {
				headerTitle = props2.surveyTitle,
				body = element,
				primaryAction = {
					text = props2.send,
					variant = ButtonVariant.Emphasis,
					onActivated = props3.onSubmit,
					isLoading = isLoading,
					isDisabled = isDisabled
				}
			}
		end
	end
}
