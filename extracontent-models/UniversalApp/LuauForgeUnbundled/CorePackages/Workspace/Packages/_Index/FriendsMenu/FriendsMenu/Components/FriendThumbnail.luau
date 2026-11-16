local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib")
local FFlagFriendsMenuUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Flags/FFlagFriendsMenuUseProfileFrameThumbnail")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib").Models.UserModel
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local constants = UserLib.Utils.Constants

local size150x150 = constants.RbxThumbnailSizes.Size150x150
local avatarHeadShot = constants.RbxthumbTypes.AvatarHeadShot

local v5 = {
	[userModel.PresenceType.ONLINE] = {
		Image = "component_assets/circle_16",
		Color = Color3.fromRGB(0, 180, 109),
		Size = UDim2.new(0, 12, 0, 12)
	},
	[userModel.PresenceType.IN_GAME] = { Image = "icons/menu/games_small" },
	[userModel.PresenceType.IN_STUDIO] = { Image = "icons/logo/studiologo_small" }
}

return function(props)
	local friend = props.friend
	assert(friend, "friend should be non-nil. Silence type checker.")
	local v6 = useStyle()

	local v7 = React.useMemo(function()
		local v8

		if friend then
			local v9 = constants.RbxThumbnailSizeToNumberSize[size150x150]
			v8 = getRbxthumbWithTypeSizeAndOptions(friend.id, avatarHeadShot, v9, nil, nil, FFlagFriendsMenuUseProfileFrameThumbnail)
		end

		return v8 or "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png"
	end, { friend })

	local playerBackgroundDefault = v6.Theme.PlayerBackgroundDefault
	local v8

	if friend.presence ~= userModel.PresenceType.OFFLINE then
		v8 = v5[userModel.PresenceType.ONLINE]
	end

	local createElement = React.createElement
	local v10 = {
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		BackgroundTransparency = 1
	}

	local v11 = {
		Background = playerBackgroundDefault and React.createElement("Frame", {
			Size = props.size,
			Position = props.position,
			AnchorPoint = props.anchorPoint,
			BackgroundColor3 = v6.Theme.UIDefault.Color,
			BackgroundTransparency = v6.Theme.UIDefault.Transparency
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}),
		Thumbnail = props.isFetchingFriends and React.createElement(skeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			radius = radius.Circle
		}) or React.createElement(imageSetLabel, {
			Size = props.size,
			Position = props.position,
			AnchorPoint = props.anchorPoint,
			Image = v7,
			BorderSizePixel = 0,
			BackgroundColor3 = v6 and v6.Theme.UIDefault.Color,
			BackgroundTransparency = playerBackgroundDefault and 1 or v6.Theme.UIDefault.Transparency
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}),
		PresenceIcon = 0
	}

	local v12 = if v8 and not props.isFetchingFriends then React.createElement(imageSetLabel, {
		Image = images[v8.Image],
		BackgroundTransparency = 0,
		BackgroundColor3 = props.isHoverRow and v6.Theme.BackgroundOnHover.Color or v6.Theme.BackgroundDefault.Color,
		ImageColor3 = v8.Color,
		Position = UDim2.new(1, -1, 1, -1),
		AnchorPoint = Vector2.new(1, 1),
		Size = v8.Size or UDim2.new(0, iconSize.Small, 0, iconSize.Small),
		ZIndex = 2
	}, {
		Border = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v6.Theme.BackgroundDefault.Color,
			Transparency = v6.Theme.BackgroundDefault.Transparency,
			Thickness = 3
		}),
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
	}) or nil else nil
	v11.PresenceIcon = v12
	return createElement("Frame", v10, v11)
end
