local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local useStyle = require(ParentParentParent.Core.Style.useStyle)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local Images = require(ParentParentParentParent.UIBlox.App.ImageSet.Images)

require(ParentParent.ImageSet.ImagesTypes)
require(ParentParentParent.App.Style.StyleTypes)

local function renderHalfCircle(t1: {[any]: any}, p1) -- line: 38
	-- upvalues: React (copy), ImageSetComponent (copy)
	local layoutOrder = t1.layoutOrder
	local isLeft = t1.isLeft
	local rotation = t1.rotation
	local progressImage = t1.progressImage
	local IconDefault = p1.Theme.IconDefault
	local Divider = p1.Theme.Divider

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = layoutOrder,
		Size = UDim2.fromScale(0.5, 1)
	}, {
		CircleImage = React.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(2, 1),
			AnchorPoint = if not isLeft then Vector2.new(0.5, 0) else nil,
			Image = progressImage
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = rotation,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, IconDefault.Color),
					ColorSequenceKeypoint.new(0.499, IconDefault.Color),
					ColorSequenceKeypoint.new(0.5, Divider.Color),
					ColorSequenceKeypoint.new(1, Divider.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, IconDefault.Transparency),
					NumberSequenceKeypoint.new(0.499, IconDefault.Transparency),
					NumberSequenceKeypoint.new(0.5, Divider.Transparency),
					NumberSequenceKeypoint.new(1, Divider.Transparency)
				})
			})
		})
	})
end
local function ProgressIcon(t2: {[any]: any}) -- line: 79
	-- upvalues: Images (copy), useStyle (copy), React (copy), renderHalfCircle (copy), ImageSetComponent (copy)
	local progress = t2.progress
	local isHolding = t2.isHolding
	local v21 = if not isHolding then t2.icon else t2.iconHolding
	local v22 = if not isHolding then Images["icons/controls/keys/hold_button_assets/hold_Unpressed_RadialFill"] else Images["icons/controls/keys/hold_button_assets/hold_Pressed_RadialFill"]
	local v23 = if not isHolding then Images["icons/controls/keys/hold_button_assets/hold_Unpressed_Arrow"] else Images["icons/controls/keys/hold_button_assets/hold_Pressed_Arrow"]
	local v24 = useStyle()
	local v25 = React.useMemo(function() -- line: 87
		-- upvalues: progress (copy)
		return progress:map(function(p2) -- line: 88
			return (math.clamp((p2 or 0) * 314 + 23, 180, 337))
		end)
	end, { progress })
	local v26 = React.useMemo(function() -- line: 94
		-- upvalues: progress (copy)
		return progress:map(function(p3) -- line: 95
			return (math.clamp((p3 or 0) * 314 + 23, 23, 180))
		end)
	end, { progress })
	local v27 = React.useMemo(function() -- line: 101
		-- upvalues: progress (copy)
		return progress:map(function(n1: number?) -- line: 102
			if n1 then
				return (math.clamp(0.8 - n1 * 0.8, 0, 0.8))
			end

			return 0
		end)
	end, { progress })

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Progress = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Left = renderHalfCircle({
				layoutOrder = 1,
				isLeft = true,
				progressImage = v22,
				rotation = v25
			}, v24),
			Right = renderHalfCircle({
				layoutOrder = 2,
				progressImage = v22,
				rotation = v26
			}, v24)
		}),
		Icon = React.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = v21,
			ImageColor3 = v24.Theme.IconEmphasis.Color,
			ImageTransparency = v27
		}),
		Arrow = React.createElement(ImageSetComponent.Label, {
			ImageTransparency = 0,
			BackgroundTransparency = 1,
			ZIndex = 3,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Image = v23,
			ImageColor3 = v24.Theme.IconEmphasis.Color
		})
	})
end

return ProgressIcon
