local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local BuilderIcons = require(Parent.BuilderIcons)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local LoadableImage = require(Parent.UIBlox).App.Loading.LoadableImage
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb

local function FlyoutAlternateEntryPoint() -- line: 14
	-- upvalues: useTokens (copy), useSelector (copy), React (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), Foundation (copy), BuilderIcons (copy), LoadableImage (copy)
	local v10 = useTokens()
	local v11 = useSelector(function(p1) -- line: 16
		return p1.Users[p1.LocalUserId]
	end)
	local v12 = React.useMemo(function() -- line: 19
		-- upvalues: v11 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy)
		if v11 and v11.id then
			return getStandardSizeAvatarHeadShotRbxthumb(v11.id)
		end

		return nil
	end, { v11 })

	return React.createElement(Foundation.Icon, {
		tag = "position-center-center anchor-center-center content-emphasis align-y-center",
		name = BuilderIcons.Icon.ThreeHorizontalBarsWrappingRight,
		size = v10.Size.Size_800
	}, {
		UserAvatar = React.createElement(LoadableImage, {
			useShimmerAnimationWhileLoading = true,
			shouldHandleReloads = true,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v10.Size.Size_50, 0.5, 0),
			Size = UDim2.new(0, v10.Size.Size_400, 0, v10.Size.Size_400),
			BackgroundColor3 = v10.Color.Common.Shimmer.Color3,
			BackgroundTransparency = v10.Color.Common.Shimmer.Transparency,
			Image = v12,
			cornerRadius = UDim.new(0.5, 0)
		})
	})
end

return FlyoutAlternateEntryPoint
