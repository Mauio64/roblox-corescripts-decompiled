local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local FoundationImages = require(FoundationParent.FoundationImages)
local React = require(FoundationParent.React)
local Images = FoundationImages.Images
local CursorComponent = require(script.Parent.Parent.CursorComponent)
local CursorType = require(Foundation.Enums.CursorType)

require(Foundation.Enums.ColorMode)

local useTokens = require(Foundation.Providers.Style.useTokens)
local Components = script.Parent.Parent.Parent.Parent.Components
local getScaledSlice = require(Components.Image.ImageSet.getScaledSlice)
local t1 = {
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
		Padding = 50,
		SliceCenter = Rect.new(3.5, 3.5, 3.5, 3.5),
		InsetAdjustment = Vector2.new(2, 2)
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
		Offset = 11,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 11)
	},
	[CursorType.RoundedRect] = {
		Tag = "RoundedImage",
		Offset = 9,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 8)
	},
	[CursorType.RoundedRectNoInset] = {
		Tag = "RoundedImage",
		Offset = 0,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 8)
	},
	[CursorType.RoundedSlot] = {
		Tag = "RoundedImage",
		Offset = 0,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 7)
	},
	[CursorType.SkinToneCircle] = {
		Tag = "RoundedImage",
		Offset = 0,
		BorderWidth = 3,
		CornerRadius = UDim.new(0.5, 0)
	},
	[CursorType.SmallPill] = {
		Tag = "RoundedImage",
		Offset = 0,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 15)
	},
	[CursorType.LargePill] = {
		Tag = "RoundedImage",
		Offset = 0,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 26)
	},
	[CursorType.Square] = {
		Tag = "RoundedImage",
		Offset = 2,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 0)
	},
	[CursorType.Toggle] = {
		Tag = "RoundedImage",
		Offset = 0,
		BorderWidth = 3,
		CornerRadius = UDim.new(0, 13)
	}
}

return (React.forwardRef(function(t2: {[any]: any}, p1) -- line: 140
	-- upvalues: useTokens (copy), CursorType (copy), React (copy), t1 (copy), Images (copy), getScaledSlice (copy), CursorComponent (copy)
	local v14 = useTokens()
	local colorMode = t2.colorMode

	if t2.cursorType == CursorType.NavHighlight then
		return React.createElement("Frame", {
			BorderSizePixel = 1,
			BackgroundTransparency = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -3),
			Size = UDim2.new(1, 0, 0, 3),
			BackgroundColor3 = v14[colorMode].Selection.Start.Color3,
			BorderColor3 = v14[colorMode].Selection.Start.Color3,
			ref = p1
		})
	end

	if t2.cursorType == CursorType.Invisible then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = p1
		})
	end

	local v16 = t1[t2.cursorType]

	if v16.Tag == "FixedSizeImage" then
		local uDim2 = UDim2.fromOffset(v16.Size, v16.Size)
		local uDim2_2 = UDim2.new(0.5, -uDim2.X.Offset / 2, 0.5, -uDim2.Y.Offset / 2)

		return React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Images[v16.Image].Image,
			ImageRectOffset = Images[v16.Image].ImageRectOffset,
			ImageRectSize = Images[v16.Image].ImageRectSize,
			Size = uDim2,
			Position = uDim2_2,
			ImageColor3 = v14[colorMode].Selection.Start.Color3,
			ImageTransparency = v14[colorMode].Selection.Start.Transparency,
			ref = p1
		})
	end

	if v16.Tag == "SlicedImage" then
		local InsetAdjustment = v16.InsetAdjustment
		local uDim2 = UDim2.new(1, InsetAdjustment.X * 2, 1, InsetAdjustment.Y * 2)
		local v21 = getScaledSlice(v16.SliceCenter)
		local v22 = if not v16.Padding then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v16.Padding),
			PaddingBottom = UDim.new(0, v16.Padding),
			PaddingLeft = UDim.new(0, v16.Padding),
			PaddingRight = UDim.new(0, v16.Padding)
		})

		return React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Images[v16.Image].Image,
			ImageRectOffset = Images[v16.Image].ImageRectOffset,
			ImageRectSize = Images[v16.Image].ImageRectSize,
			SliceCenter = v21.center,
			SliceScale = v21.scale,
			ScaleType = Enum.ScaleType.Slice,
			Size = uDim2,
			Position = UDim2.fromOffset(-InsetAdjustment.X, -InsetAdjustment.Y),
			ImageColor3 = v14[colorMode].Selection.Start.Color3,
			ImageTransparency = v14[colorMode].Selection.Start.Transparency,
			ref = p1
		}, {
			Padding = v22
		})
	end

	if v16.Tag == "RoundedImage" then
		return React.createElement(CursorComponent, {
			isVisible = t2.isVisible,
			cornerRadius = v16.CornerRadius,
			offset = v16.Offset - v16.BorderWidth,
			borderWidth = v16.BorderWidth,
			colorMode = t2.colorMode,
			ref = p1
		})
	end

	return nil
end))
