local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements
local FFlagInlineSurveyChoiceTextEntry = SharedFlags.FFlagInlineSurveyChoiceTextEntry

local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)
local MultipleChoiceQuestion = require(OnPlatformSurveys.Components.Questions.MultipleChoiceQuestion)
local TextQuestion = require(OnPlatformSurveys.Components.Questions.TextQuestion)
local ThumbsQuestion = require(OnPlatformSurveys.Components.Questions.ThumbsQuestion)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function isThumbsQuestion(question): boolean
	if question.type ~= InlineQuestionType.MultipleChoiceSingle then
		return false
	end

	local choices = question.choices

	if choices == nil or #choices ~= 2 then
		return false
	end

	if FFlagInlineSurveyChoiceTextEntry then
		for _, choice in choices do
			if choice.requiresText == true then
				return false
			end
		end
	end

	local idSet = {}

	for _, choice in choices do
		idSet[choice.id] = true
	end

	return idSet["1"] == true and idSet["2"] == true
end

return {
	renderQuestion = function(props)
		local question = props.question

		if isThumbsQuestion(question) then
			return React.createElement(ThumbsQuestion, props)
		end

		if FFlagInlineSurveyEnhancements and question.type == InlineQuestionType.Text then
			return React.createElement(TextQuestion, {
				answer = props.answer,
				onAnswerChanged = props.onAnswerChanged,
				isDisabled = props.isDisabled,
				layoutOrder = props.layoutOrder
			})
		end

		if
			question.type == InlineQuestionType.MultipleChoiceSingle
			or question.type == InlineQuestionType.MultipleChoiceMulti
		then
			return React.createElement(MultipleChoiceQuestion, {
				question = question,
				answer = props.answer,
				onAnswerChanged = props.onAnswerChanged,
				isDisabled = props.isDisabled,
				layoutOrder = props.layoutOrder
			})
		end

		return nil
	end,
	isThumbsQuestion = isThumbsQuestion
}
