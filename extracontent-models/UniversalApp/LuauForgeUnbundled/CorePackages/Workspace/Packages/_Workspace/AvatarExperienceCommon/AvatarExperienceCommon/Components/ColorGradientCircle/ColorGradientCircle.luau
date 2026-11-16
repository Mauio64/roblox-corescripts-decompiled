local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens
local generateColorSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/ColorGradientCircle/Utils/generateColorSequence")

local defineFastFlag = game:DefineFastFlag("AXColorGradientRenderFlatWithJustOneColor", false)

local function ColorGradientCircle(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 0
	}

	local v8 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		UIGradient = 0,
		UIStroke = 0
	}

	local v9 = if defineFastFlag and #props.Colors == 1 then React.createElement(Foundation.View, {
		tag = "size-full-full radius-circle",
		backgroundStyle = { Color3 = props.Colors[1], Transparency = 0 }
	}) else React.createElement("UIGradient", {
		Rotation = props.Rotation or 45,
		Color = generateColorSequence(props.Colors),
		Transparency = props.Transparency or NumberSequence.new(0),
		Offset = props.Offset or Vector2.new(0, 0)
	})
	v8.UIGradient = v9

	local v10 = if props.hasBorder then React.createElement("UIStroke", {
		Thickness = 2,
		Color = v5.Color.System.Contrast.Color3
	}) else nil
	v8.UIStroke = v10
	return createElement("Frame", v7, v8)
end

return ColorGradientCircle
