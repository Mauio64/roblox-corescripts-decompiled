local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local OptionSelector = require(script.Parent.OptionSelector)
local View = Foundation.View

local function AnswerStack(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), OptionSelector (copy), View (copy)
	local onOptionSelected = t1.onOptionSelected
	local t2 = {}

	for v10, v11 in t1.options do
		if t1.selectedOptionId == nil or v11.id == t1.selectedOptionId then
			t2[v11.id] = React.createElement(OptionSelector, {
				LayoutOrder = v10,
				title = v11.title,
				description = v11.description,
				isSelected = v11.id == t1.selectedOptionId,
				testId = `AnswerStack.Option.{ v11.id }`,
				onActivated = function() -- line: 42
					-- upvalues: onOptionSelected (copy), v11 (copy)
					onOptionSelected(v11)
				end
			})
		end
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-top-small",
		LayoutOrder = t1.LayoutOrder,
		testId = t1.testId or "AnswerStack"
	}, t2)
end

return AnswerStack
