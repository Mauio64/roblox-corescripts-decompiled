local parent = script:FindFirstAncestor("SocialCards").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useTokens = Foundation.Hooks.useTokens

local function AltTextCard(p)
	local v = useTokens()

	return React.createElement(Foundation.Text, {
		AutomaticSize = Enum.AutomaticSize.XY,
		fontStyle = {
			Font = v.Typography.BodyMedium.Font,
			FontSize = v.Typography.BodyMedium.FontSize
		},
		padding = {
			bottom = UDim.new(0, v.Padding.Medium),
			left = UDim.new(0, v.Padding.Medium),
			right = UDim.new(0, v.Padding.Medium),
			top = UDim.new(0, v.Padding.Medium)
		},
		Text = p.altText,
		textStyle = {
			Color3 = v.Color.Content.Muted.Color3,
			Transparency = v.Color.Content.Muted.Transparency
		},
		TextWrapped = true
	})
end

return AltTextCard
