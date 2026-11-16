local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local Frame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/Frame")
local AvatarThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle/AvatarThumbnail")
local CircleMask = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle/CircleMask")

local imageSetLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.ImageSet.ImageSetLabel

local function AvatarOneToOne(props)
	local v5

	if props.showNewPresenceImage then
		v5 = React.createElement(imageSetLabel, {
			Size = UDim2.fromOffset(props.presenceIndicatorSize, props.presenceIndicatorSize),
			BackgroundTransparency = 1,
			Image = props.presenceImage,
			ImageColor3 = props.presenceImageColor3,
			ImageTransparency = props.presenceImageTransparency
		})
	else
		v5 = React.createElement("ImageLabel", {
			Size = UDim2.new(0, props.presenceIndicatorSize, 0, props.presenceIndicatorSize),
			BackgroundTransparency = 1,
			Image = props.presenceImage
		})
	end

	return React.createElement(CircleMask, {
		circleColor3 = props.circleColor3,
		circleTransparency = props.circleTransparency,
		circleInteriorBackgroundColor3 = props.circleInteriorBackgroundColor3,
		circleInteriorBackgroundTransparency = props.circleInteriorBackgroundTransparency,
		circleDividerColor3 = props.circleDividerColor3,
		circleDividerTransparency = props.circleDividerTransparency,
		overlaySize = props.overlaySize,
		renderAboveMask = React.createElement(Frame, {}, {
			layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			presenceIndicator = v5
		}),
		onActivated = props.onActivated,
		selectable = props.selectable
	}, {
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		avatar = React.createElement(AvatarThumbnail, {
			thumbnail = props.thumbnail,
			cornerRadius = UDim.new(1, 0)
		})
	})
end

return AvatarOneToOne
