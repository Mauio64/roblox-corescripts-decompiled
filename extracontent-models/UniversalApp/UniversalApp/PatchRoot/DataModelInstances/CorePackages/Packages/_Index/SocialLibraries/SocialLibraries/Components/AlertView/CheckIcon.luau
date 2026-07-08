local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Images = require(script.Parent.Images)
local v6 = Roact.PureComponent:extend("CheckIcon")

v6.defaultProps = {
	checked = false,
	onActivated = function() -- line: 11
	end
}

function v6.render(p1) -- line: 14
	-- upvalues: Images (copy), UIBlox (copy), Roact (copy)
	local v8 = p1.props.checked and Images.checkFill or Images.checkStroke

	return UIBlox.Style.withStyle(function(p2) -- line: 16
		-- upvalues: Roact (copy), v8 (copy), p1 (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 17, 0, 17)
		}, {
			Button = Roact.createElement("ImageButton", {
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = v8.Image,
				ImageRectOffset = v8.ImageRectOffset,
				ImageRectSize = v8.ImageRectSize,
				ImageColor3 = p2.Theme.UIDefault.Color,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 1, 0),
				SliceCenter = v8.SliceCenter,
				[Roact.Event.MouseButton1Click] = p1.props.onActivated
			})
		})
	end)
end

return v6
