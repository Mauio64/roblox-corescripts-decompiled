local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local React = require(parent.React)
local useStyle = UIBlox.Core.Style.useStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Image = Foundation.Image

local Constants = require(ProfilePlatform.Common.Constants)
local EditProfileBackground = require(parent.EditProfileBackground)
local DisplayBackground = EditProfileBackground.DisplayBackground
local Enums = require(ProfilePlatform.Common.Enums)
local useAvatarBackgroundFromWrapper = require(ProfilePlatform.Hooks.useAvatarBackgroundFromWrapper)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformMeTabMobileProfileHero = SharedFlags.FFlagProfilePlatformMeTabMobileProfileHero

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags2.FFlagProfilePlatformNewProfileHeader
local SharedFlags3 = require(parent.SharedFlags)
local FFlagPPVBackgroundUse2DAsLoadingState = SharedFlags3.FFlagPPVBackgroundUse2DAsLoadingState
local SharedFlags4 = require(parent.SharedFlags)
local FFlagPPVEnable3DBackground = SharedFlags4.FFlagPPVEnable3DBackground

local SharedFlags5 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableAvatarBackground = SharedFlags5.FFlagProfilePlatformEnableAvatarBackground

local function UserProfileAvatar(props)
	local v = useStyle()
	local v2 = useStyleMetadata()

	local v3 = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local image

	if not (FFlagPPVEnable3DBackground or not FFlagProfilePlatformEnableAvatarBackground) then
		image = useAvatarBackgroundFromWrapper()
	end

	local assetId = FFlagPPVEnable3DBackground and (v3 and v3.assetId or -1) or nil
	local v4 = FFlagProfilePlatformEnableAvatarBackground and image ~= nil
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.25, 0.75),
		NumberSequenceKeypoint.new(0.55, 0.4),
		NumberSequenceKeypoint.new(0.8, 0.15),
		NumberSequenceKeypoint.new(1, 0)
	})

	local transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
	local height

	if FFlagProfilePlatformNewProfileHeader and props.height then
		height = props.height
	else
		height = Constants.USER_PROFILE_HEADER_HEIGHT
	end

	local v5 = (not FFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
		and 0
		or math.floor(height * Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO / (Constants.ME_TAB_MOBILE_AVATAR_HEIGHT_ASPECT + Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO))

	local v6 = (not FFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
		and 0
		or math.floor(height * Constants.ME_TAB_MOBILE_AVATAR_OFFSET_Y_RATIO)
	local height2

	if
		FFlagProfilePlatformMeTabMobileProfileHero
		and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
	then
		height2 = height - v5 + Constants.ME_TAB_MOBILE_AVATAR_EXTRA_HEIGHT
	else
		height2 = height - v5
	end

	local v7 = (not FFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
		and 0
		or Constants.ME_TAB_MOBILE_AVATAR_DOWN_OFFSET - v6
	local background

	if not FFlagPPVEnable3DBackground then
		if FFlagProfilePlatformEnableAvatarBackground and image ~= nil then
			local v8 = (not FFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
				and 1.35
				or Constants.ME_TAB_MOBILE_BACKGROUND_SCALE_X

			local v9 = (not FFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
				and 1.35
				or Constants.ME_TAB_MOBILE_BACKGROUND_SCALE_Y
			local vector2

			if
				FFlagProfilePlatformMeTabMobileProfileHero
				and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
			then
				vector2 = Vector2.new(0.5, 0)
			else
				vector2 = Vector2.new(0.5, 0.5)
			end

			local position

			if
				FFlagProfilePlatformMeTabMobileProfileHero
				and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
			then
				position = UDim2.fromScale(0.5, Constants.ME_TAB_MOBILE_BACKGROUND_OFFSET_Y_RATIO)
			else
				position = UDim2.fromScale(0.5, 0.4)
			end

			background = React.createElement(Image, {
				Size = UDim2.fromScale(v8, v9),
				AnchorPoint = vector2,
				Position = position,
				Image = image,
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 1
			})
		else
			local createElement = React.createElement
			local v8 = {
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				Image = Images[v.Theme.PlayerBackgroundDefault.Image],
				ImageColor3 = 0,
				ZIndex = 1
			}
			local imageColor

			if v2 and v2.HasSurfaceOverrides then
				imageColor = v.Theme.BackgroundUIDefault.Color:Lerp(
					v.Theme.PlayerBackgroundDefault.Color,
					v.Theme.Overlay.Transparency
				)
			end

			v8.ImageColor3 = imageColor
			background = createElement(ImageSetLabel, v8)
		end
	end

	local createElement = React.createElement
	local v8

	if FFlagProfilePlatformNewProfileHeader then
		v8 = View
	else
		v8 = React.Fragment
	end

	local size

	if FFlagProfilePlatformNewProfileHeader then
		size = UDim2.new(1, 0, 0, height)
	end

	local v9 = {
		Size = size,
		ClipsDescendants = FFlagProfilePlatformMeTabMobileProfileHero and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile and true or nil
	}
	local avatarThumbnail

	if
		FFlagProfilePlatformMeTabMobileProfileHero
		and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
	then
		local createElement2 = React.createElement
		local v10 = {
			Size = UDim2.new(1, 0, 0, height2),
			Position = UDim2.new(0, 0, 1, v7),
			AnchorPoint = Vector2.new(0, 1),
			ZIndex = 2
		}

		local createElement3 = React.createElement
		local v11 = {
			height = height2,
			currentBackgroundId = assetId,
			userId = props.userId,
			userThumbnail = 0,
			cameraDistanceScale = 0
		}
		local userThumbnail

		if FFlagPPVBackgroundUse2DAsLoadingState then
			userThumbnail = props.userThumbnail
		end

		v11.userThumbnail = userThumbnail
		v11.cameraDistanceScale = Constants.ME_TAB_MOBILE_CAMERA_DISTANCE_SCALE
		avatarThumbnail = createElement2(View, v10, {
			DisplayBackground = createElement3(DisplayBackground, v11)
		})
	else
		local createElement2 = React.createElement
		local v10 = {
			height = height,
			currentBackgroundId = assetId,
			userId = props.userId,
			userThumbnail = 0
		}
		local userThumbnail

		if FFlagPPVBackgroundUse2DAsLoadingState then
			userThumbnail = props.userThumbnail
		end

		v10.userThumbnail = userThumbnail
		avatarThumbnail = createElement2(DisplayBackground, v10)
	end

	local topGradient

	if not (FFlagPPVEnable3DBackground or FFlagProfilePlatformEnableAvatarBackground and v4 or FFlagProfilePlatformNewProfileHeader) then
		topGradient = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = v.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 3
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
			})
		})
	end

	local bottomGradient

	if not (FFlagProfilePlatformEnableAvatarBackground and v4) then
		local createElement2 = React.createElement
		local size2

		if FFlagProfilePlatformNewProfileHeader then
			size2 = UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT)
		else
			size2 = UDim2.new(1, 0, 0, height / 2)
		end

		local v10 = {
			Size = size2,
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 3
		}

		local createElement3 = React.createElement

		if FFlagPPVEnable3DBackground then
			transparency = numberSequence
		end

		bottomGradient = createElement2("Frame", v10, {
			UIGradient = createElement3("UIGradient", { Rotation = 90, Transparency = transparency })
		})
	end

	local cornerRadius

	if FFlagProfilePlatformNewProfileHeader and props.isPeekView then
		cornerRadius = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
	end

	return createElement(v8, v9, {
		Background = background,
		AvatarThumbnail = avatarThumbnail,
		TopGradient = topGradient,
		BottomGradient = bottomGradient,
		CornerRadius = cornerRadius
	})
end

return UserProfileAvatar
