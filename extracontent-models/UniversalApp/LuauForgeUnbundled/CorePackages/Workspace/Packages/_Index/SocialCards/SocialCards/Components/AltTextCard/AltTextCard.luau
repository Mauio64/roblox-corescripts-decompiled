local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")

local useTokens = Foundation.Hooks.useTokens

local function AltTextCard(p2)
	local v5 = useTokens()

	return React.createElement(Foundation.Text, {
		AutomaticSize = Enum.AutomaticSize.XY,
		fontStyle = {
			Font = v5.Typography.BodyMedium.Font,
			FontSize = v5.Typography.BodyMedium.FontSize
		},
		padding = {
			bottom = UDim.new(0, v5.Padding.Medium),
			left = UDim.new(0, v5.Padding.Medium),
			right = UDim.new(0, v5.Padding.Medium),
			top = UDim.new(0, v5.Padding.Medium)
		},
		Text = p2.altText,
		textStyle = {
			Color3 = v5.Color.Content.Muted.Color3,
			Transparency = v5.Color.Content.Muted.Transparency
		},
		TextWrapped = true
	})
end

return AltTextCard
