local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive").useDeviceInsets

local function dimPanel(p2, udim, udim2, value)
	return React.createElement("TextButton", {
		Name = p2,
		Position = udim,
		Size = udim2,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = value or 0.5,
		BorderSizePixel = 0,
		Active = true,
		AutoButtonColor = false,
		Selectable = false,
		Text = ""
	})
end

local function spotlightRing(x, y, x2, y2, p2)
	return React.createElement("Frame", {
		Name = "SpotlightRing",
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(x2 - x, y2 - y),
		BackgroundTransparency = 1,
		ZIndex = 2
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, p2) }),
		Stroke = React.createElement("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Transparency = 0.7,
			Thickness = 1
		})
	})
end

local function cornerDim(p2, udim, udim2, p3)
	return React.createElement("TextButton", {
		Name = p2,
		Position = udim,
		Size = UDim2.fromOffset(p3, p3),
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
			Position = udim2,
			Size = UDim2.fromOffset(p3 * 2, p3 * 2),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
	})
end

local function SplitPaneEducationalTourScrim(props)
	local v5 = useDeviceInsets()
	local rect

	if props.targetRect ~= nil then
		rect = Rect.new(
			props.targetRect.Min.X + v5.left,
			props.targetRect.Min.Y + v5.top,
			props.targetRect.Max.X + v5.left,
			props.targetRect.Max.Y + v5.top
		)
	end

	local v6

	if rect == nil and props.dimEndX ~= nil then
		v6 = {
			HomeDim = dimPanel(
				"HomeDim",
				UDim2.fromScale(0, 0),
				UDim2.new(0, props.dimEndX + v5.left, 1, 0)
			)
		}
	elseif rect == nil then
		v6 = {
			Dim = dimPanel(
				"Dim",
				UDim2.fromScale(0, 0),
				UDim2.fromScale(1, 1),
				props.isTransparent and 1 or nil
			)
		}
	else
		local x = rect.Min.X
		local y = rect.Min.Y
		local x2 = rect.Max.X
		local y2 = rect.Max.Y
		local v7 = math.min(x2 - x, y2 - y) / 2

		v6 = {
			Top = dimPanel("Top", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, y)),
			Bottom = dimPanel("Bottom", UDim2.new(0, 0, 0, y2), UDim2.new(1, 0, 1, -y2)),
			Left = dimPanel("Left", UDim2.new(0, 0, 0, y), UDim2.new(0, x, 0, y2 - y)),
			Right = dimPanel("Right", UDim2.new(0, x2, 0, y), UDim2.new(1, -x2, 0, y2 - y)),
			TopLeftCorner = cornerDim("TopLeftCorner", UDim2.fromOffset(x, y), UDim2.fromOffset(0, 0), v7),
			TopRightCorner = cornerDim(
				"TopRightCorner",
				UDim2.fromOffset(x2 - v7, y),
				UDim2.fromOffset(-v7, 0),
				v7
			),
			BottomLeftCorner = cornerDim(
				"BottomLeftCorner",
				UDim2.fromOffset(x, y2 - v7),
				UDim2.fromOffset(0, -v7),
				v7
			),
			BottomRightCorner = cornerDim(
				"BottomRightCorner",
				UDim2.fromOffset(x2 - v7, y2 - v7),
				UDim2.fromOffset(-v7, -v7),
				v7
			),
			SpotlightRing = spotlightRing(x, y, x2, y2, v7)
		}
	end

	return React.createElement("Frame", {
		Name = "SplitPaneEducationalTourScrim",
		Position = UDim2.fromOffset(-v5.left, -v5.top),
		Size = UDim2.new(1, v5.left + v5.right, 1, v5.top + v5.bottom),
		BackgroundTransparency = 1
	}, v6)
end

return SplitPaneEducationalTourScrim
