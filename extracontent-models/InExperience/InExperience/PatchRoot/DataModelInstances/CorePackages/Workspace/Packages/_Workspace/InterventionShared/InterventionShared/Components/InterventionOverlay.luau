local parent = script:FindFirstAncestor("InterventionShared").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local function InterventionOverlay(p)
	local v = useStyle()
	return React.createElement("TextButton", {
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v.Tokens.Color.Common.Scrim.Color3,
		BackgroundTransparency = v.Tokens.Color.Common.Scrim.Transparency,
		BorderSizePixel = 0,
		Text = "",
		[React.Event.Activated] = p.onDismiss
	}, p.children)
end

return InterventionOverlay
