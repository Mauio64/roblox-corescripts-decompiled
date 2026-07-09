local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Frame = require(AppChat.Components.Common.Frame)
local AvatarThumbnail = require(script.Parent.AvatarThumbnail)
local CircleMask = require(script.Parent.CircleMask)
local ImageSetLabel = require(AppChatParent.UIBlox).Core.ImageSet.ImageSetLabel

local function AvatarOneToOne(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), ImageSetLabel (copy), CircleMask (copy), Frame (copy), AvatarThumbnail (copy)
	local v10 = if not t1.showNewPresenceImage then React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, t1.presenceIndicatorSize, 0, t1.presenceIndicatorSize),
		Image = t1.presenceImage
	}) else React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(t1.presenceIndicatorSize, t1.presenceIndicatorSize),
		Image = t1.presenceImage,
		ImageColor3 = t1.presenceImageColor3,
		ImageTransparency = t1.presenceImageTransparency
	})

	return React.createElement(CircleMask, {
		circleColor3 = t1.circleColor3,
		circleTransparency = t1.circleTransparency,
		circleInteriorBackgroundColor3 = t1.circleInteriorBackgroundColor3,
		circleInteriorBackgroundTransparency = t1.circleInteriorBackgroundTransparency,
		circleDividerColor3 = t1.circleDividerColor3,
		circleDividerTransparency = t1.circleDividerTransparency,
		overlaySize = t1.overlaySize,
		renderAboveMask = React.createElement(Frame, {}, {
			layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			presenceIndicator = v10
		}),
		onActivated = t1.onActivated,
		selectable = t1.selectable
	}, {
		uiCorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		avatar = React.createElement(AvatarThumbnail, {
			thumbnail = t1.thumbnail,
			cornerRadius = UDim.new(1, 0)
		})
	})
end

return AvatarOneToOne
