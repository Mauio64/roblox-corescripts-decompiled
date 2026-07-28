local Parent = script:FindFirstAncestor("InterventionShared").Parent
local React = require(Parent.React)
local useStyle = require(Parent.UIBlox).Core.Style.useStyle

local function InterventionOverlay(t1: {[any]: any}) -- line: 13
	-- upvalues: useStyle (copy), React (copy)
	local v6 = useStyle()

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v6.Tokens.Color.Common.Scrim.Color3,
		BackgroundTransparency = v6.Tokens.Color.Common.Scrim.Transparency,
		BorderSizePixel = 0,
		Text = "",
		[React.Event.Activated] = t1.onDismiss
	}, t1.children)
end

return InterventionOverlay
