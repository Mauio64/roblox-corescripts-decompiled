local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)

require(script.Parent.FeedbackAction)

local IconButton = Foundation.IconButton
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize

local function UserFeedback(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), IconVariant (copy), IconButton (copy), InputSize (copy), ButtonVariant (copy), View (copy)
	local v11 = t1.testId or "user-feedback"
	local onActivated = t1.onActivated
	local v13, v14 = React.useState(nil)
	local t2 = {}

	for v16, v17 in t1.icons do
		local v18 = if v13 ~= v17.action then v17.iconName else {
			name = v17.iconName,
			variant = IconVariant.Filled
		}

		t2[`{ v17.iconName }-{ v16 }`] = React.createElement(IconButton, {
			LayoutOrder = v16,
			icon = v18,
			isDisabled = v17.isDisabled,
			onActivated = function() -- line: 49
				-- upvalues: v13 (copy), v17 (copy), v14 (copy), onActivated (copy)
				if v13 == v17.action and v17.allowRepeatedActivation ~= true then
					return
				end

				v14(v17.action)
				onActivated(v17)
			end,
			size = InputSize.Small,
			variant = ButtonVariant.Utility,
			testId = `{ v11 }-{ v17.iconName }`
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
