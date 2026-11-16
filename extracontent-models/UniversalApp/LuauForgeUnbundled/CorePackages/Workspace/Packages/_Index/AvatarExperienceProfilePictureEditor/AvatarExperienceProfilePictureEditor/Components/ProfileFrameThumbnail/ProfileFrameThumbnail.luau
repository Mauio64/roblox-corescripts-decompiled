local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local view = Foundation.View
local icon = Foundation.Icon
local image = Foundation.Image
local skeleton = Foundation.Skeleton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local mapWidgetContentToFrameItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/mapWidgetContentToFrameItems")

local function ProfileFramePreviewThumbnail(props)
	local v5 = useTokens()
	local previewSize = props.previewSize or v5.Size.Size_800
	local v6

	if props.isLoading then
		v6 = React.createElement(skeleton, {
			Size = UDim2.fromOffset(previewSize, previewSize),
			radius = radius.Medium
		})
	elseif props.frameAssetId == nil then
		v6 = React.createElement(view, { testId = "none-frame-icon", tag = "auto-xy" }, {
			Icon = React.createElement(icon, {
				name = iconName.CircleSlash,
				size = iconSize.Medium
			})
		})
	else
		local profileFramePickerImage = mapWidgetContentToFrameItems.getProfileFramePickerImage(props.frameAssetId)
		v6 = React.createElement(
			view,
			{ testId = "frame-preview-image", tag = "size-full-full padding-xsmall" },
			{
				Image = React.createElement(image, {
					tag = "size-full-full",
					Image = profileFramePickerImage
				})
			}
		)
	end

	return React.createElement(
		view,
		{
			testId = "profile-frame-preview-thumbnail",
			tag = "align-x-center align-y-center radius-medium bg-surface-100",
			Size = UDim2.fromOffset(previewSize, previewSize)
		},
		{ Content = v6 }
	)
end

return ProfileFramePreviewThumbnail
