local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local OptionSelector = require(script.Parent.OptionSelector)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function isOptionSelected(p1, s1: string) -- line: 37
	if typeof(p1) == "string" then
		return p1 == s1
	end

	if typeof(p1) ~= "table" then
		return false
	end

	for _, v17 in p1 do
		if v17 == s1 then
			return true
		end
	end

	return false
end
local function getFirstSelectedOptionId(p2) -- line: 52
	if typeof(p2) == "string" then
		return p2
	end

	if typeof(p2) == "table" then
		return p2[1]
	end

	return nil
end
local function AnswerStack(t1: {[any]: any}) -- line: 62
	-- upvalues: React (copy), OptionSelector (copy), View (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy)
	local onOptionSelected = t1.onOptionSelected
	local options = t1.options
	local v22 = (t1.selectionMode or "single") == "multi"
	local selectedOptionId = t1.selectedOptionId
	local onConfirm = t1.onConfirm
	local v25 = v22 and onConfirm ~= nil
	local v26 = if v25 or selectedOptionId == nil then nil else if typeof(selectedOptionId) ~= "string" then if typeof(selectedOptionId) ~= "table" then nil else selectedOptionId[1] else selectedOptionId
	local t2 = {}
	local g38 = nil
	local v35 = nil

	for v28, v29 in options do
		if v26 == nil or v26 == v29.id then
			local id = v29.id
			local createElement = React.createElement
			local v32 = OptionSelector
			local t3 = {
				LayoutOrder = v28,
				title = v29.title,
				description = v29.description
			}
			local id2 = v29.id

			if typeof(selectedOptionId) == "string" then
				v35 = selectedOptionId == id2
			elseif typeof(selectedOptionId) ~= "table" then
				v35 = false
			else
				for _, v37 in selectedOptionId do
					if v37 == id2 then
						v35 = true
						g38 = true
					end

					if g38 then
						break
					end
				end

				if not g38 then
					v35 = false
				end
			end

			g38 = false
			t3.isSelected = v35
			t3.selectionStyle = v25 and "intermediate" or "committed"
			t3.testId = `AnswerStack.Option.{ v29.id }`

			function t3.onActivated() -- line: 88
				-- upvalues: onOptionSelected (copy), v29 (copy)
				onOptionSelected(v29)
			end

			t2[id] = createElement(v32, t3)
		end
	end

	local t4 = {
		Options = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-medium size-full-0 auto-y"
		}, t2)
	}

	if v25 and onConfirm ~= nil then
		local v40 = t1.isConfirmDisabled == true

		t4.Confirm = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right size-full-0 auto-y"
		}, {
			Button = React.createElement(Button, {
				text = if not v40 then t1.confirmLabel or LocalizationStrings.ANSWER_STACK_SUBMIT else LocalizationStrings.ANSWER_STACK_SELECT_AN_OPTION,
				size = InputSize.Medium,
				variant = ButtonVariant.Standard,
				isDisabled = v40,
				onActivated = onConfirm,
				testId = `{ t1.testId or "AnswerStack" }.Confirm`
			})
		})
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-top-small",
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "AnswerStack"
	}, t4)
end

return AnswerStack
