local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local React = require(FriendsMenuParent.React)
local getRbxthumbWithTypeSizeAndOptions = require(FriendsMenuParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib = require(FriendsMenuParent.UserLib)
local FFlagFriendsMenuUseProfileFrameThumbnail = require(FriendsMenu.Flags.FFlagFriendsMenuUseProfileFrameThumbnail)
local UIBlox = require(FriendsMenuParent.UIBlox)
local Foundation = require(FriendsMenuParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local UserModel = require(FriendsMenuParent.UserLib).Models.UserModel

require(FriendsMenu.friendsMenuModalType)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local Constants = UserLib.Utils.Constants
local Size150x150 = Constants.RbxThumbnailSizes.Size150x150
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot
local t1 = {
	[UserModel.PresenceType.ONLINE] = {
		Image = "component_assets/circle_16",
		Color = Color3.fromRGB(0, 180, 109),
		Size = UDim2.new(0, 12, 0, 12)
	},
	[UserModel.PresenceType.IN_GAME] = {
		Image = "icons/menu/games_small"
	},
	[UserModel.PresenceType.IN_STUDIO] = {
		Image = "icons/logo/studiologo_small"
	}
}

return function(t2: {[any]: any}) -- line: 56
	-- upvalues: useStyle (copy), React (copy), Constants (copy), Size150x150 (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), FFlagFriendsMenuUseProfileFrameThumbnail (copy), UserModel (copy), t1 (copy), Skeleton (copy), EnumsRadius (copy), ImageSetLabel (copy), Images (copy), IconSize (copy)
	local friend = t2.friend

	assert(friend, "friend should be non-nil. Silence type checker.")

	local v22 = useStyle()
	local v23 = React.useMemo(function() -- line: 61
		-- upvalues: friend (copy), Constants (copy), Size150x150 (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), FFlagFriendsMenuUseProfileFrameThumbnail (copy)
		local v26 = nil

		if friend then
			local v27 = Constants.RbxThumbnailSizeToNumberSize[Size150x150]

			v26 = getRbxthumbWithTypeSizeAndOptions(friend.id, AvatarHeadShot, v27, nil, nil, FFlagFriendsMenuUseProfileFrameThumbnail)
		end

		if not v26 then
			v26 = "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png"
		end

		return v26
	end, { friend })
	local PlayerBackgroundDefault = v22.Theme.PlayerBackgroundDefault
	local v25 = if friend.presence == UserModel.PresenceType.OFFLINE then nil else t1[UserModel.PresenceType.ONLINE]

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t2.size,
		Position = t2.position,
		AnchorPoint = t2.anchorPoint
	}, {
		Background = PlayerBackgroundDefault and React.createElement("Frame", {
			Size = t2.size,
			Position = t2.position,
			AnchorPoint = t2.anchorPoint,
			BackgroundColor3 = v22.Theme.UIDefault.Color,
			BackgroundTransparency = v22.Theme.UIDefault.Transparency
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}),
		Thumbnail = t2.isFetchingFriends and React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			radius = EnumsRadius.Circle
		}) or React.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			Size = t2.size,
			Position = t2.position,
			AnchorPoint = t2.anchorPoint,
			Image = v23,
			BackgroundColor3 = v22 and v22.Theme.UIDefault.Color,
			BackgroundTransparency = if not PlayerBackgroundDefault then v22.Theme.UIDefault.Transparency else 1
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}),
		PresenceIcon = v25 and (not t2.isFetchingFriends and React.createElement(ImageSetLabel, {
			BackgroundTransparency = 0,
			ZIndex = 2,
			Image = Images[v25.Image],
			BackgroundColor3 = t2.isHoverRow and v22.Theme.BackgroundOnHover.Color or v22.Theme.BackgroundDefault.Color,
			ImageColor3 = v25.Color,
			Position = UDim2.new(1, -1, 1, -1),
			AnchorPoint = Vector2.new(1, 1),
			Size = v25.Size or UDim2.new(0, IconSize.Small, 0, IconSize.Small)
		}, {
			Border = React.createElement("UIStroke", {
				Thickness = 3,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v22.Theme.BackgroundDefault.Color,
				Transparency = v22.Theme.BackgroundDefault.Transparency
			}),
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		})) or nil
	})
end
