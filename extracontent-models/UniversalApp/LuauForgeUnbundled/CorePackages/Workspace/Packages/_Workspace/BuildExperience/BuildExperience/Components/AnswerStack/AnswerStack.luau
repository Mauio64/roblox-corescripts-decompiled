local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local OptionSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AnswerStack/OptionSelector")

local button = Foundation.Button
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function isOptionSelected(value, p2): boolean
	if typeof(value) == "string" then
		return value == p2
	end

	if typeof(value) ~= "table" then
		return false
	end

	for k, item in value do
		if item == p2 then
			return true
		end
	end

	return false
end

local function getFirstSelectedOptionId(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) == "table" then
		return value[1]
	end

	return nil
end

local function AnswerStack(props)
	local v5 = useLocalization({
		selectAnOption = LocalizationStrings.ANSWER_STACK_SELECT_AN_OPTION,
		submit = LocalizationStrings.ANSWER_STACK_SUBMIT
	})

	local onOptionSelected = props.onOptionSelected
	local options = props.options
	local v6 = (props.selectionMode or "single") == "multi"

	local selectedOptionId = props.selectedOptionId
	local onConfirm = props.onConfirm
	local v7 = v6 and onConfirm ~= nil
	local v8

	if not (v7 or selectedOptionId == nil) then
		if typeof(selectedOptionId) == "string" then
			v8 = selectedOptionId
		elseif typeof(selectedOptionId) == "table" then
			v8 = selectedOptionId[1]
		end
	end

	local children = {}

	for k, option in options do
		if not (v8 == nil or option.id == v8) then
			continue
		end

		local id = option.id
		local createElement = React.createElement
		local v10 = {
			LayoutOrder = k,
			title = option.title,
			description = option.description,
			isSelected = 0,
			selectionStyle = 0,
			testId = 0,
			onActivated = 0
		}
		local id2 = option.id
		local v11

		if typeof(selectedOptionId) == "string" then
			v11 = selectedOptionId == id2
		elseif typeof(selectedOptionId) == "table" then
			local flag = true

			for k2, item in selectedOptionId do
				if item == id2 then
					v11 = true
					flag = false
					break
				end
			end

			if flag then
				v11 = false
			end
		else
			v11 = false
		end

		v10.isSelected = v11
		v10.selectionStyle = v7 and "intermediate" or "committed"
		v10.testId = `AnswerStack.Option.{option.id}`
		function v10.onActivated()
			onOptionSelected(option)
		end

		children[id] = createElement(OptionSelector, v10)
	end

	local v9 = {
		Options = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "col gap-medium size-full-0 auto-y" },
			children
		)
	}

	if v7 and onConfirm ~= nil then
		local isConfirmDisabled = props.isConfirmDisabled == true
		local createElement = React.createElement

		local createElement2 = React.createElement

		local v15 = if isConfirmDisabled then v5.selectAnOption else props.confirmLabel or v5.submit
		v9.Confirm = createElement(
			view,
			{ LayoutOrder = 2, tag = "row align-x-right size-full-0 auto-y" },
			{
				Button = createElement2(button, {
					text = v15,
					size = inputSize.Medium,
					variant = buttonVariant.Standard,
					isDisabled = isConfirmDisabled,
					onActivated = onConfirm,
					testId = `{props.testId or "AnswerStack"}.Confirm`
				})
			}
		)
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		testId = props.testId or "AnswerStack",
		tag = "col gap-medium size-full-0 auto-y padding-top-small"
	}, v9)
end

return AnswerStack
