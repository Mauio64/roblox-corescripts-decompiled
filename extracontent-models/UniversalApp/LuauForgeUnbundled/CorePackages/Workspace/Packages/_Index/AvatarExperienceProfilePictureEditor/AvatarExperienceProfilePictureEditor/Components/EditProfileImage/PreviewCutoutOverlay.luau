local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")

local useTokens = Foundation.Hooks.useTokens

local function createCompositionGridLine(props)
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

local function buildCompositionGridChildren(p2, color3, transparency)
	local vector2 = Vector2.new(0.5, 0)
	local vector2_2 = Vector2.new(0, 0.5)
	local udim = UDim2.new(0, p2, 1, 0)
	local udim2 = UDim2.new(1, 0, 0, p2)

	local v5 = {
		size = udim,
		position = UDim2.fromScale(1 / 3, 0),
		anchorPoint = vector2,
		color = color3,
		transparency = transparency
	}
	local children = {
		VerticalLine1 = React.createElement("Frame", {
			Size = v5.size,
			Position = v5.position,
			AnchorPoint = v5.anchorPoint,
			BackgroundColor3 = v5.color,
			BackgroundTransparency = v5.transparency,
			BorderSizePixel = 0,
			Active = false
		}),
		VerticalLine2 = 0,
		HorizontalLine1 = 0,
		HorizontalLine2 = 0
	}

	local v6 = {
		size = udim,
		position = UDim2.fromScale(2 / 3, 0),
		anchorPoint = vector2,
		color = color3,
		transparency = transparency
	}
	children.VerticalLine2 = React.createElement("Frame", {
		Size = v6.size,
		Position = v6.position,
		AnchorPoint = v6.anchorPoint,
		BackgroundColor3 = v6.color,
		BackgroundTransparency = v6.transparency,
		BorderSizePixel = 0,
		Active = false
	})

	local v7 = {
		size = udim2,
		position = UDim2.fromScale(0, 1 / 3),
		anchorPoint = vector2_2,
		color = color3,
		transparency = transparency
	}
	children.HorizontalLine1 = React.createElement("Frame", {
		Size = v7.size,
		Position = v7.position,
		AnchorPoint = v7.anchorPoint,
		BackgroundColor3 = v7.color,
		BackgroundTransparency = v7.transparency,
		BorderSizePixel = 0,
		Active = false
	})

	local v8 = {
		size = udim2,
		position = UDim2.fromScale(0, 2 / 3),
		anchorPoint = vector2_2,
		color = color3,
		transparency = transparency
	}
	children.HorizontalLine2 = React.createElement("Frame", {
		Size = v8.size,
		Position = v8.position,
		AnchorPoint = v8.anchorPoint,
		BackgroundColor3 = v8.color,
		BackgroundTransparency = v8.transparency,
		BorderSizePixel = 0,
		Active = false
	})
	return children
end

local function PreviewCutoutOverlay(props)
	local v5 = useTokens()
	local v6 = math.max(0, (math.floor((props.width - props.cutoutSize) / 2 + 0.5)))
	local v7 = math.max(0, props.height - props.cutoutTopOffset - props.cutoutSize)
	local overMedia_100 = v5.Color.OverMedia.OverMedia_100
	local color3 = overMedia_100.Color3
	local transparency = overMedia_100.Transparency or 0.35
	local emphasis = v5.Color.Stroke.Emphasis
	local color3_2 = emphasis.Color3
	local transparency2 = emphasis.Transparency or 0.84
	local v8 = math.max(1, (math.floor(v5.Stroke.Standard + 0.5)))
	local v9 = math.floor(props.cutoutSize * Constants.CircleCutoutHoleDiameterFraction + 0.5)
	local v10 = math.max(0, (math.floor((props.cutoutSize - v9) / 2 + 0.5)))
	local v11 = v6 + v10
	local v12 = props.cutoutTopOffset + v10
	local v13 = v6 + props.cutoutSize * 0.5
	local v14 = props.cutoutTopOffset + props.cutoutSize * 0.5
	local v15 = math.max(1, v9 - v8)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v17 = {
		DimTop = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, props.cutoutTopOffset),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		DimLeft = React.createElement("Frame", {
			Size = UDim2.fromOffset(v6, props.cutoutSize),
			Position = UDim2.fromOffset(0, props.cutoutTopOffset),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		DimRight = React.createElement("Frame", {
			Size = UDim2.fromOffset(v6, props.cutoutSize),
			Position = UDim2.fromOffset(v6 + props.cutoutSize, props.cutoutTopOffset),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		DimBottom = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v7),
			Position = UDim2.fromOffset(0, props.cutoutTopOffset + props.cutoutSize),
			BackgroundColor3 = color3,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 2
		}),
		CompositionGrid = React.createElement("Frame", {
			Size = UDim2.fromOffset(v9, v9),
			Position = UDim2.fromOffset(v11, v12),
			BackgroundTransparency = 1,
			Active = false,
			ZIndex = 2
		}, buildCompositionGridChildren(v8, color3_2, transparency2)),
		Cutout = React.createElement("ImageLabel", {
			Image = Constants.CircleCutoutAsset,
			ImageColor3 = color3,
			ImageTransparency = transparency,
			Size = UDim2.fromOffset(props.cutoutSize, props.cutoutSize),
			Position = UDim2.fromOffset(v6, props.cutoutTopOffset),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 3
		}),
		CutoutBorder = React.createElement("Frame", {
			Size = UDim2.fromOffset(v15, v15),
			Position = UDim2.fromOffset(v13, v14),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 4
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			UIStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = color3_2,
				Transparency = transparency2,
				Thickness = v8
			})
		}),
		ProfileFrame = 0
	}

	local v18 = if props.frameImage then React.createElement("ImageLabel", {
		Image = props.frameImage,
		Size = UDim2.fromOffset(v9, v9),
		Position = UDim2.fromOffset(v13, v14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Fit,
		Active = false,
		ZIndex = 5
	}) else nil
	v17.ProfileFrame = v18
	return createElement(fragment, nil, v17)
end

return PreviewCutoutOverlay
