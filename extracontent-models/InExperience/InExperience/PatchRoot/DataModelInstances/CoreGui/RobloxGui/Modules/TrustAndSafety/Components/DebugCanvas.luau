local CorePackages = game:GetService("CorePackages")
local _ = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.RoactRodux)
require(CorePackages.Packages.t)

local _ = require(CorePackages.Packages.UIBlox).App.Button.TextButton
local ParentParent = script.Parent.Parent

require(ParentParent.Actions.EndReportFlow)
require(ParentParent.Resources.Constants)

local GetFFlagReportAnythingDebugCanvas = require(ParentParent.Flags.GetFFlagReportAnythingDebugCanvas)
local v7 = React.PureComponent:extend("DebugCanvas")

function v7.render(p1) -- line: 23
	-- upvalues: GetFFlagReportAnythingDebugCanvas (copy), React (copy)
	if not GetFFlagReportAnythingDebugCanvas() or not p1.props.identifiedAvatars then
		return React.createElement("Frame", {
			Size = UDim2.fromScale(0, 0)
		})
	end

	local t1 = {}

	for _, v in pairs(p1.props.identifiedAvatars) do
		local boundingBox = v.boundingBox

		t1[#t1 + 1] = React.createElement("Frame", {
			BackgroundTransparency = 0.8,
			Position = UDim2.fromScale(boundingBox.min.X, boundingBox.min.Y),
			Size = UDim2.fromScale(boundingBox.max.X - boundingBox.min.X, boundingBox.max.Y - boundingBox.min.Y),
			BackgroundColor3 = Color3.fromRGB(20, 0, 255 * v.hitRate)
		})

		local v13 = #v.convexHull

		for v14, v15 in v.convexHull do
			t1[#t1 + 1] = React.createElement("Frame", {
				BackgroundTransparency = 0.2,
				Position = UDim2.new(v15.X, -2, v15.Y, -2),
				Size = UDim2.fromOffset(4, 4),
				BackgroundColor3 = Color3.fromHSV(v14 / v13, 1, 0.65)
			})
		end
	end

	for _, v in pairs(p1.props.identifiedAds) do
		local boundingBox = v.boundingBox

		t1[#t1 + 1] = React.createElement("Frame", {
			BackgroundTransparency = 0.8,
			Position = UDim2.fromScale(boundingBox.min.X, boundingBox.min.Y),
			Size = UDim2.fromScale(boundingBox.max.X - boundingBox.min.X, boundingBox.max.Y - boundingBox.min.Y),
			BackgroundColor3 = Color3.fromRGB(20, 0, 255)
		})

		for _, v20 in v.visibleRegions do
			local v21 = #v20.convexHull

			for v22, v23 in v20.convexHull do
				t1[#t1 + 1] = React.createElement("Frame", {
					BackgroundTransparency = 0.2,
					Position = UDim2.new(v23.X, -2, v23.Y, -2),
					Size = UDim2.fromOffset(4, 4),
					BackgroundColor3 = Color3.fromHSV(v22 / v21, 1, 0.65)
				})
			end
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 0.9,
		Size = UDim2.fromScale(1, 1),
		ZIndex = p1.props.ZIndex
	}, t1)
end

return v7
