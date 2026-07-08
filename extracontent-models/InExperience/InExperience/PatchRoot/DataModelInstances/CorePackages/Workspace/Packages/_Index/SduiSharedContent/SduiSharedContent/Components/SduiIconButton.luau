local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local IconButton = Foundation.IconButton

local function v5() -- line: 10
end
local function SduiIconButton(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), IconButton (copy), v5 (copy)
	if not t1.icon or not t1.icon.name then
		return nil
	end

	return React.createElement(IconButton, {
		icon = t1.icon,
		isCircular = t1.isCircular,
		width = t1.width,
		size = t1.size,
		variant = t1.variant,
		onActivated = t1.onActivated or v5,
		LayoutOrder = t1.layoutOrder,
		AnchorPoint = t1.anchorPoint,
		Position = t1.position,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		isDisabled = t1.isDisabled,
		testId = t1.testId
	})
end

return React.memo(SduiIconButton)
