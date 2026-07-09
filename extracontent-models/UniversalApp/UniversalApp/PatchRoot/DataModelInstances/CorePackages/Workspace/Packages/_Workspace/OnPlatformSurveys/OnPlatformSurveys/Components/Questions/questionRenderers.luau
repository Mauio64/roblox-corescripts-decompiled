local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local React = require(OnPlatformSurveysParent.React)
local FFlagInlineSurveyEnhancements = require(OnPlatformSurveysParent.SharedFlags).FFlagInlineSurveyEnhancements
local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)
local MultipleChoiceQuestion = require(OnPlatformSurveys.Components.Questions.MultipleChoiceQuestion)
local TextQuestion = require(OnPlatformSurveys.Components.Questions.TextQuestion)
local ThumbsQuestion = require(OnPlatformSurveys.Components.Questions.ThumbsQuestion)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function isThumbsQuestion(p1) -- line: 33
	-- upvalues: InlineQuestionType (copy)
	if p1.type ~= InlineQuestionType.MultipleChoiceSingle then
		return false
	end

	local choices = p1.choices

	if choices == nil or #choices ~= 2 then
		return false
	end

	local t1 = {}

	for _, v14 in choices do
		t1[v14.id] = true
	end

	return t1["1"] == true and t1["2"] == true
end

return {
	renderQuestion = function(t2: {[any]: any}) -- line: 48
		-- upvalues: isThumbsQuestion (copy), React (copy), ThumbsQuestion (copy), FFlagInlineSurveyEnhancements (copy), InlineQuestionType (copy), TextQuestion (copy), MultipleChoiceQuestion (copy)
		local question = t2.question

		if isThumbsQuestion(question) then
			return React.createElement(ThumbsQuestion, t2)
		end

		if FFlagInlineSurveyEnhancements and question.type == InlineQuestionType.Text then
			return React.createElement(TextQuestion, {
				answer = t2.answer,
				onAnswerChanged = t2.onAnswerChanged,
				isDisabled = t2.isDisabled,
				layoutOrder = t2.layoutOrder
			})
		end

		if question.type == InlineQuestionType.MultipleChoiceSingle or question.type == InlineQuestionType.MultipleChoiceMulti then
			return React.createElement(MultipleChoiceQuestion, {
				question = question,
				answer = t2.answer,
				onAnswerChanged = t2.onAnswerChanged,
				isDisabled = t2.isDisabled,
				layoutOrder = t2.layoutOrder
			})
		end

		return nil
	end,
	isThumbsQuestion = isThumbsQuestion
}
