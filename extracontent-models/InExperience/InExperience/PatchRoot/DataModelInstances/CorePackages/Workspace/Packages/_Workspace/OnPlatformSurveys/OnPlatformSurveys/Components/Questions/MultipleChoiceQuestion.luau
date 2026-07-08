local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local List = Foundation.List
local ListItemInputType = Foundation.Enums.ListItemInputType
local View = Foundation.View
local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local t1 = {}
local t2 = {}

local function MultipleChoiceQuestion(t3: {[any]: any}) -- line: 30
	-- upvalues: InlineQuestionType (copy), t2 (copy), React (copy), t1 (copy), List (copy), inlineSurveyHelpers (copy), ListItemInputType (copy), View (copy)
	local question = t3.question
	local answer = t3.answer
	local onAnswerChanged = t3.onAnswerChanged
	local v17 = t3.isDisabled == true
	local v18 = question.type == InlineQuestionType.MultipleChoiceMulti
	local v19 = question.choices or t2
	local v20 = React.useMemo(function() -- line: 38
		-- upvalues: answer (copy), t1 (copy)
		local t4 = {}

		for _, v24 in answer.choiceIds or t1 do
			t4[v24] = true
		end

		return t4
	end, { answer })
	local v21 = React.useMemo(function() -- line: 46
		-- upvalues: v19 (copy), React (copy), List (copy), v17 (copy), onAnswerChanged (copy), inlineSurveyHelpers (copy), answer (copy), v18 (copy), ListItemInputType (copy), v20 (copy)
		local t5 = {}

		for v26, v27 in v19 do
			local id = v27.id

			t5[string.format("Choice_%d_%s", v26, id)] = React.createElement(List.Item, {
				title = v27.label,
				LayoutOrder = v26,
				onActivated = {
					onActivated = function() -- line: 55
						-- upvalues: v17 (copy), onAnswerChanged (copy), inlineSurveyHelpers (copy), answer (copy), id (copy), v18 (copy)
						if v17 then
							return
						end

						onAnswerChanged({
							choiceIds = inlineSurveyHelpers.toggleChoice(answer, id, v18)
						})
					end,
					inputType = if not v18 then ListItemInputType.Radio else ListItemInputType.Checkbox,
					isChecked = v20[id] == true
				}
			})
		end

		return t5
	end, {
		v19,
		answer,
		v20,
		v18,
		v17,
		onAnswerChanged
	})

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = t3.layoutOrder
	}, {
		Choices = React.createElement(List.Root, {
			LayoutOrder = 1,
			hasDivider = {
				hasDivider = true,
				isInset = false
			},
			isContained = {
				isContained = false,
				hasMargin = false
			}
		}, v21)
	})
end

return React.memo(MultipleChoiceQuestion)
