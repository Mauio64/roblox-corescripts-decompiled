local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local Images = require(script.Parent.Images)

local extended = roact.PureComponent:extend("CheckIcon")

extended.defaultProps = {
	checked = false,
	onActivated = function() end
}

function extended.render(p)
	local checkFill = p.props.checked and Images.checkFill or Images.checkStroke
	return uiBlox.Style.withStyle(function(p2)
		return roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(0, 17, 0, 17) },
			{
				Button = roact.createElement("ImageButton", {
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = checkFill.Image,
					ImageRectOffset = checkFill.ImageRectOffset,
					ImageRectSize = checkFill.ImageRectSize,
					ImageColor3 = p2.Theme.UIDefault.Color,
					ScaleType = Enum.ScaleType.Slice,
					Size = UDim2.new(1, 0, 1, 0),
					SliceCenter = checkFill.SliceCenter,
					[roact.Event.MouseButton1Click] = p.props.onActivated
				})
			}
		)
	end)
end

return extended
