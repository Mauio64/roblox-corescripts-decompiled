local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images

local function ScreenshotHighlighter(t1: {[any]: any}) -- line: 25
	-- upvalues: RobloxGui (copy), React (copy), ImageSetButton (copy), Images (copy)
	local AbsoluteSize = RobloxGui.AbsoluteSize
	local v10 = (AbsoluteSize.Y > AbsoluteSize.X and AbsoluteSize.X or AbsoluteSize.Y) / 5
	local v11, v12 = React.useState(false)

	local function v13(p1, vector3: Vector3) -- line: 35
		-- upvalues: t1 (copy), v10 (copy)
		local v19 = (Vector2.new(vector3.X, vector3.Y) - p1.AbsolutePosition) / p1.AbsoluteSize

		table.insert(t1.annotationPoints, v19)

		local v20 = if not (p1.AbsoluteSize.X > p1.AbsoluteSize.Y) then p1.AbsoluteSize.Y else p1.AbsoluteSize.X

		t1.setAnnotationCircleRadius(v10 * 0.5 / v20)
		t1.setAnnotationAreaDimensions(p1.AbsoluteSize.X, p1.AbsoluteSize.Y)
		t1.handleAnnotationPoints(t1.annotationPoints)
	end

	local t2 = {}

	for i, v in ipairs(t1.annotationPoints) do
		t2["point" .. i] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(v.X, v.Y),
			Size = UDim2.fromOffset(v10, v10)
		}, {
			Border = React.createElement(ImageSetButton, {
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v10, v10),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["component_assets/circle_49_stroke_1"],
				ImageColor3 = Color3.fromHex("#3CF3E9")
			}),
			Background = React.createElement(ImageSetButton, {
				ImageTransparency = 0.6,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v10, v10),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["component_assets/circle_49"],
				ImageColor3 = Color3.fromHex("#3CF3E9")
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[React.Event.InputBegan] = function(p2, p3) -- line: 47
			-- upvalues: t1 (copy), v12 (copy), v13 (copy)
			local v23 = p3.UserInputState == Enum.UserInputState.Begin
			local v24 = p3.UserInputType == Enum.UserInputType.Touch
			local v25 = p3.UserInputType == Enum.UserInputType.MouseButton1

			if v23 and ((v24 or v25) and #t1.annotationPoints < 25) then
				v12(true)
				v13(p2, p3.Position)
			end
		end,
		[React.Event.InputChanged] = function(_, _) -- line: 57
		end,
		[React.Event.InputEnded] = function(_, _) -- line: 69
			-- upvalues: v11 (copy), v12 (copy)
			if v11 then
				v12(false)
			end
		end,
		ZIndex = 3
	}, t2)
end

return ScreenshotHighlighter
