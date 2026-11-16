local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)

require(BuildExperience.Chat.chatTypes)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
require(script.Parent.AnswersCardView)

local useLocalization = Localization.Hooks.useLocalization

local function useAnswersCardViewModel(p)
	local v = useLocalization({ answers = LocalizationStrings.ANSWER_FORM_ANSWERS })
	local v2, v3 = React.useBinding(0)
	local onContentSizeChanged = React.useCallback(function(p2)
		v3(p2.AbsoluteSize.Y)
	end, {})
	local rows = {}

	for _, prompt in p.prompts do
		local answers = {}

		if prompt.customResponseText == nil then
			local selectedOptionId = prompt.selectedOptionId

			for _, option in prompt.question.options do
				local v4

				if typeof(selectedOptionId) == "table" then
					v4 = table.find(selectedOptionId, option.id) ~= nil
				else
					v4 = selectedOptionId == option.id
				end

				if not v4 then
					continue
				end

				local v5 = { title = option.title, description = 0 }
				local description

				if option.description ~= "" then
					description = option.description
				end

				v5.description = description
				table.insert(answers, v5)
			end
		else
			table.insert(answers, { title = prompt.customResponseText })
		end

		table.insert(rows, { question = prompt.question.question, answers = answers })
	end

	return {
		LayoutOrder = p.LayoutOrder,
		Size = v2:map(function(p2: number)
			return UDim2.new(1, 0, 0, p2)
		end),
		headerText = v.answers,
		rows = rows,
		onContentSizeChanged = onContentSizeChanged
	}
end

return useAnswersCardViewModel
