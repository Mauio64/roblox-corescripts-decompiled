local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local generateColorSequence = require(script.Parent.Utils.generateColorSequence)
local v6 = game:DefineFastFlag("AXColorGradientRenderFlatWithJustOneColor", false)

local function ColorGradientCircle(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), React (copy), v6 (copy), Foundation (copy), generateColorSequence (copy)
	local v9 = useTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = t1.Size,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		UIGradient = if not v6 or #t1.Colors ~= 1 then React.createElement("UIGradient", {
			Rotation = t1.Rotation or 45,
			Color = generateColorSequence(t1.Colors),
			Transparency = t1.Transparency or NumberSequence.new(0),
			Offset = t1.Offset or Vector2.new(0, 0)
		}) else React.createElement(Foundation.View, {
			tag = "size-full-full radius-circle",
			backgroundStyle = {
				Transparency = 0,
				Color3 = t1.Colors[1]
			}
		}),
		UIStroke = if not t1.hasBorder then nil else React.createElement("UIStroke", {
			Thickness = 2,
			Color = v9.Color.System.Contrast.Color3
		})
	})
end

return ColorGradientCircle
