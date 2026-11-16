local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local UIBlox2 = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

local ImageSetLabel = UIBlox2.Core.ImageSet.ImageSetLabel
local Images = UIBlox2.App.ImageSet.Images

local extended = Roact.PureComponent:extend("LoadingAvatar")
local defineFastFlag = game:DefineFastFlag("AppChatLoadingIndicatorTransparency", false)

extended.defaultProps = {
	avatarImage = Images["component_assets/circle_49_mask"],
	cellHeight = 64,
	avatarSize = 36,
	LayoutOrder = 0
}

function extended.render(p)
	local v = p.props.cellHeight / 2 - p.props.avatarSize / 2

	return withStyle(function(p2)
		local createElement = Roact.createElement
		local v2 = {
			Size = UDim2.new(0, p.props.cellHeight, 0, p.props.cellHeight),
			BackgroundTransparency = 1,
			LayoutOrder = p.props.LayoutOrder,
			BorderSizePixel = 0
		}

		local v3 = {
			avatarShimmer = Roact.createElement(Skeleton, {
				Size = UDim2.fromOffset(p.props.avatarSize, p.props.avatarSize),
				Position = UDim2.fromOffset(v, v),
				radius = Radius.Circle
			}),
			avatarMask = 0
		}
		local avatarMask

		if not defineFastFlag then
			avatarMask = Roact.createElement(ImageSetLabel, {
				Size = UDim2.fromOffset(p.props.avatarSize, p.props.avatarSize),
				Position = UDim2.fromOffset(v, v),
				Image = p.props.avatarImage,
				BackgroundTransparency = 1,
				ImageColor3 = p2.Theme.BackgroundDefault.Color
			})
		end

		v3.avatarMask = avatarMask
		return createElement("Frame", v2, v3)
	end)
end

return extended
