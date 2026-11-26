local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")

local useTokens = Foundation.Hooks.useTokens
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UIBlox").App.Loading.LoadableImage
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useSelector
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb

local FFlagFlyoutAlternateEntryPointUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutAlternateEntryPointUseProfileFrameThumbnail")

local function FlyoutAlternateEntryPoint()
	local v5 = useTokens()
	local v6 = useSelector(function(p2)
		return p2.Users[p2.LocalUserId]
	end)

	local v7 = React.useMemo(function()
		if v6 and v6.id then
			return getStandardSizeAvatarHeadShotRbxthumb(v6.id, FFlagFlyoutAlternateEntryPointUseProfileFrameThumbnail)
		end

		return nil
	end, { v6 })

	return React.createElement(
		Foundation.Icon,
		{
			tag = "position-center-center anchor-center-center content-emphasis align-y-center",
			name = BuilderIcons.Icon.ThreeHorizontalBarsWrappingRight,
			size = v5.Size.Size_800
		},
		{
			UserAvatar = React.createElement(loadableImage, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v5.Size.Size_50, 0.5, 0),
				Size = UDim2.new(0, v5.Size.Size_400, 0, v5.Size.Size_400),
				BackgroundColor3 = v5.Color.Common.Shimmer.Color3,
				BackgroundTransparency = v5.Color.Common.Shimmer.Transparency,
				Image = v7,
				useShimmerAnimationWhileLoading = true,
				cornerRadius = UDim.new(0.5, 0),
				shouldHandleReloads = true
			})
		}
	)
end

return FlyoutAlternateEntryPoint
