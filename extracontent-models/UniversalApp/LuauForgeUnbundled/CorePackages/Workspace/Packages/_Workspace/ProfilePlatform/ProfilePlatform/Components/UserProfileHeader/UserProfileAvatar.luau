local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useStyle = UIBlox.Core.Style.useStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local image = Foundation.Image

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local displayBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfileBackground").DisplayBackground
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useAvatarBackgroundFromWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAvatarBackgroundFromWrapper")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")

local fFlagProfilePlatformMeTabMobileProfileHero = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformMeTabMobileProfileHero

local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformNewProfileHeader
local fFlagPPVBackgroundUse2DAsLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagPPVBackgroundUse2DAsLoadingState
local fFlagPPVEnable3DBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagPPVEnable3DBackground

local fFlagProfilePlatformEnableAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableAvatarBackground

local function UserProfileAvatar(props)
	local v5 = useStyle()
	local v6 = useStyleMetadata()

	local v7 = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local v8

	if not (fFlagPPVEnable3DBackground or not fFlagProfilePlatformEnableAvatarBackground) then
		v8 = useAvatarBackgroundFromWrapper()
	end

	local assetId = fFlagPPVEnable3DBackground and (v7 and v7.assetId or -1) or nil
	local v9 = fFlagProfilePlatformEnableAvatarBackground and v8 ~= nil
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.25, 0.75),
		NumberSequenceKeypoint.new(0.55, 0.4),
		NumberSequenceKeypoint.new(0.8, 0.15),
		NumberSequenceKeypoint.new(1, 0)
	})

	local v10 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
	local v11

	if fFlagProfilePlatformNewProfileHeader and props.height then
		v11 = props.height
	else
		v11 = Constants.USER_PROFILE_HEADER_HEIGHT
	end

	local v12 = (not fFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
		and 0
		or math.floor(v11 * Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO / (Constants.ME_TAB_MOBILE_AVATAR_HEIGHT_ASPECT + Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO))

	local v13 = (not fFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
		and 0
		or math.floor(v11 * Constants.ME_TAB_MOBILE_AVATAR_OFFSET_Y_RATIO)
	local v14

	if
		fFlagProfilePlatformMeTabMobileProfileHero
		and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
	then
		v14 = v11 - v12 + Constants.ME_TAB_MOBILE_AVATAR_EXTRA_HEIGHT
	else
		v14 = v11 - v12
	end

	local v15 = (not fFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
		and 0
		or Constants.ME_TAB_MOBILE_AVATAR_DOWN_OFFSET - v13
	local v16

	if not fFlagPPVEnable3DBackground then
		if fFlagProfilePlatformEnableAvatarBackground and v8 ~= nil then
			local v17 = (not fFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
				and 1.35
				or Constants.ME_TAB_MOBILE_BACKGROUND_SCALE_X

			local v18 = (not fFlagProfilePlatformMeTabMobileProfileHero or props.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile)
				and 1.35
				or Constants.ME_TAB_MOBILE_BACKGROUND_SCALE_Y
			local vector2

			if
				fFlagProfilePlatformMeTabMobileProfileHero
				and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
			then
				vector2 = Vector2.new(0.5, 0)
			else
				vector2 = Vector2.new(0.5, 0.5)
			end

			local v19

			if
				fFlagProfilePlatformMeTabMobileProfileHero
				and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
			then
				v19 = UDim2.fromScale(0.5, Constants.ME_TAB_MOBILE_BACKGROUND_OFFSET_Y_RATIO)
			else
				v19 = UDim2.fromScale(0.5, 0.4)
			end

			v16 = React.createElement(image, {
				Size = UDim2.fromScale(v17, v18),
				AnchorPoint = vector2,
				Position = v19,
				Image = v8,
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 1
			})
		else
			local createElement = React.createElement
			local v18 = {
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				Image = images[v5.Theme.PlayerBackgroundDefault.Image],
				ImageColor3 = 0,
				ZIndex = 1
			}
			local v19 = if v6 and v6.HasSurfaceOverrides then v5.Theme.BackgroundUIDefault.Color:Lerp(
				v5.Theme.PlayerBackgroundDefault.Color,
				v5.Theme.Overlay.Transparency
			) else nil
			v18.ImageColor3 = v19
			v16 = createElement(imageSetLabel, v18)
		end
	end

	local createElement = React.createElement
	local v17 = if fFlagProfilePlatformNewProfileHeader then view else React.Fragment
	local v19 = if fFlagProfilePlatformNewProfileHeader then UDim2.new(1, 0, 0, v11) else nil
	local v18 = {
		Size = v19,
		ClipsDescendants = fFlagProfilePlatformMeTabMobileProfileHero and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile and true or nil
	}
	local v21

	if
		fFlagProfilePlatformMeTabMobileProfileHero
		and props.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile
	then
		local createElement2 = React.createElement
		local v23 = {
			Size = UDim2.new(1, 0, 0, v14),
			Position = UDim2.new(0, 0, 1, v15),
			AnchorPoint = Vector2.new(0, 1),
			ZIndex = 2
		}

		local createElement3 = React.createElement
		local v26 = {
			height = v14,
			currentBackgroundId = assetId,
			userId = props.userId,
			userThumbnail = 0,
			cameraDistanceScale = 0
		}
		local v27 = if fFlagPPVBackgroundUse2DAsLoadingState then props.userThumbnail else nil
		v26.userThumbnail = v27
		v26.cameraDistanceScale = Constants.ME_TAB_MOBILE_CAMERA_DISTANCE_SCALE
		v21 = createElement2(view, v23, {
			DisplayBackground = createElement3(displayBackground, v26)
		})
	else
		local createElement2 = React.createElement
		local v23 = {
			height = v11,
			currentBackgroundId = assetId,
			userId = props.userId,
			userThumbnail = 0
		}
		local v24 = if fFlagPPVBackgroundUse2DAsLoadingState then props.userThumbnail else nil
		v23.userThumbnail = v24
		v21 = createElement2(displayBackground, v23)
	end

	local v22 = if not (fFlagPPVEnable3DBackground or fFlagProfilePlatformEnableAvatarBackground and v9 or fFlagProfilePlatformNewProfileHeader) then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT),
		Position = UDim2.fromScale(0, 0),
		BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		ZIndex = 3
	}, {
		UIGradient = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
		})
	}) else nil
	local v23

	if not (fFlagProfilePlatformEnableAvatarBackground and v9) then
		local createElement2 = React.createElement

		local v26 = if fFlagProfilePlatformNewProfileHeader then UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT) else UDim2.new(1, 0, 0, v11 / 2)
		local v25 = {
			Size = v26,
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 3
		}

		local createElement3 = React.createElement

		if fFlagPPVEnable3DBackground then
			v10 = numberSequence
		end

		v23 = createElement2("Frame", v25, {
			UIGradient = createElement3("UIGradient", {
				Rotation = 90,
				Transparency = v10
			})
		})
	end

	local v24 = if fFlagProfilePlatformNewProfileHeader and props.isPeekView then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, 8)
	}) else nil
	return createElement(v17, v18, {
		Background = v16,
		AvatarThumbnail = v21,
		TopGradient = v22,
		BottomGradient = v23,
		CornerRadius = v24
	})
end

return UserProfileAvatar
