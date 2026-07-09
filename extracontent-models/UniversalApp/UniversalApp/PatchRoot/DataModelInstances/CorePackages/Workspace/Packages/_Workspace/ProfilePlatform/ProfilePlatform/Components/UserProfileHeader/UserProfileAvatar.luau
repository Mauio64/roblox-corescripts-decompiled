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
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagPPVBackgroundUse2DAsLoadingState = require(ProfilePlatformParent.SharedFlags).FFlagPPVBackgroundUse2DAsLoadingState
local FFlagPPVEnable3DBackground = require(ProfilePlatformParent.SharedFlags).FFlagPPVEnable3DBackground
local FFlagProfilePlatformEnableAvatarBackground = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableAvatarBackground

local function UserProfileAvatar(t1: {[any]: any}) -- line: 36
	-- upvalues: useStyle (copy), useStyleMetadata (copy), useProfileJsonComponent (copy), Enums (copy), FFlagPPVEnable3DBackground (copy), FFlagProfilePlatformEnableAvatarBackground (copy), useAvatarBackgroundFromWrapper (copy), FFlagProfilePlatformNewProfileHeader (copy), Constants (copy), React (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy), View (copy), DisplayBackground (copy), FFlagPPVBackgroundUse2DAsLoadingState (copy)
	local v23 = useStyle()
	local v24 = useStyleMetadata()
	local v25 = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local v26 = if FFlagPPVEnable3DBackground or not FFlagProfilePlatformEnableAvatarBackground then nil else useAvatarBackgroundFromWrapper()
	local v27 = if not FFlagPPVEnable3DBackground then nil else v25 and v25.assetId or -1
	local v28 = FFlagProfilePlatformEnableAvatarBackground and v26 ~= nil
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
	local v31 = if not FFlagProfilePlatformNewProfileHeader or not t1.height then Constants.USER_PROFILE_HEADER_HEIGHT else t1.height
	local v32 = if not FFlagPPVEnable3DBackground then if not FFlagProfilePlatformEnableAvatarBackground or v26 == nil then React.createElement(ImageSetLabel, {
		BorderSizePixel = 0,
		ZIndex = 1,
		Size = UDim2.fromScale(1, 1),
		Image = Images[v23.Theme.PlayerBackgroundDefault.Image],
		ImageColor3 = if not v24 or not v24.HasSurfaceOverrides then nil else v23.Theme.BackgroundUIDefault.Color:Lerp(v23.Theme.PlayerBackgroundDefault.Color, v23.Theme.Overlay.Transparency)
	}) else React.createElement(FoundationImage, {
		ZIndex = 1,
		Size = UDim2.fromScale(1.35, 1.35),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.4),
		Image = v26,
		ScaleType = Enum.ScaleType.Crop
	}) else nil

	return React.createElement(if not FFlagProfilePlatformNewProfileHeader then React.Fragment else View, {
		Size = if not FFlagProfilePlatformNewProfileHeader then nil else UDim2.new(1, 0, 0, v31)
	}, {
		Background = v32,
		AvatarThumbnail = React.createElement(DisplayBackground, {
			height = v31,
			currentBackgroundId = v27,
			userId = t1.userId,
			userThumbnail = if not FFlagPPVBackgroundUse2DAsLoadingState then nil else t1.userThumbnail
		}),
		TopGradient = if not FFlagPPVEnable3DBackground and (not (not not FFlagProfilePlatformEnableAvatarBackground and v28) and not FFlagProfilePlatformNewProfileHeader) then React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			Size = UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = v23.Theme.BackgroundDefault.Color
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}) else nil,
		BottomGradient = if not FFlagProfilePlatformEnableAvatarBackground or not v28 then React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			Size = if not FFlagProfilePlatformNewProfileHeader then UDim2.new(1, 0, 0, v31 / 2) else UDim2.new(1, 0, 0, Constants.USER_PROFILE_GRADIENT_HEIGHT),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v23.Theme.BackgroundDefault.Color
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
