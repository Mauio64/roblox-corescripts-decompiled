local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local UIBlox = require(ProfilePlatformParent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local React = require(ProfilePlatformParent.React)
local useStyle = UIBlox.Core.Style.useStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local Constants = require(ProfilePlatform.Common.Constants)
local DisplayBackground = require(ProfilePlatformParent.EditProfileBackground).DisplayBackground
local Enums = require(ProfilePlatform.Common.Enums)
local useAvatarBackgroundFromWrapper = require(ProfilePlatform.Hooks.useAvatarBackgroundFromWrapper)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local FFlagProfilePlatformMeTabMobileProfileHero = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformMeTabMobileProfileHero
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagPPVBackgroundUse2DAsLoadingState = require(ProfilePlatformParent.SharedFlags).FFlagPPVBackgroundUse2DAsLoadingState
local FFlagPPVEnable3DBackground = require(ProfilePlatformParent.SharedFlags).FFlagPPVEnable3DBackground
local FFlagProfilePlatformEnableAvatarBackground = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableAvatarBackground

local function UserProfileAvatar(t1: {[any]: any}) -- line: 39
	-- upvalues: useStyle (copy), useStyleMetadata (copy), useProfileJsonComponent (copy), Enums (copy), FFlagPPVEnable3DBackground (copy), FFlagProfilePlatformEnableAvatarBackground (copy), useAvatarBackgroundFromWrapper (copy), FFlagProfilePlatformNewProfileHeader (copy), Constants (copy), FFlagProfilePlatformMeTabMobileProfileHero (copy), React (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), View (copy), DisplayBackground (copy), FFlagPPVBackgroundUse2DAsLoadingState (copy)
	local v24 = useStyle()
	local v25 = useStyleMetadata()
	local v26 = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local v27 = if FFlagPPVEnable3DBackground or not FFlagProfilePlatformEnableAvatarBackground then nil else useAvatarBackgroundFromWrapper()
	local v28 = if not FFlagPPVEnable3DBackground then nil else v26 and v26.assetId or -1
	local v29 = FFlagProfilePlatformEnableAvatarBackground and v27 ~= nil
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.25, 0.75),
		NumberSequenceKeypoint.new(0.55, 0.4),
		NumberSequenceKeypoint.new(0.8, 0.15),
		NumberSequenceKeypoint.new(1, 0)
	})
	local numberSequence2 = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	})
	local v32 = if not FFlagProfilePlatformNewProfileHeader or not t1.height then Constants.USER_PROFILE_HEADER_HEIGHT else t1.height
	local v33 = (not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile) and 0 or math.floor(v32 * Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO / (Constants.ME_TAB_MOBILE_AVATAR_HEIGHT_ASPECT + Constants.ME_TAB_MOBILE_TOP_BACKGROUND_INSET_RATIO))
	local v34 = (not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile) and 0 or math.floor(v32 * Constants.ME_TAB_MOBILE_AVATAR_OFFSET_Y_RATIO)
	local v35 = if not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile then v32 - v33 else v32 - v33 + Constants.ME_TAB_MOBILE_AVATAR_EXTRA_HEIGHT
	local v36 = (not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile) and 0 or Constants.ME_TAB_MOBILE_AVATAR_DOWN_OFFSET - v34
	local v37

	if FFlagPPVEnable3DBackground then
		v37 = nil
	elseif FFlagProfilePlatformEnableAvatarBackground and v27 ~= nil then
		local v38 = (not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile) and 1.35 or Constants.ME_TAB_MOBILE_BACKGROUND_SCALE_X
		local v39 = (not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile) and 1.35 or Constants.ME_TAB_MOBILE_BACKGROUND_SCALE_Y
		local v40 = if not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile then Vector2.new(0.5, 0.5) else Vector2.new(0.5, 0)
		local v41 = if not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile then UDim2.fromScale(0.5, 0.4) else UDim2.fromScale(0.5, Constants.ME_TAB_MOBILE_BACKGROUND_OFFSET_Y_RATIO)

		v37 = React.createElement(FoundationImage, {
			ZIndex = 1,
			Size = UDim2.fromScale(v38, v39),
			AnchorPoint = v40,
			Position = v41,
			Image = v27,
			ScaleType = Enum.ScaleType.Crop
		})
	else
		v37 = React.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			Image = Images[v24.Theme.PlayerBackgroundDefault.Image],
			ImageColor3 = if not v25 or not v25.HasSurfaceOverrides then nil else v24.Theme.BackgroundUIDefault.Color:Lerp(v24.Theme.PlayerBackgroundDefault.Color, v24.Theme.Overlay.Transparency)
		})
	end

	return React.createElement(if not FFlagProfilePlatformNewProfileHeader then React.Fragment else View, {
		Size = if not FFlagProfilePlatformNewProfileHeader then nil else UDim2.new(1, 0, 0, v32),
		ClipsDescendants = FFlagProfilePlatformMeTabMobileProfileHero and t1.layoutVariant == Enums.ProfileAvatarLayoutVariant.MeTabMobile or nil
	}, {
		Background = v37,
		AvatarThumbnail = if not FFlagProfilePlatformMeTabMobileProfileHero or t1.layoutVariant ~= Enums.ProfileAvatarLayoutVariant.MeTabMobile then React.createElement(DisplayBackground, {
			height = v32,
			currentBackgroundId = v28,
			userId = t1.userId,
			userThumbnail = if not FFlagPPVBackgroundUse2DAsLoadingState then nil else t1.userThumbnail
		}) else React.createElement(View, {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, v35),
			Position = UDim2.new(0, 0, 1, v36),
			AnchorPoint = Vector2.new(0, 1)
		}, {
			DisplayBackground = React.createElement(DisplayBackground, {
				height = v35,
				currentBackgroundId = v28,
				userId = t1.userId,
				userThumbnail = if not FFlagPPVBackgroundUse2DAsLoadingState then nil else t1.userThumbnail,
				cameraDistanceScale = Constants.ME_TAB_MOBILE_CAMERA_DISTANCE_SCALE
			})
		}),
		TopGradient = if not FFlagPPVEnable3DBackground and (not (not not FFlagProfilePlatformEnableAvatarBackground and v29) and not FFlagProfilePlatformNewProfileHeader) then React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = v24.Theme.BackgroundDefault.Color
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}) else nil,
		BottomGradient = if not FFlagProfilePlatformEnableAvatarBackground or not v29 then React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			Size = if not FFlagProfilePlatformNewProfileHeader then UDim2.new(1, 0, 0, v32 / 2) else UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v24.Theme.BackgroundDefault.Color
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = if not FFlagPPVEnable3DBackground then numberSequence2 else numberSequence
			})
		}) else nil,
		CornerRadius = if not FFlagProfilePlatformNewProfileHeader or not t1.isPeekView then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		})
	})
end

return UserProfileAvatar
