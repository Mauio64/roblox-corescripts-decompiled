local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local list = Foundation.List
local listItemInputType = Foundation.Enums.ListItemInputType
local textInput = Foundation.TextInput
local view = Foundation.View

local fFlagInlineSurveyChoiceTextEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags").FFlagInlineSurveyChoiceTextEntry

local inlineSurveyHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Utils/inlineSurveyHelpers")
local InlineQuestionType = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineQuestionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local v5 = {}
local v6 = {}

local function MultipleChoiceQuestion(props)
	local question = props.question
	local answer = props.answer
	local onAnswerChanged = props.onAnswerChanged
	local isDisabled = props.isDisabled == true
	local v7 = question.type == InlineQuestionType.MultipleChoiceMulti
	local choices = question.choices or v6

	local v8 = React.useMemo(function()
		local result = {}

		for k, v9 in answer.choiceIds or v5 do
			result[v9] = true
		end

		return result
	end, { answer })

	local ref = React.useRef(answer)
	ref.current = answer

	local v9 = React.useMemo(function()
		local children = {}

		for k, choice in choices do
			local id = choice.id

			local v10 = string.format("Choice_%d_%s", k, id)
			local createElement = React.createElement
			local item = list.Item
			local v11 = { title = choice.label, LayoutOrder = 0, onActivated = 0 }

			local v12 = if fFlagInlineSurveyChoiceTextEntry then k * 2 else k
			v11.LayoutOrder = v12
			local v13 = {
				onActivated = function()
					if isDisabled then
						return
					end

					local v15 = {
						choiceIds = inlineSurveyHelpers.toggleChoice(answer, id, v7),
						choiceTexts = 0
					}
					local v16 = if fFlagInlineSurveyChoiceTextEntry then answer.choiceTexts else nil
					v15.choiceTexts = v16
					onAnswerChanged(v15)
				end,
				inputType = 0,
				isChecked = 0
			}
			local v14 = if v7 then listItemInputType.Checkbox else listItemInputType.Radio
			v13.inputType = v14
			v13.isChecked = v8[id] == true
			v11.onActivated = v13
			children[v10] = createElement(item, v11)

			if fFlagInlineSurveyChoiceTextEntry and choice.requiresText == true then
				children[string.format("ChoiceText_%d_%s", k, id)] = React.createElement(textInput, {
					text = answer.choiceTexts == nil and "" or answer.choiceTexts[id] or "",
					label = "",
					width = UDim.new(1, 0),
					isDisabled = isDisabled,
					LayoutOrder = k * 2 + 1,
					onChanged = function(p2)
						if isDisabled then
							return
						end

						local current = ref.current
						local v15 = current.choiceTexts == nil and {} or table.clone(current.choiceTexts)
						v15[id] = p2
						onAnswerChanged({
							choiceIds = current.choiceIds,
							choiceTexts = v15
						})
					end
				})
			end
		end

		return children
	end, { choices, answer, v8, v7, isDisabled, onAnswerChanged })

	return React.createElement(
		view,
		{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		{
			Choices = React.createElement(list.Root, {
				LayoutOrder = 1,
				hasDivider = { hasDivider = true, isInset = false },
				isContained = { isContained = false, hasMargin = false }
			}, v9)
		}
	)
end

return React.memo(MultipleChoiceQuestion)
