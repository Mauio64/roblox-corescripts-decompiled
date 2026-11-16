local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local List = Foundation.List
local ListItemInputType = Foundation.Enums.ListItemInputType
local TextInput = Foundation.TextInput
local View = Foundation.View

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyChoiceTextEntry = SharedFlags.FFlagInlineSurveyChoiceTextEntry

local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local v = {}
local v2 = {}

local function MultipleChoiceQuestion(props)
	local question = props.question
	local answer = props.answer
	local onAnswerChanged = props.onAnswerChanged
	local isDisabled = props.isDisabled == true
	local v3 = question.type == InlineQuestionType.MultipleChoiceMulti
	local choices = question.choices or v2

	local v4 = React.useMemo(function()
		local result = {}

		for _, v4 in answer.choiceIds or v do
			result[v4] = true
		end

		return result
	end, { answer })

	local ref = React.useRef(answer)
	ref.current = answer

	local v5 = React.useMemo(function()
		local children = {}

		for k, choice in choices do
			local id = choice.id

			local v5 = string.format("Choice_%d_%s", k, id)
			local createElement = React.createElement
			local item = List.Item
			local v6 = { title = choice.label, LayoutOrder = 0, onActivated = 0 }
			local layoutOrder

			if FFlagInlineSurveyChoiceTextEntry then
				layoutOrder = k * 2
			else
				layoutOrder = k
			end

			v6.LayoutOrder = layoutOrder
			local onActivated = {
				onActivated = function()
					if isDisabled then
						return
					end

					local v7 = {
						choiceIds = inlineSurveyHelpers.toggleChoice(answer, id, v3),
						choiceTexts = 0
					}
					local choiceTexts

					if FFlagInlineSurveyChoiceTextEntry then
						choiceTexts = answer.choiceTexts
					end

					v7.choiceTexts = choiceTexts
					onAnswerChanged(v7)
				end,
				inputType = 0,
				isChecked = 0
			}
			local inputType

			if v3 then
				inputType = ListItemInputType.Checkbox
			else
				inputType = ListItemInputType.Radio
			end

			onActivated.inputType = inputType
			onActivated.isChecked = v4[id] == true
			v6.onActivated = onActivated
			children[v5] = createElement(item, v6)

			if FFlagInlineSurveyChoiceTextEntry and choice.requiresText == true then
				children[string.format("ChoiceText_%d_%s", k, id)] = React.createElement(TextInput, {
					text = answer.choiceTexts == nil and "" or answer.choiceTexts[id] or "",
					label = "",
					width = UDim.new(1, 0),
					isDisabled = isDisabled,
					LayoutOrder = k * 2 + 1,
					onChanged = function(p: string)
						if isDisabled then
							return
						end

						local current = ref.current
						local choiceTexts = current.choiceTexts == nil and {} or table.clone(current.choiceTexts)
						choiceTexts[id] = p
						onAnswerChanged({ choiceIds = current.choiceIds, choiceTexts = choiceTexts })
					end
				})
			end
		end

		return children
	end, { choices, answer, v4, v3, isDisabled, onAnswerChanged })

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}, {
		Choices = React.createElement(List.Root, {
			LayoutOrder = 1,
			hasDivider = { hasDivider = true, isInset = false },
			isContained = { isContained = false, hasMargin = false }
		}, v5)
	})
end

return React.memo(MultipleChoiceQuestion)
