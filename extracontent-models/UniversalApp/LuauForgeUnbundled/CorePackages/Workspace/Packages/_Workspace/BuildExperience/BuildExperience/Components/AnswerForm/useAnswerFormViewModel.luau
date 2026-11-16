local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerForm/AnswerFormView")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local FFlagBuildExperienceAnswerFormStableInput = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerFormStableInput")

local function useStableCustomText(draft, p2)
	local v5, v6 = React.useBinding(draft and draft.getText() or "")
	React.useEffect(function()
		local v7 = draft and draft.getText() or ""

		if v5:getValue() ~= v7 then
			v6(v7)
		end
	end, { draft })

	React.useEffect(function()
		if p2 == nil and (draft == nil or draft.getText() == nil) and v5:getValue() ~= "" then
			v6("")
		end
	end, { p2, draft })

	local ref = React.useRef(draft)
	ref.current = draft

	local v7 = React.useCallback(function(value)
		v6(value or "")

		if ref.current then
			ref.current.setText(value)
		end
	end, {})

	return {
		binding = v5,
		setText = v7,
		onChanged = React.useCallback(function(p3)
			if p3 ~= v5:getValue() then
				v7(p3)
			end
		end, {})
	}
end

local function useAnswerFormViewModel(data)
	local state = data.state
	local draft = if state then state.draft else nil
	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if draft then
				return (draft.getText(p2))
			end

			return nil
		end)
	end, { draft })
	local v6 = SignalsReact.useSignalState(v5)

	local v7 = if FFlagBuildExperienceAnswerForm and FFlagBuildExperienceAnswerFormStableInput then useStableCustomText(draft, v6) else nil

	local v8 = Foundation.Hooks.useTokens()
	local v9 = useLocalization({
		customOption = LocalizationStrings.ANSWER_FORM_CUSTOM_OPTION,
		progress = {
			"CommonUI.Controls.Label.PageCount",
			["current:int"] = not state and 0 or state.questionIndex,
			["total:int"] = not state and 0 or state.questionCount
		}
	})

	if state == nil then
		return nil
	end

	local v10 = data.actions ~= nil and data.onSubmitText ~= nil and data.onStop ~= nil
	assert(v10, "Active answer form requires actions")

	local actions = data.actions
	local setText = if v7 then v7.setText else state.draft.setText
	local onSubmitText = data.onSubmitText
	local isReadOnly = data.isReadOnly == true
	local question = state.question
	local v11 = question.responseType == "multi_select"
	local v12 = #question.options == 0 or v6 ~= nil

	local selectedOptionId = state.selectedOptionId
	local v13 = {}
	local v14 = v6 or ""

	for k, option in question.options do
		local v15 = {
			id = option.id,
			title = option.title,
			description = option.description,
			isSelected = 0,
			onActivated = 0
		}
		local v16 = not v12

		if v16 then
			if typeof(selectedOptionId) == "table" then
				v16 = table.find(selectedOptionId, option.id) ~= nil
			else
				v16 = selectedOptionId == option.id
			end
		end

		v15.isSelected = v16

		function v15.onActivated()
			if state.isSubmitting or isReadOnly then
				return
			end

			setText(nil)
			local v17 = actions.onAnswerSelectedByToolCallId[state.toolCallId]

			if v17 ~= nil then
				if v12 then
					v17(question, option, true)
				else
					v17(question, option)
				end
			end
		end

		table.insert(v13, v15)
	end

	local v15 = string.match(v14, "^%s*(.-)%s*$") or ""
	local v16 = typeof(selectedOptionId) == "table" and #selectedOptionId > 0
	local v17 = state.isSubmitting

	if not v17 then
		v17 = if isReadOnly then isReadOnly elseif v12 then v15 == "" else not v16
	end

	local v18 = {
		LayoutOrder = data.LayoutOrder,
		title = question.question,
		options = v13,
		isMultiSelect = v11,
		isSubmitting = state.isSubmitting,
		isReadOnly = isReadOnly,
		isCustom = v12,
		customText = v14,
		customTextBinding = 0,
		customLabel = 0,
		progressText = 0,
		errorText = 0,
		showForward = 0,
		isForwardDisabled = 0,
		footerInset = 0,
		onCustomActivated = 0,
		onCustomChanged = 0,
		onForward = 0,
		onStop = 0
	}

	local v19 = if v7 then v7.binding else nil
	v18.customTextBinding = v19
	v18.customLabel = v9.customOption
	v18.progressText = v9.progress
	v18.errorText = data.errorText
	v18.showForward = v11 or v12
	v18.isForwardDisabled = v17
	v18.footerInset = v8.Padding.Small
	function v18.onCustomActivated()
		if not (state.isSubmitting or isReadOnly) then
			setText("")
		end
	end
	v18.onCustomChanged = not v7 and function(p2)
		state.draft.setText(p2)
	end or v7.onChanged
	function v18.onForward()
		if v17 then
			return
		end

		if v12 then
			onSubmitText(state.toolCallId, question.id, v15)
			return
		end

		local v20 = actions.onAnswerConfirmedByToolCallId[state.toolCallId]

		if v20 ~= nil then
			v20()
		end
	end
	v18.onStop = data.onStop
	return v18
end

return useAnswerFormViewModel
