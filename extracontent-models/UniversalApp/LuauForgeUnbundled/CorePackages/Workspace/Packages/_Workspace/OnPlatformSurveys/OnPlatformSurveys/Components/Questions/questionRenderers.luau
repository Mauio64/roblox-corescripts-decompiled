local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags")
local fFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements
local fFlagInlineSurveyChoiceTextEntry = SharedFlags.FFlagInlineSurveyChoiceTextEntry

local InlineQuestionType = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineQuestionType")
local MultipleChoiceQuestion = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/Questions/MultipleChoiceQuestion")
local TextQuestion = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/Questions/TextQuestion")
local ThumbsQuestion = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/Questions/ThumbsQuestion")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local function isThumbsQuestion(question): boolean
	if question.type ~= InlineQuestionType.MultipleChoiceSingle then
		return false
	end

	local choices = question.choices

	if choices == nil or #choices ~= 2 then
		return false
	end

	if fFlagInlineSurveyChoiceTextEntry then
		for k, choice in choices do
			if choice.requiresText == true then
				return false
			end
		end
	end

	local idSet = {}

	for k, choice in choices do
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

		if fFlagInlineSurveyEnhancements and question.type == InlineQuestionType.Text then
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
