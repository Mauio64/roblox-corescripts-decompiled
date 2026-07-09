local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local RoactUtils = require(ParentParent.RoactUtils)
local UserLib = require(ParentParent.UserLib)
local Foundation = require(ParentParent.Foundation)
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local UIBlox = require(ParentParent.UIBlox)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local AvatarHeadShot = UserLib.Utils.Constants.RbxthumbTypes.AvatarHeadShot

return function(t1: {[any]: any}) -- line: 37
	-- upvalues: useStyle (copy), useSelector (copy), getDeepValue (copy), React (copy), View (copy), LoadableImage (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), FoundationText (copy), Skeleton (copy)
	local v18 = useStyle()
	local v19 = useSelector(function(p1) -- line: 40
		-- upvalues: getDeepValue (copy), t1 (copy)
		return getDeepValue(p1, "Users.byUserId." .. tostring(t1.creatorUserId) .. ".username")
	end)

	return React.createElement(View, {
		tag = "align-x-left align-y-center auto-y bg-action-subtle gap-small row size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		CreatorThumbnail = React.createElement(LoadableImage, {
			LayoutOrder = 1,
			useShimmerAnimationWhileLoading = true,
			BackgroundColor3 = v18.Theme.PlaceHolder.Color,
			BackgroundTransparency = v18.Theme.PlaceHolder.Transparency,
			cornerRadius = UDim.new(0, 30),
			Image = getRbxthumbWithTypeSizeAndOptions(tostring(t1.creatorUserId), AvatarHeadShot, 150, true),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(30, 30)
		}),
		CreatorUsername = if not v19 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-y content-action-emphasis grow text-align-x-left text-align-y-top text-title-large text-truncate-end",
			ZIndex = 2,
			Text = v19
		}),
		ShimmerPanel = if v19 then nil else React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(160, 16)
		})
	})
end
