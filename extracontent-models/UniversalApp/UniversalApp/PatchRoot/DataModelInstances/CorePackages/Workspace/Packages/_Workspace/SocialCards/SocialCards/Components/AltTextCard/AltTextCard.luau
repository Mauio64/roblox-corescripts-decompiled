local Parent = script:FindFirstAncestor("SocialCards").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useTokens = Foundation.Hooks.useTokens

local function AltTextCard(t1: {[any]: any}) -- line: 13
	-- upvalues: useTokens (copy), React (copy), Foundation (copy)
	local v7 = useTokens()

	return React.createElement(Foundation.Text, {
		TextWrapped = true,
		AutomaticSize = Enum.AutomaticSize.XY,
		fontStyle = {
			Font = v7.Typography.BodyMedium.Font,
			FontSize = v7.Typography.BodyMedium.FontSize
		},
		padding = {
			bottom = UDim.new(0, v7.Padding.Medium),
			left = UDim.new(0, v7.Padding.Medium),
			right = UDim.new(0, v7.Padding.Medium),
			top = UDim.new(0, v7.Padding.Medium)
		},
		Text = t1.altText,
		textStyle = {
			Color3 = v7.Color.Content.Muted.Color3,
			Transparency = v7.Color.Content.Muted.Transparency
		}
	})
end

return AltTextCard
