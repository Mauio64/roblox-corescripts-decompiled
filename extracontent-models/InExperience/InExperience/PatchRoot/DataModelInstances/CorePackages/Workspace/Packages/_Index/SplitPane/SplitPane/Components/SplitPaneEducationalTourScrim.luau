local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets

local function dimPanel(name: string, position: UDim2, size: UDim2, value: number?)
	return React.createElement("TextButton", {
		Name = name,
		Position = position,
		Size = size,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = value or 0.5,
		BorderSizePixel = 0,
		Active = true,
		AutoButtonColor = false,
		Selectable = false,
		Text = ""
	})
end

local function spotlightRing(x: number, y: number, x2: number, y2: number, p: number)
	return React.createElement("Frame", {
		Name = "SpotlightRing",
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(x2 - x, y2 - y),
		BackgroundTransparency = 1,
		ZIndex = 2
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, p) }),
		Stroke = React.createElement("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Transparency = 0.7,
			Thickness = 1
		})
	})
end

local function cornerDim(name: string, position: UDim2, position2: UDim2, p: number)
	return React.createElement("TextButton", {
		Name = name,
		Position = position,
		Size = UDim2.fromOffset(p, p),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		AutoButtonColor = false,
		Selectable = false,
		Text = ""
	}, {
		Mask = React.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
			ImageColor3 = Color3.new(0, 0, 0),
			ImageTransparency = 0.5,
			Position = position2,
			Size = UDim2.fromOffset(p * 2, p * 2),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
	})
end

local function SplitPaneEducationalTourScrim(props)
	local v = useDeviceInsets()
	local rect

	if props.targetRect ~= nil then
		rect = Rect.new(
			props.targetRect.Min.X + v.left,
			props.targetRect.Min.Y + v.top,
			props.targetRect.Max.X + v.left,
			props.targetRect.Max.Y + v.top
		)
	end

	local v2

	if rect == nil and props.dimEndX ~= nil then
		v2 = {
			HomeDim = dimPanel("HomeDim", UDim2.fromScale(0, 0), UDim2.new(0, props.dimEndX + v.left, 1, 0))
		}
	elseif rect == nil then
		v2 = {
			Dim = dimPanel("Dim", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), props.isTransparent and 1 or nil)
		}
	else
		local x = rect.Min.X
		local y = rect.Min.Y
		local x2 = rect.Max.X
		local y2 = rect.Max.Y
		local v3 = math.min(x2 - x, y2 - y) / 2

		v2 = {
			Top = dimPanel("Top", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, y)),
			Bottom = dimPanel("Bottom", UDim2.new(0, 0, 0, y2), UDim2.new(1, 0, 1, -y2)),
			Left = dimPanel("Left", UDim2.new(0, 0, 0, y), UDim2.new(0, x, 0, y2 - y)),
			Right = dimPanel("Right", UDim2.new(0, x2, 0, y), UDim2.new(1, -x2, 0, y2 - y)),
			TopLeftCorner = cornerDim("TopLeftCorner", UDim2.fromOffset(x, y), UDim2.fromOffset(0, 0), v3),
			TopRightCorner = cornerDim("TopRightCorner", UDim2.fromOffset(x2 - v3, y), UDim2.fromOffset(-v3, 0), v3),
			BottomLeftCorner = cornerDim("BottomLeftCorner", UDim2.fromOffset(x, y2 - v3), UDim2.fromOffset(0, -v3), v3),
			BottomRightCorner = cornerDim(
				"BottomRightCorner",
				UDim2.fromOffset(x2 - v3, y2 - v3),
				UDim2.fromOffset(-v3, -v3),
				v3
			),
			SpotlightRing = spotlightRing(x, y, x2, y2, v3)
		}
	end

	return React.createElement("Frame", {
		Name = "SplitPaneEducationalTourScrim",
		Position = UDim2.fromOffset(-v.left, -v.top),
		Size = UDim2.new(1, v.left + v.right, 1, v.top + v.bottom),
		BackgroundTransparency = 1
	}, v2)
end

return SplitPaneEducationalTourScrim
