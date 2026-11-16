local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
require(BuildExperience.Chat.chatTypes)
require(script.Parent.AnswerFormView)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local FFlagBuildExperienceAnswerFormStableInput = require(BuildExperience.Flags.FFlagBuildExperienceAnswerFormStableInput)

local function useStableCustomText(draft, p: string?)
	local binding, v = React.useBinding(draft and draft.getText() or "")
	React.useEffect(function()
		local v2 = draft and draft.getText() or ""

		if binding:getValue() ~= v2 then
			v(v2)
		end
	end, { draft })

	React.useEffect(function()
		if p == nil and (draft == nil or draft.getText() == nil) and binding:getValue() ~= "" then
			v("")
		end
	end, { p, draft })

	local ref = React.useRef(draft)
	ref.current = draft

	local setText = React.useCallback(function(value: string?)
		v(value or "")

		if ref.current then
			ref.current.setText(value)
		end
	end, {})

	return {
		binding = binding,
		setText = setText,
		onChanged = React.useCallback(function(p2: string)
			if p2 ~= binding:getValue() then
				setText(p2)
			end
		end, {})
	}
end

local function useAnswerFormViewModel(data)
	local state = data.state
	local draft

	if state then
		draft = state.draft
	else
		draft = nil
	end

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			if draft then
				return (draft.getText(p))
			end

			return nil
		end)
	end, { draft })
	local v2 = SignalsReact.useSignalState(v)
	local v3

	if FFlagBuildExperienceAnswerForm and FFlagBuildExperienceAnswerFormStableInput then
		v3 = useStableCustomText(draft, v2)
	end

	local v4 = Foundation.Hooks.useTokens()
	local v5 = useLocalization({
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

	local v6 = data.actions ~= nil and data.onSubmitText ~= nil and data.onStop ~= nil
	assert(v6, "Active answer form requires actions")

	local actions = data.actions
	local setText

	if v3 then
		setText = v3.setText
	else
		setText = state.draft.setText
	end

	local onSubmitText = data.onSubmitText
	local isReadOnly = data.isReadOnly == true
	local question = state.question
	local isMultiSelect = question.responseType == "multi_select"
	local isCustom = #question.options == 0 or v2 ~= nil

	local selectedOptionId = state.selectedOptionId
	local options = {}
	local customText = v2 or ""

	for _, option in question.options do
		local v7 = {
			id = option.id,
			title = option.title,
			description = option.description,
			isSelected = 0,
			onActivated = 0
		}
		local isSelected = not isCustom

		if isSelected then
			if typeof(selectedOptionId) == "table" then
				isSelected = table.find(selectedOptionId, option.id) ~= nil
			else
				isSelected = selectedOptionId == option.id
			end
		end

		v7.isSelected = isSelected

		function v7.onActivated()
			if state.isSubmitting or isReadOnly then
				return
			end

			setText(nil)
			local v8 = actions.onAnswerSelectedByToolCallId[state.toolCallId]

			if v8 ~= nil then
				if isCustom then
					v8(question, option, true)
				else
					v8(question, option)
				end
			end
		end

		table.insert(options, v7)
	end

	local v7 = string.match(customText, "^%s*(.-)%s*$") or ""
	local v8

	if typeof(selectedOptionId) == "table" then
		v8 = #selectedOptionId > 0
	else
		v8 = false
	end

	local isForwardDisabled = state.isSubmitting

	if not isForwardDisabled then
		if isReadOnly then
			isForwardDisabled = isReadOnly
		elseif isCustom then
			isForwardDisabled = v7 == ""
		else
			isForwardDisabled = not v8
		end
	end

	local v9 = {
		LayoutOrder = data.LayoutOrder,
		title = question.question,
		options = options,
		isMultiSelect = isMultiSelect,
		isSubmitting = state.isSubmitting,
		isReadOnly = isReadOnly,
		isCustom = isCustom,
		customText = customText,
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
	local customTextBinding

	if v3 then
		customTextBinding = v3.binding
	end

	v9.customTextBinding = customTextBinding
	v9.customLabel = v5.customOption
	v9.progressText = v5.progress
	v9.errorText = data.errorText
	v9.showForward = isMultiSelect or isCustom
	v9.isForwardDisabled = isForwardDisabled
	v9.footerInset = v4.Padding.Small
	function v9.onCustomActivated()
		if not (state.isSubmitting or isReadOnly) then
			setText("")
		end
	end
	v9.onCustomChanged = not v3 and function(p: string)
		state.draft.setText(p)
	end or v3.onChanged
	function v9.onForward()
		if isForwardDisabled then
			return
		end

		if isCustom then
			onSubmitText(state.toolCallId, question.id, v7)
			return
		end

		local v10 = actions.onAnswerConfirmedByToolCallId[state.toolCallId]

		if v10 ~= nil then
			v10()
		end
	end
	v9.onStop = data.onStop
	return v9
end

return useAnswerFormViewModel
