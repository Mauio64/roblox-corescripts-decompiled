local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
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

	for _, v15 in p1 do
		if v15 == s1 then
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
	-- upvalues: React (copy), OptionSelector (copy), View (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local onOptionSelected = t1.onOptionSelected
	local options = t1.options
	local v20 = (t1.selectionMode or "single") == "multi"
	local selectedOptionId = t1.selectedOptionId
	local onConfirm = t1.onConfirm
	local v23 = v20 and onConfirm ~= nil
	local v24 = if v23 or selectedOptionId == nil then nil else if typeof(selectedOptionId) ~= "string" then if typeof(selectedOptionId) ~= "table" then nil else selectedOptionId[1] else selectedOptionId
	local t2 = {}
	local g36 = nil
	local v33 = nil

	for v26, v27 in options do
		if v24 == nil or v24 == v27.id then
			local id = v27.id
			local createElement = React.createElement
			local v30 = OptionSelector
			local t3 = {
				LayoutOrder = v26,
				title = v27.title,
				description = v27.description
			}
			local id2 = v27.id

			if typeof(selectedOptionId) == "string" then
				v33 = selectedOptionId == id2
			elseif typeof(selectedOptionId) ~= "table" then
				v33 = false
			else
				for _, v35 in selectedOptionId do
					if v35 == id2 then
						v33 = true
						g36 = true
					end

					if g36 then
						break
					end
				end

				if not g36 then
					v33 = false
				end
			end

			g36 = false
			t3.isSelected = v33
			t3.selectionStyle = v23 and "intermediate" or "committed"
			t3.testId = `AnswerStack.Option.{ v27.id }`

			function t3.onActivated() -- line: 88
				-- upvalues: onOptionSelected (copy), v27 (copy)
				onOptionSelected(v27)
			end

			t2[id] = createElement(v30, t3)
		end
	end

	local t4 = {
		Options = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-medium size-full-0 auto-y"
		}, t2)
	}

	if v23 and onConfirm ~= nil then
		local v38 = t1.isConfirmDisabled == true

		t4.Confirm = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right size-full-0 auto-y"
		}, {
			Button = React.createElement(Button, {
				text = if not v38 then t1.confirmLabel or "Submit" else "Select an option",
				size = InputSize.Medium,
				variant = ButtonVariant.Standard,
				isDisabled = v38,
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
