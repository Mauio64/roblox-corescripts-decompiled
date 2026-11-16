local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local FoundationImages = require(parent.FoundationImages)
local React = require(parent.React)

local Images = FoundationImages.Images
local CursorComponent = require(script.Parent.Parent.CursorComponent)
local CursorType = require(Foundation.Enums.CursorType)

require(Foundation.Enums.ColorNamespace)

local useTokens = require(Foundation.Providers.Style.useTokens)

local Components = script.Parent.Parent.Parent.Parent.Components
local getScaledSlice = require(Components.Image.ImageSet.getScaledSlice)

local v = {
	[CursorType.BulletUp] = {
		Tag = "SlicedImage",
		Image = "component_assets/bulletUp_17_stroke_3",
		SliceCenter = Rect.new(8, 8, 9, 9),
		InsetAdjustment = Vector2.new(2, 2)
	},
	[CursorType.BulletDown] = {
		Tag = "SlicedImage",
		Image = "component_assets/bulletDown_17_stroke_3",
		SliceCenter = Rect.new(8, 8, 9, 9),
		InsetAdjustment = Vector2.new(2, 2)
	},
	[CursorType.InputFields] = {
		Tag = "SlicedImage",
		Image = "component_assets/circle_22_stroke_3",
		SliceCenter = Rect.new(11, 11, 12, 12),
		InsetAdjustment = Vector2.new(7, 0)
	},
	[CursorType.SelectionCell] = {
		Tag = "SlicedImage",
		Image = "component_assets/square_7_stroke_3",
		SliceCenter = Rect.new(3.5, 3.5, 3.5, 3.5),
		InsetAdjustment = Vector2.new(2, 2),
		Padding = 50
	},
	[CursorType.SelectedKnob] = {
		Tag = "FixedSizeImage",
		Image = "component_assets/circle_42_stroke_3",
		Size = 42
	},
	[CursorType.UnselectedKnob] = {
		Tag = "FixedSizeImage",
		Image = "component_assets/circle_52_stroke_3",
		Size = 52
	},
	[CursorType.InputButton] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 11),
		Offset = 11,
		BorderWidth = 3
	},
	[CursorType.RoundedRect] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 8),
		Offset = 9,
		BorderWidth = 3
	},
	[CursorType.RoundedRectNoInset] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 8),
		Offset = 0,
		BorderWidth = 3
	},
	[CursorType.RoundedSlot] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 7),
		Offset = 0,
		BorderWidth = 3
	},
	[CursorType.SkinToneCircle] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0.5, 0),
		Offset = 0,
		BorderWidth = 3
	},
	[CursorType.SmallPill] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 15),
		Offset = 0,
		BorderWidth = 3
	},
	[CursorType.LargePill] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 26),
		Offset = 0,
		BorderWidth = 3
	},
	[CursorType.Square] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 0),
		Offset = 2,
		BorderWidth = 3
	},
	[CursorType.Toggle] = {
		Tag = "RoundedImage",
		CornerRadius = UDim.new(0, 13),
		Offset = 0,
		BorderWidth = 3
	}
}

return (React.forwardRef(function(props, ref)
	local v2 = useTokens()
	local colorNamespace = props.colorNamespace

	if props.cursorType == CursorType.NavHighlight then
		return React.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -3),
			Size = UDim2.new(1, 0, 0, 3),
			BorderSizePixel = 1,
			BackgroundColor3 = v2[colorNamespace].Selection.Start.Color3,
			BackgroundTransparency = 0,
			BorderColor3 = v2[colorNamespace].Selection.Start.Color3,
			ref = ref
		})
	end

	if props.cursorType == CursorType.Invisible then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = ref
		})
	end

	local v3 = v[props.cursorType]

	if v3.Tag == "FixedSizeImage" then
		local udim = UDim2.fromOffset(v3.Size, v3.Size)
		local udim2 = UDim2.new(0.5, -udim.X.Offset / 2, 0.5, -udim.Y.Offset / 2)

		return React.createElement("ImageLabel", {
			Image = Images[v3.Image].Image,
			BackgroundTransparency = 1,
			ImageRectOffset = Images[v3.Image].ImageRectOffset,
			ImageRectSize = Images[v3.Image].ImageRectSize,
			Size = udim,
			Position = udim2,
			ImageColor3 = v2[colorNamespace].Selection.Start.Color3,
			ImageTransparency = v2[colorNamespace].Selection.Start.Transparency,
			ref = ref
		})
	elseif v3.Tag == "SlicedImage" then
		local insetAdjustment = v3.InsetAdjustment
		local udim = UDim2.new(1, insetAdjustment.X * 2, 1, insetAdjustment.Y * 2)
		local scaledSlice = getScaledSlice(v3.SliceCenter)
		local padding

		if v3.Padding then
			padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v3.Padding),
				PaddingBottom = UDim.new(0, v3.Padding),
				PaddingLeft = UDim.new(0, v3.Padding),
				PaddingRight = UDim.new(0, v3.Padding)
			})
		end

		return React.createElement("ImageLabel", {
			Image = Images[v3.Image].Image,
			BackgroundTransparency = 1,
			ImageRectOffset = Images[v3.Image].ImageRectOffset,
			ImageRectSize = Images[v3.Image].ImageRectSize,
			SliceCenter = scaledSlice.center,
			SliceScale = scaledSlice.scale,
			ScaleType = Enum.ScaleType.Slice,
			Size = udim,
			Position = UDim2.fromOffset(-insetAdjustment.X, -insetAdjustment.Y),
			ImageColor3 = v2[colorNamespace].Selection.Start.Color3,
			ImageTransparency = v2[colorNamespace].Selection.Start.Transparency,
			ref = ref
		}, { Padding = padding })
	elseif v3.Tag == "RoundedImage" then
		return React.createElement(CursorComponent, {
			isVisible = props.isVisible,
			cornerRadius = v3.CornerRadius,
			offset = v3.Offset - v3.BorderWidth,
			borderWidth = v3.BorderWidth,
			colorNamespace = props.colorNamespace,
			ref = ref
		})
	else
		return nil
	end
end))
