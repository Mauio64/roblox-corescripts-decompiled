local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function AgentDetailMenu(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy)
	return React.createElement(IconButton, {
		isCircular = true,
		testId = "build-header-agent-detail-menu",
		LayoutOrder = t1.layoutOrder,
		icon = IconName.RectangleList,
		isDisabled = t1.isDisabled,
		onActivated = t1.onActivated,
		size = InputSize.Medium,
		variant = ButtonVariant.Utility
	})
end

return AgentDetailMenu
