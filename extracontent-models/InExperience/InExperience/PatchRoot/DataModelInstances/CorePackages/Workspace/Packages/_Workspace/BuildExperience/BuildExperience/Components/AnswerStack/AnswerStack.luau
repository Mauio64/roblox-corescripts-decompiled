local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local OptionSelector = require(script.Parent.OptionSelector)

local Button = Foundation.Button
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function isOptionSelected(selectedOptionId, id: string): boolean -- 1 equivalent call inferred from this helper
	if typeof(selectedOptionId) == "string" then
		return selectedOptionId == id
	end

	if typeof(selectedOptionId) ~= "table" then
		return false
	end

	for _, item in selectedOptionId do
		if item == id then
			return true
		end
	end

	return false
end

local function getFirstSelectedOptionId(selectedOptionId) -- 1 equivalent call inferred from this helper
	if typeof(selectedOptionId) == "string" then
		return selectedOptionId
	end

	if typeof(selectedOptionId) == "table" then
		return selectedOptionId[1]
	end

	return nil
end

local function AnswerStack(props)
	local v = useLocalization({
		selectAnOption = LocalizationStrings.ANSWER_STACK_SELECT_AN_OPTION,
		submit = LocalizationStrings.ANSWER_STACK_SUBMIT
	})

	local onOptionSelected = props.onOptionSelected
	local options = props.options
	local v2 = (props.selectionMode or "single") == "multi"

	local selectedOptionId = props.selectedOptionId
	local onConfirm = props.onConfirm
	local v3 = v2 and onConfirm ~= nil
	local v4

	if not (v3 or selectedOptionId == nil) then
		v4 = getFirstSelectedOptionId(selectedOptionId) -- inferred equivalent call
	end

	local children = {}

	for k, option in options do
		if not (v4 == nil or option.id == v4) then
			continue
		end

		local id = option.id
		children[id] = React.createElement(OptionSelector, {
			LayoutOrder = k,
			title = option.title,
			description = option.description,
			isSelected = isOptionSelected(selectedOptionId, option.id), -- inferred equivalent call
			selectionStyle = v3 and "intermediate" or "committed",
			testId = `AnswerStack.Option.{option.id}`,
			onActivated = function()
				onOptionSelected(option)
			end
		})
	end

	local v5 = {
		Options = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-medium size-full-0 auto-y"
		}, children)
	}

	if v3 and onConfirm ~= nil then
		local isConfirmDisabled = props.isConfirmDisabled == true
		local createElement = React.createElement

		local createElement2 = React.createElement
		local text

		if isConfirmDisabled then
			text = v.selectAnOption
		else
			text = props.confirmLabel or v.submit
		end

		v5.Confirm = createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right size-full-0 auto-y"
		}, {
			Button = createElement2(Button, {
				text = text,
				size = InputSize.Medium,
				variant = ButtonVariant.Standard,
				isDisabled = isConfirmDisabled,
				onActivated = onConfirm,
				testId = `{props.testId or "AnswerStack"}.Confirm`
			})
		})
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		testId = props.testId or "AnswerStack",
		tag = "col gap-medium size-full-0 auto-y padding-top-small"
	}, v5)
end

return AnswerStack
