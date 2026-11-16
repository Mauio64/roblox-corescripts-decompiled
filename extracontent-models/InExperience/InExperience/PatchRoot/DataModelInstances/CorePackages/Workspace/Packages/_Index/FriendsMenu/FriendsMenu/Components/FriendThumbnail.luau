local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent

local React = require(parent.React)
local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib2 = require(parent.UserLib)
local FFlagFriendsMenuUseProfileFrameThumbnail = require(FriendsMenu.Flags.FFlagFriendsMenuUseProfileFrameThumbnail)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

local UserLib3 = require(parent.UserLib)
local UserModel = UserLib3.Models.UserModel
require(FriendsMenu.friendsMenuModalType)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local Constants = UserLib2.Utils.Constants

local Size150x150 = Constants.RbxThumbnailSizes.Size150x150
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot

local v = {
	[UserModel.PresenceType.ONLINE] = {
		Image = "component_assets/circle_16",
		Color = Color3.fromRGB(0, 180, 109),
		Size = UDim2.new(0, 12, 0, 12)
	},
	[UserModel.PresenceType.IN_GAME] = { Image = "icons/menu/games_small" },
	[UserModel.PresenceType.IN_STUDIO] = { Image = "icons/logo/studiologo_small" }
}

return function(props)
	local friend = props.friend
	assert(friend, "friend should be non-nil. Silence type checker.")
	local v2 = useStyle()

	local image = React.useMemo(function()
		local v3

		if friend then
			local v4 = Constants.RbxThumbnailSizeToNumberSize[Size150x150]
			v3 = getRbxthumbWithTypeSizeAndOptions(
				friend.id,
				AvatarHeadShot,
				v4,
				nil,
				nil,
				FFlagFriendsMenuUseProfileFrameThumbnail
			)
		end

		return v3 or "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png"
	end, { friend })

	local playerBackgroundDefault = v2.Theme.PlayerBackgroundDefault
	local v3

	if friend.presence ~= UserModel.PresenceType.OFFLINE then
		v3 = v[UserModel.PresenceType.ONLINE]
	end

	local createElement = React.createElement
	local v4 = {
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		BackgroundTransparency = 1
	}

	local v5 = {
		Background = playerBackgroundDefault and React.createElement("Frame", {
			Size = props.size,
			Position = props.position,
			AnchorPoint = props.anchorPoint,
			BackgroundColor3 = v2.Theme.UIDefault.Color,
			BackgroundTransparency = v2.Theme.UIDefault.Transparency
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
		}),
		Thumbnail = props.isFetchingFriends and React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			radius = Radius.Circle
		}) or React.createElement(ImageSetLabel, {
			Size = props.size,
			Position = props.position,
			AnchorPoint = props.anchorPoint,
			Image = image,
			BorderSizePixel = 0,
			BackgroundColor3 = v2 and v2.Theme.UIDefault.Color,
			BackgroundTransparency = playerBackgroundDefault and 1 or v2.Theme.UIDefault.Transparency
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
		}),
		PresenceIcon = 0
	}
	local presenceIcon

	if v3 and not props.isFetchingFriends then
		presenceIcon = React.createElement(ImageSetLabel, {
			Image = Images[v3.Image],
			BackgroundTransparency = 0,
			BackgroundColor3 = props.isHoverRow and v2.Theme.BackgroundOnHover.Color or v2.Theme.BackgroundDefault.Color,
			ImageColor3 = v3.Color,
			Position = UDim2.new(1, -1, 1, -1),
			AnchorPoint = Vector2.new(1, 1),
			Size = v3.Size or UDim2.new(0, IconSize.Small, 0, IconSize.Small),
			ZIndex = 2
		}, {
			Border = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v2.Theme.BackgroundDefault.Color,
				Transparency = v2.Theme.BackgroundDefault.Transparency,
				Thickness = 3
			}),
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
		}) or nil
	end

	v5.PresenceIcon = presenceIcon
	return createElement("Frame", v4, v5)
end
