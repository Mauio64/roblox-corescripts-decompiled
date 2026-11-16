local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local generateColorSequence = require(script.Parent.Utils.generateColorSequence)

local defineFastFlag = game:DefineFastFlag("AXColorGradientRenderFlatWithJustOneColor", false)

local function ColorGradientCircle(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 0
	}

	local v3 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		UIGradient = 0,
		UIStroke = 0
	}
	local uiGradient

	if defineFastFlag and #props.Colors == 1 then
		uiGradient = React.createElement(Foundation.View, {
			tag = "size-full-full radius-circle",
			backgroundStyle = { Color3 = props.Colors[1], Transparency = 0 }
		})
	else
		uiGradient = React.createElement("UIGradient", {
			Rotation = props.Rotation or 45,
			Color = generateColorSequence(props.Colors),
			Transparency = props.Transparency or NumberSequence.new(0),
			Offset = props.Offset or Vector2.new(0, 0)
		})
	end

	v3.UIGradient = uiGradient
	local uiStroke

	if props.hasBorder then
		uiStroke = React.createElement("UIStroke", {
			Thickness = 2,
			Color = v.Color.System.Contrast.Color3
		})
	end

	v3.UIStroke = uiStroke
	return createElement("Frame", v2, v3)
end

return ColorGradientCircle
