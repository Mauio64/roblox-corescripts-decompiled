local ParentParent = script:FindFirstAncestor("TiltLoadingScreen").Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local function VerifiedBadge(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), View (copy), Icon (copy), Enums (copy)
	return React.createElement(View, {
		tag = "auto-xy",
		testId = "tilt-verified-badge",
		LayoutOrder = t1.LayoutOrder
	}, {
		Backplate = React.createElement(Icon, {
			name = "verified-backplate",
			ZIndex = 1,
			variant = Enums.IconVariant.Filled,
			size = Enums.IconSize.Small,
			style = t1.backplateStyle
		}),
		Check = React.createElement(Icon, {
			name = "verified-check",
			ZIndex = 2,
			variant = Enums.IconVariant.Filled,
			size = Enums.IconSize.Small,
			style = t1.checkStyle
		})
	})
end

return VerifiedBadge
