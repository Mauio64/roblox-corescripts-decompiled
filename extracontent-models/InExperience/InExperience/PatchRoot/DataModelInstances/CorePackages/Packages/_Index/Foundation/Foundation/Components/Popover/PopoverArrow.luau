local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)

local function PopoverArrow(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		Rotation = 45,
		tag = "anchor-center-center",
		Size = UDim2.fromOffset(t1.size, t1.size),
		Position = t1.position,
		ZIndex = t1.ZIndex,
		backgroundStyle = t1.backgroundStyle,
		testId = t1.testId
	})
end

return PopoverArrow
