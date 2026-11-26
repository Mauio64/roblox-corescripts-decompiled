local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnswersCardView")

local useLocalization = Localization.Hooks.useLocalization

local function useAnswersCardViewModel(p2)
	local v5 = useLocalization({ answers = LocalizationStrings.ANSWER_FORM_ANSWERS })
	local v6, v7 = React.useBinding(0)
	local v8 = React.useCallback(function(p3)
		v7(p3.AbsoluteSize.Y)
	end, {})
	local v9 = {}

	for k, prompt in p2.prompts do
		local v10 = {}

		if prompt.customResponseText == nil then
			local selectedOptionId = prompt.selectedOptionId

			for k2, option in prompt.question.options do
				local v11

				if typeof(selectedOptionId) == "table" then
					v11 = table.find(selectedOptionId, option.id) ~= nil
				else
					v11 = selectedOptionId == option.id
				end

				if not v11 then
					continue
				end

				local v12 = { title = option.title, description = 0 }
				local v13 = if option.description ~= "" then option.description else nil
				v12.description = v13
				table.insert(v10, v12)
			end
		else
			table.insert(v10, { title = prompt.customResponseText })
		end

		table.insert(v9, { question = prompt.question.question, answers = v10 })
	end

	return {
		LayoutOrder = p2.LayoutOrder,
		Size = v6:map(function(p3)
			return UDim2.new(1, 0, 0, p3)
		end),
		headerText = v5.answers,
		rows = v9,
		onContentSizeChanged = v8
	}
end

return useAnswersCardViewModel
