local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local FFlagInlineSurveyEnhancements = require(OnPlatformSurveysParent.SharedFlags).FFlagInlineSurveyEnhancements
local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local Phase = require(OnPlatformSurveys.Enums.Phase)
local questionRenderers = require(OnPlatformSurveys.Components.Questions.questionRenderers)

require(OnPlatformSurveys.Hooks.inlineSurveyReducer)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function LoadingBody(t1: {[any]: any}) -- line: 60
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local Size_600 = t1.tokens.Size.Size_600

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y"
	}, {
		Line1 = React.createElement(Skeleton, {
			LayoutOrder = 1,
			radius = EnumsRadius.Medium,
			Size = UDim2.new(1, 0, 0, Size_600)
		}),
		Line2 = React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = EnumsRadius.Medium,
			Size = UDim2.new(1, 0, 0, Size_600)
		}),
		Line3 = React.createElement(Skeleton, {
			LayoutOrder = 3,
			radius = EnumsRadius.Medium,
			Size = UDim2.new(0.6, 0, 0, Size_600)
		})
	})
end
local function QuestionBody(t2: {[any]: any}) -- line: 83
	-- upvalues: questionRenderers (copy), Phase (copy), React (copy), View (copy), FoundationText (copy)
	local v19 = t2.state.questions[t2.state.index]
	local v20 = questionRenderers.renderQuestion({
		layoutOrder = 2,
		question = v19,
		answer = t2.state.answer,
		onAnswerChanged = t2.onAnswerChanged,
		isDisabled = t2.state.phase == Phase.Submitting
	})

	return React.createElement(View, {
		tag = "col gap-xlarge size-full-0 auto-y"
	}, {
		Title = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1,
			Text = v19.title
		}),
		Input = v20
	})
end

return {
	getSlots = function(p1, t3: {[any]: any}, p2, t4: {[any]: any}) -- line: 105
		-- upvalues: Phase (copy), React (copy), FoundationText (copy), ButtonVariant (copy), LoadingBody (copy), QuestionBody (copy), FFlagInlineSurveyEnhancements (copy), inlineSurveyHelpers (copy)
		if p1.phase == Phase.Invite then
			return {
				headerTitle = t3.surveyTitle,
				body = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					Text = t3.inviteBody
				}),
				primaryAction = {
					text = t3.inviteAccept,
					variant = ButtonVariant.Emphasis,
					onActivated = t4.onAccept
				}
			}
		end

		if p1.phase == Phase.Loading then
			return {
				headerTitle = nil,
				primaryAction = nil,
				body = React.createElement(LoadingBody, {
					tokens = p2
				})
			}
		end

		if p1.phase == Phase.Error then
			return {
				headerTitle = nil,
				body = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
					Text = t3.errorText
				}),
				primaryAction = {
					text = t3.retry,
					variant = ButtonVariant.Standard,
					onActivated = t4.onRetry
				}
			}
		end

		if p1.phase == Phase.Completed then
			return {
				body = nil,
				headerTitle = t3.completedTitle,
				primaryAction = {
					text = t3.done,
					variant = ButtonVariant.Emphasis,
					onActivated = t4.onDismiss
				}
			}
		end

		if (p1.phase == Phase.Started or p1.phase == Phase.Submitting) and p1.questions[p1.index] ~= nil then
			local v25 = p1.phase == Phase.Submitting
			local v26 = React.createElement(QuestionBody, {
				state = p1,
				onAnswerChanged = t4.onAnswerChanged
			})

			if FFlagInlineSurveyEnhancements then
				local v27 = inlineSurveyHelpers.isLastQuestion(p1.questions, p1.index, p1.answer)
				local v28 = v25 or not inlineSurveyHelpers.canAdvance(p1.questions, p1.index, p1.answersByQuestionId, p1.answer)

				return {
					headerTitle = t3.surveyTitle,
					body = v26,
					primaryAction = {
						text = if not v27 then t3.next else t3.send,
						variant = ButtonVariant.Emphasis,
						onActivated = t4.onSubmit,
						isLoading = v25,
						isDisabled = v28
					}
				}
			end

			local v29 = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(p1.answersByQuestionId, p1.questions[p1.index], p1.answer)
			local v30 = v25 or not inlineSurveyHelpers.canSubmitAll(p1.questions, v29)

			return {
				headerTitle = t3.surveyTitle,
				body = v26,
				primaryAction = {
					text = t3.send,
					variant = ButtonVariant.Emphasis,
					onActivated = t4.onSubmit,
					isLoading = v25,
					isDisabled = v30
				}
			}
		end

		return {
			headerTitle = nil,
			body = nil,
			primaryAction = nil
		}
	end
}
