local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)

local Frame = require(AppChat.Components.Common.Frame)
local AvatarThumbnail = require(script.Parent.AvatarThumbnail)
local CircleMask = require(script.Parent.CircleMask)

local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function AvatarOneToOne(props)
	local presenceIndicator

	if props.showNewPresenceImage then
		presenceIndicator = React.createElement(ImageSetLabel, {
			Size = UDim2.fromOffset(props.presenceIndicatorSize, props.presenceIndicatorSize),
			BackgroundTransparency = 1,
			Image = props.presenceImage,
			ImageColor3 = props.presenceImageColor3,
			ImageTransparency = props.presenceImageTransparency
		})
	else
		presenceIndicator = React.createElement("ImageLabel", {
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
			presenceIndicator = presenceIndicator
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
