local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local ParentParent = script.Parent.Parent.Parent
local GetFIntRAMaxAnnotationCount = require(ParentParent.Flags.GetFIntRAMaxAnnotationCount)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images

local function ScreenshotHighlighter(t1: {[any]: any}) -- line: 24
	-- upvalues: RobloxGui (copy), React (copy), GetFIntRAMaxAnnotationCount (copy), ImageSetButton (copy), Images (copy)
	local AbsoluteSize = RobloxGui.AbsoluteSize
	local v12 = (AbsoluteSize.Y > AbsoluteSize.X and AbsoluteSize.X or AbsoluteSize.Y) / 5
	local v13, v14 = React.useState(false)

	local function v15(p1, vector3: Vector3) -- line: 34
		-- upvalues: t1 (copy), v12 (copy)
		local v21 = (Vector2.new(vector3.X, vector3.Y) - p1.AbsolutePosition) / p1.AbsoluteSize

		table.insert(t1.annotationPoints, v21)

		local v22 = if not (p1.AbsoluteSize.X > p1.AbsoluteSize.Y) then p1.AbsoluteSize.Y else p1.AbsoluteSize.X

		t1.setAnnotationCircleRadius(v12 * 0.5 / v22)
		t1.setAspectRatioDimensions(p1.AbsoluteSize.X, p1.AbsoluteSize.Y)
		t1.handleAnnotationPoints(t1.annotationPoints)
	end

	local t2 = {}

	for i, v in ipairs(t1.annotationPoints) do
		t2["point" .. i] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(v.X, v.Y),
			Size = UDim2.fromOffset(v12, v12)
		}, {
			Border = React.createElement(ImageSetButton, {
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v12, v12),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["component_assets/circle_49_stroke_1"],
				ImageColor3 = Color3.fromHex("#3CF3E9")
			}),
			Background = React.createElement(ImageSetButton, {
				ImageTransparency = 0.6,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v12, v12),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["component_assets/circle_49"],
				ImageColor3 = Color3.fromHex("#3CF3E9")
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[React.Event.InputBegan] = function(p2, p3) -- line: 46
			-- upvalues: t1 (copy), GetFIntRAMaxAnnotationCount (copy), v14 (copy), v15 (copy)
			local v25 = p3.UserInputState == Enum.UserInputState.Begin
			local v26 = p3.UserInputType == Enum.UserInputType.Touch
			local v27 = p3.UserInputType == Enum.UserInputType.MouseButton1

			if v25 and ((v26 or v27) and #t1.annotationPoints < GetFIntRAMaxAnnotationCount()) then
				v14(true)
				v15(p2, p3.Position)
			end
		end,
		[React.Event.InputChanged] = function(_, _) -- line: 56
		end,
		[React.Event.InputEnded] = function(_, _) -- line: 68
			-- upvalues: v13 (copy), v14 (copy)
			if v13 then
				v14(false)
			end
		end,
		ZIndex = 3
	}, t2)
end

return ScreenshotHighlighter
