local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local parent = InGameAssetReporting.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images

local function ScreenshotHighlighter(props)
	local absoluteSize = RobloxGui.AbsoluteSize
	local v = (absoluteSize.Y > absoluteSize.X and absoluteSize.X or absoluteSize.Y) / 5

	local state, setState = React.useState(false)

	local function fn(p, position: Vector3)
		local v2 = (Vector2.new(position.X, position.Y) - p.AbsolutePosition) / p.AbsoluteSize
		local v3

		if p.AbsoluteSize.X > p.AbsoluteSize.Y then
			v3 = p.AbsoluteSize.X
		else
			v3 = p.AbsoluteSize.Y
		end

		local v4 = v * 0.5 / v3
		props.handleNewAnnotationPoint(v2, v4)
	end

	local children = {}

	local function fn2(p, data)
		local v2 = data.UserInputState == Enum.UserInputState.Begin
		local v3 = data.UserInputType == Enum.UserInputType.Touch
		local v4 = data.UserInputType == Enum.UserInputType.MouseButton1

		if v2 and (v3 or v4) then
			if #props.annotationPoints < 5 then
				setState(true)
				fn(p, data.Position)
			else
				props.onExceedMaxAnnotationLimit()
			end
		end
	end

	local function fn3(_, _) end

	local function fn4(_, _)
		if state then
			setState(false)
		end
	end

	for i, annotationPoint in ipairs(props.annotationPoints) do
		children["point" .. i] = React.createElement(
			"Frame",
			{
				Position = UDim2.fromScale(annotationPoint.X, annotationPoint.Y),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v, v)
			},
			{
				Border = React.createElement(ImageSetButton, {
					Size = UDim2.fromOffset(v, v),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Images["component_assets/circle_49_stroke_1"],
					ImageColor3 = Color3.fromHex("#3CF3E9"),
					ImageTransparency = 0,
					BackgroundTransparency = 1
				}),
				Background = React.createElement(ImageSetButton, {
					Size = UDim2.fromOffset(v, v),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Images["component_assets/circle_49"],
					ImageColor3 = Color3.fromHex("#3CF3E9"),
					ImageTransparency = 0.6,
					BackgroundTransparency = 1
				})
			}
		)
	end

	return React.createElement("Frame", {
		Active = false,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[React.Event.InputBegan] = fn2,
		[React.Event.InputChanged] = fn3,
		[React.Event.InputEnded] = fn4,
		ZIndex = 3
	}, children)
end

return ScreenshotHighlighter
