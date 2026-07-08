local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local React = require(InGameAssetReportingParent.React)
local UIBlox = require(InGameAssetReportingParent.UIBlox)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images

local function ScreenshotHighlighter(t1: {[any]: any}) -- line: 25
	-- upvalues: RobloxGui (copy), React (copy), ImageSetButton (copy), Images (copy)
	local AbsoluteSize = RobloxGui.AbsoluteSize
	local v11 = (AbsoluteSize.Y > AbsoluteSize.X and AbsoluteSize.X or AbsoluteSize.Y) / 5
	local v12, v13 = React.useState(false)

	local function v14(p1, vector3: Vector3) -- line: 35
		-- upvalues: v11 (copy), t1 (copy)
		local v20 = (Vector2.new(vector3.X, vector3.Y) - p1.AbsolutePosition) / p1.AbsoluteSize
		local v21 = if not (p1.AbsoluteSize.X > p1.AbsoluteSize.Y) then p1.AbsoluteSize.Y else p1.AbsoluteSize.X
		local v22 = v11 * 0.5 / v21

		t1.handleNewAnnotationPoint(v20, v22)
	end

	local t2 = {}

	for i, v in ipairs(t1.annotationPoints) do
		t2["point" .. i] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(v.X, v.Y),
			Size = UDim2.fromOffset(v11, v11)
		}, {
			Border = React.createElement(ImageSetButton, {
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v11, v11),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["component_assets/circle_49_stroke_1"],
				ImageColor3 = Color3.fromHex("#3CF3E9")
			}),
			Background = React.createElement(ImageSetButton, {
				ImageTransparency = 0.6,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v11, v11),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images["component_assets/circle_49"],
				ImageColor3 = Color3.fromHex("#3CF3E9")
			})
		})
	end

	return React.createElement("Frame", {
		Active = false,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[React.Event.InputBegan] = function(p2, p3) -- line: 45
			-- upvalues: t1 (copy), v13 (copy), v14 (copy)
			local v25 = p3.UserInputState == Enum.UserInputState.Begin
			local v26 = p3.UserInputType == Enum.UserInputType.Touch
			local v27 = p3.UserInputType == Enum.UserInputType.MouseButton1

			if v25 and (v26 or v27) then
				if #t1.annotationPoints < 5 then
					v13(true)
					v14(p2, p3.Position)

					return
				end

				t1.onExceedMaxAnnotationLimit()
			end
		end,
		[React.Event.InputChanged] = function(_, _) -- line: 59
		end,
		[React.Event.InputEnded] = function(_, _) -- line: 71
			-- upvalues: v12 (copy), v13 (copy)
			if v12 then
				v13(false)
			end
		end,
		ZIndex = 3
	}, t2)
end

return ScreenshotHighlighter
