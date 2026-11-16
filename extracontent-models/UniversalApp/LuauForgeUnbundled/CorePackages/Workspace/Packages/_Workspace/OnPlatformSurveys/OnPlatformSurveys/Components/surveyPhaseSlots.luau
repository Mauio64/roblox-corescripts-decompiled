local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local buttonVariant = Foundation.Enums.ButtonVariant
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local fFlagInlineSurveyEnhancements = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags").FFlagInlineSurveyEnhancements

local inlineSurveyHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Utils/inlineSurveyHelpers")
local Phase = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Phase")
local questionRenderers = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/Questions/questionRenderers")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Hooks/inlineSurveyReducer")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local function LoadingBody(p2)
	local size_600 = p2.tokens.Size.Size_600
	return React.createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
		Line1 = React.createElement(skeleton, {
			radius = radius.Medium,
			Size = UDim2.new(1, 0, 0, size_600),
			LayoutOrder = 1
		}),
		Line2 = React.createElement(skeleton, {
			radius = radius.Medium,
			Size = UDim2.new(1, 0, 0, size_600),
			LayoutOrder = 2
		}),
		Line3 = React.createElement(skeleton, {
			radius = radius.Medium,
			Size = UDim2.new(0.6, 0, 0, size_600),
			LayoutOrder = 3
		})
	})
end

local function QuestionBody(p2)
	local question = p2.state.questions[p2.state.index]
	local question2 = questionRenderers.renderQuestion({
		question = question,
		answer = p2.state.answer,
		onAnswerChanged = p2.onAnswerChanged,
		isDisabled = p2.state.phase == Phase.Submitting,
		layoutOrder = 2
	})

	return React.createElement(view, { tag = "col gap-xlarge size-full-0 auto-y" }, {
		Title = React.createElement(text, {
			Text = question.title,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Input = question2
	})
end

return {
	getSlots = function(props, props2, p2, props3)
		if props.phase == Phase.Invite then
			return {
				headerTitle = props2.surveyTitle,
				body = React.createElement(text, {
					Text = props2.inviteBody,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
				}),
				primaryAction = {
					text = props2.inviteAccept,
					variant = buttonVariant.Emphasis,
					onActivated = props3.onAccept
				}
			}
		end

		if props.phase == Phase.Loading then
			return {
				headerTitle = nil,
				body = React.createElement(LoadingBody, { tokens = p2 }),
				primaryAction = nil
			}
		end

		if props.phase == Phase.Error then
			return {
				headerTitle = nil,
				body = React.createElement(text, {
					Text = props2.errorText,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default"
				}),
				primaryAction = {
					text = props2.retry,
					variant = buttonVariant.Standard,
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
					variant = buttonVariant.Emphasis,
					onActivated = props3.onDismiss
				}
			}
		end

		if
			props.phase ~= Phase.Started and props.phase ~= Phase.Submitting
			or props.questions[props.index] == nil
		then
			return { headerTitle = nil, body = nil, primaryAction = nil }
		end

		local v5 = props.phase == Phase.Submitting
		local element = React.createElement(QuestionBody, {
			state = props,
			onAnswerChanged = props3.onAnswerChanged
		})

		if fFlagInlineSurveyEnhancements then
			local lastQuestion = inlineSurveyHelpers.isLastQuestion(props.questions, props.index, props.answer)

			local v6 = v5
				or not inlineSurveyHelpers.canAdvance(
					props.questions,
					props.index,
					props.answersByQuestionId,
					props.answer
				)
			local v7 = {
				headerTitle = props2.surveyTitle,
				body = element,
				primaryAction = 0
			}

			local v9 = if lastQuestion then props2.send else props2.next
			v7.primaryAction = {
				text = v9,
				variant = buttonVariant.Emphasis,
				onActivated = props3.onSubmit,
				isLoading = v5,
				isDisabled = v6
			}
			return v7
		else
			local mergeCurrentAnswerIntoBatch = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(
				props.answersByQuestionId,
				props.questions[props.index],
				props.answer
			)
			local v6 = v5 or not inlineSurveyHelpers.canSubmitAll(props.questions, mergeCurrentAnswerIntoBatch)
			return {
				headerTitle = props2.surveyTitle,
				body = element,
				primaryAction = {
					text = props2.send,
					variant = buttonVariant.Emphasis,
					onActivated = props3.onSubmit,
					isLoading = v5,
					isDisabled = v6
				}
			}
		end
	end
}
