local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/UIBlox").Core.Style.useStyle

local function InterventionOverlay(p2)
	local v5 = useStyle()
	return React.createElement("TextButton", {
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v5.Tokens.Color.Common.Scrim.Color3,
		BackgroundTransparency = v5.Tokens.Color.Common.Scrim.Transparency,
		BorderSizePixel = 0,
		Text = "",
		[React.Event.Activated] = p2.onDismiss
	}, p2.children)
end

return InterventionOverlay
