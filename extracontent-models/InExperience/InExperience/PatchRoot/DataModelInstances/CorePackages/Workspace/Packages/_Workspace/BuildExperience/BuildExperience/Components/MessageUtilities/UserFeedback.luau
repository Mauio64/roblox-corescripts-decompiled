local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)

require(script.Parent.FeedbackAction)

local IconButton = Foundation.IconButton
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize

local function UserFeedback(t1: {[any]: any}) -- line: 33
	-- upvalues: IconVariant (copy), React (copy), IconButton (copy), InputSize (copy), ButtonVariant (copy), View (copy)
	local v11 = t1.testId or "user-feedback"
	local onActivated = t1.onActivated
	local selectedAction = t1.selectedAction
	local t2 = {}

	for v15, v16 in t1.icons do
		local v17 = if selectedAction ~= v16.action then v16.iconName else {
			name = v16.iconName,
			variant = IconVariant.Filled
		}

		t2[`{ v16.iconName }-{ v15 }`] = React.createElement(IconButton, {
			LayoutOrder = v15,
			icon = v17,
			isDisabled = v16.isDisabled,
			onActivated = function() -- line: 49
				-- upvalues: selectedAction (copy), v16 (copy), onActivated (copy)
				if selectedAction == v16.action and v16.allowRepeatedActivation ~= true then
					return
				end

				onActivated(v16)
			end,
			size = InputSize.Small,
			variant = ButtonVariant.Utility,
			testId = `{ v11 }-{ v16.iconName }`
		})
	end

	return React.createElement(View, {
		tag = "row align-y-center size-full-0 auto-y padding-top-small",
		LayoutOrder = t1.layoutOrder,
		testId = v11
	}, {
		Actions = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row wrap align-x-right align-y-center gap-small auto-xy"
		}, t2)
	})
end

return UserFeedback
