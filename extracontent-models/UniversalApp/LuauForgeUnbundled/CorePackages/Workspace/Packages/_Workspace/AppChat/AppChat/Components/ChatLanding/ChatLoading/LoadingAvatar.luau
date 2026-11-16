local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("LoadingAvatar")
local defineFastFlag = game:DefineFastFlag("AppChatLoadingIndicatorTransparency", false)

extended.defaultProps = {
	avatarImage = images["component_assets/circle_49_mask"],
	cellHeight = 64,
	avatarSize = 36,
	LayoutOrder = 0
}

function extended.render(p2)
	local v5 = p2.props.cellHeight / 2 - p2.props.avatarSize / 2

	return withStyle(function(p3)
		local createElement = Roact.createElement
		local v7 = {
			Size = UDim2.new(0, p2.props.cellHeight, 0, p2.props.cellHeight),
			BackgroundTransparency = 1,
			LayoutOrder = p2.props.LayoutOrder,
			BorderSizePixel = 0
		}

		local v8 = {
			avatarShimmer = Roact.createElement(skeleton, {
				Size = UDim2.fromOffset(p2.props.avatarSize, p2.props.avatarSize),
				Position = UDim2.fromOffset(v5, v5),
				radius = radius.Circle
			}),
			avatarMask = 0
		}

		local v9 = if not defineFastFlag then Roact.createElement(imageSetLabel, {
			Size = UDim2.fromOffset(p2.props.avatarSize, p2.props.avatarSize),
			Position = UDim2.fromOffset(v5, v5),
			Image = p2.props.avatarImage,
			BackgroundTransparency = 1,
			ImageColor3 = p3.Theme.BackgroundDefault.Color
		}) else nil
		v8.avatarMask = v9
		return createElement("Frame", v7, v8)
	end)
end

return extended
