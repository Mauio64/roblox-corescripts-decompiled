local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local SystemBanner = require(Parent.Foundation).SystemBanner

local function SduiSystemBanner(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), SystemBanner (copy)
	return React.createElement(SystemBanner, {
		severity = t1.severity,
		variant = t1.variant,
		title = t1.title,
		description = t1.description,
		actions = t1.actions,
		onClose = t1.onClose,
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		testId = t1.testId
	})
end

return React.memo(SduiSystemBanner)
