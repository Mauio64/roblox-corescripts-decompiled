local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent
local React = require(parent.React)
local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local FFlagFlyoutAlternateEntryPointUseProfileFrameThumbnail = require(FlyoutSidePanel.Flags.FFlagFlyoutAlternateEntryPointUseProfileFrameThumbnail)

local function FlyoutAlternateEntryPoint()
	local v = useTokens()
	local v2 = useSelector(function(p)
		return p.Users[p.LocalUserId]
	end)

	local image = React.useMemo(function()
		if v2 and v2.id then
			return getStandardSizeAvatarHeadShotRbxthumb(v2.id, FFlagFlyoutAlternateEntryPointUseProfileFrameThumbnail)
		end

		return nil
	end, { v2 })

	return React.createElement(
		Foundation.Icon,
		{
			tag = "position-center-center anchor-center-center content-emphasis align-y-center",
			name = BuilderIcons.Icon.ThreeHorizontalBarsWrappingRight,
			size = v.Size.Size_800
		},
		{
			UserAvatar = React.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v.Size.Size_50, 0.5, 0),
				Size = UDim2.new(0, v.Size.Size_400, 0, v.Size.Size_400),
				BackgroundColor3 = v.Color.Common.Shimmer.Color3,
				BackgroundTransparency = v.Color.Common.Shimmer.Transparency,
				Image = image,
				useShimmerAnimationWhileLoading = true,
				cornerRadius = UDim.new(0.5, 0),
				shouldHandleReloads = true
			})
		}
	)
end

return FlyoutAlternateEntryPoint
