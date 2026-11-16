local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Icon = Foundation.Icon
local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local mapWidgetContentToFrameItems = require(AvatarExperienceProfilePictureEditor.Utils.mapWidgetContentToFrameItems)

local function ProfileFramePreviewThumbnail(props)
	local v = useTokens()
	local previewSize = props.previewSize or v.Size.Size_800
	local content

	if props.isLoading then
		content = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(previewSize, previewSize),
			radius = Radius.Medium
		})
	elseif props.frameAssetId == nil then
		content = React.createElement(View, { testId = "none-frame-icon", tag = "auto-xy" }, {
			Icon = React.createElement(Icon, { name = IconName.CircleSlash, size = IconSize.Medium })
		})
	else
		local profileFramePickerImage = mapWidgetContentToFrameItems.getProfileFramePickerImage(props.frameAssetId)
		content = React.createElement(View, {
			testId = "frame-preview-image",
			tag = "size-full-full padding-xsmall"
		}, {
			Image = React.createElement(Image, {
				tag = "size-full-full",
				Image = profileFramePickerImage
			})
		})
	end

	return React.createElement(
		View,
		{
			testId = "profile-frame-preview-thumbnail",
			tag = "align-x-center align-y-center radius-medium bg-surface-100",
			Size = UDim2.fromOffset(previewSize, previewSize)
		},
		{ Content = content }
	)
end

return ProfileFramePreviewThumbnail
