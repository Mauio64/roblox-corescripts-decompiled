local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Constants = require(AvatarExperienceProfilePictureEditor.Constants)

local useTokens = Foundation.Hooks.useTokens

local function createCompositionGridLine(props) -- 4 equivalent calls inferred from this helper
	return React.createElement("Frame", {
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		BackgroundColor3 = props.color,
		BackgroundTransparency = props.transparency,
		BorderSizePixel = 0,
		Active = false
	})
end

local function buildCompositionGridChildren(p: number, color3: Color3, transparency: number)
	local vector2 = Vector2.new(0.5, 0)
	local vector2_2 = Vector2.new(0, 0.5)
	local udim = UDim2.new(0, p, 1, 0)
	local udim2 = UDim2.new(1, 0, 0, p)

	return {
		VerticalLine1 = createCompositionGridLine({ -- inferred equivalent call
			size = udim,
			position = UDim2.fromScale(1 / 3, 0),
			anchorPoint = vector2,
			color = color3,
			transparency = transparency
		}),
		VerticalLine2 = createCompositionGridLine({ -- inferred equivalent call
			size = udim,
			position = UDim2.fromScale(2 / 3, 0),
			anchorPoint = vector2,
			color = color3,
			transparency = transparency
		}),
		HorizontalLine1 = createCompositionGridLine({ -- inferred equivalent call
			size = udim2,
			position = UDim2.fromScale(0, 1 / 3),
			anchorPoint = vector2_2,
			color = color3,
			transparency = transparency
		}),
		HorizontalLine2 = createCompositionGridLine({ -- inferred equivalent call
			size = udim2,
			position = UDim2.fromScale(0, 2 / 3),
			anchorPoint = vector2_2,
			color = color3,
			transparency = transparency
		})
	}
end

local function PreviewCutoutOverlay(props)
	local v = useTokens()
	local v2 = math.max(0, (math.floor((props.width - props.cutoutSize) / 2 + 0.5)))
	local v3 = math.max(0, props.height - props.cutoutTopOffset - props.cutoutSize)
	local overMedia_100 = v.Color.OverMedia.OverMedia_100
	local color3 = overMedia_100.Color3
	local transparency = overMedia_100.Transparency or 0.35
	local emphasis = v.Color.Stroke.Emphasis
	local color3_2 = emphasis.Color3
	local transparency2 = emphasis.Transparency or 0.84
	local thickness = math.max(1, (math.floor(v.Stroke.Standard + 0.5)))
	local v4 = math.floor(props.cutoutSize * Constants.CircleCutoutHoleDiameterFraction + 0.5)
	local v5 = math.max(0, (math.floor((props.cutoutSize - v4) / 2 + 0.5)))
	local v6 = v2 + v5
	local v7 = props.cutoutTopOffset + v5
	local v8 = v2 + props.cutoutSize * 0.5
	local v9 = props.cutoutTopOffset + props.cutoutSize * 0.5
	local v10 = math.max(1, v4 - thickness)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v11 = {
		DimTop = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, props.cutoutTopOffset),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		DimLeft = React.createElement("Frame", {
			Size = UDim2.fromOffset(v2, props.cutoutSize),
			Position = UDim2.fromOffset(0, props.cutoutTopOffset),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		DimRight = React.createElement("Frame", {
			Size = UDim2.fromOffset(v2, props.cutoutSize),
			Position = UDim2.fromOffset(v2 + props.cutoutSize, props.cutoutTopOffset),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		DimBottom = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v3),
			Position = UDim2.fromOffset(0, props.cutoutTopOffset + props.cutoutSize),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		CompositionGrid = React.createElement("Frame", {
			Size = UDim2.fromOffset(v4, v4),
			Position = UDim2.fromOffset(v6, v7),
			BackgroundTransparency = 1,
			Active = false,
			ZIndex = 2
		}, buildCompositionGridChildren(thickness, color3_2, transparency2)),
		Cutout = React.createElement("ImageLabel", {
			Image = Constants.CircleCutoutAsset,
			ImageColor3 = color3,
			ImageTransparency = transparency,
			Size = UDim2.fromOffset(props.cutoutSize, props.cutoutSize),
			Position = UDim2.fromOffset(v2, props.cutoutTopOffset),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 3
		}),
		CutoutBorder = React.createElement("Frame", {
			Size = UDim2.fromOffset(v10, v10),
			Position = UDim2.fromOffset(v8, v9),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 4
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
			UIStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = color3_2,
				Transparency = transparency2,
				Thickness = thickness
			})
		}),
		ProfileFrame = 0
	}
	local profileFrame

	if props.frameImage then
		profileFrame = React.createElement("ImageLabel", {
			Image = props.frameImage,
			Size = UDim2.fromOffset(v4, v4),
			Position = UDim2.fromOffset(v8, v9),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Fit,
			Active = false,
			ZIndex = 5
		})
	end

	v11.ProfileFrame = profileFrame
	return createElement(fragment, nil, v11)
end

return PreviewCutoutOverlay
