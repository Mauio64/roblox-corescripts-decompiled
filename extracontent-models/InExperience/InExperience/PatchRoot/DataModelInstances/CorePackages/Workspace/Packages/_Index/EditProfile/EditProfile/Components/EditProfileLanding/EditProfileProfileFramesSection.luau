local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local BadgeShape = Foundation.Enums.BadgeShape
local BadgeVariant = Foundation.Enums.BadgeVariant
local Badge = Foundation.Badge
local List = Foundation.List
local View = Foundation.View

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AvatarExperienceProfilePictureEditor = require(parent.AvatarExperienceProfilePictureEditor)
local ProfileFramePreviewThumbnail = AvatarExperienceProfilePictureEditor.ProfileFramePreviewThumbnail
local useUserAvatarConfigurations = AvatarExperienceProfilePictureEditor.useUserAvatarConfigurations

local useProfileFramesNewLabel = require(EditProfile.Hooks.useProfileFramesNewLabel)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagProfileFramesNewLabelEnabled = require(EditProfile.Flags.FFlagProfileFramesNewLabelEnabled)

local v = {
	isContained = true,
	hasDivider = { hasDivider = true, isInset = false }
}

local function EditProfileProfileFramesSection(props)
	local v2 = useLocalization({
		ProfileFrameLabel = TextKeys.ProfileFrame,
		NewLabel = TextKeys.New
	})

	local _, frameAssetId, v3 = useUserAvatarConfigurations(props.userId)
	local v4, v5 = useProfileFramesNewLabel()

	local function onActivated()
		if FFlagProfileFramesNewLabelEnabled then
			v5()
		end

		props.onActivated()
	end

	local createElement = React.createElement
	local root = List.Root
	local v6 = {
		testId = "ProfileFramesList",
		LayoutOrder = props.layoutOrder,
		isContained = v.isContained,
		hasDivider = v.hasDivider
	}

	local createElement2 = React.createElement
	local item = List.Item
	local v7 = {
		testId = "ProfileFramesRow",
		title = v2.ProfileFrameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 1
	}
	local createElement3 = React.createElement
	local newLabel

	if FFlagProfileFramesNewLabelEnabled and v4 then
		newLabel = React.createElement(Badge, {
			text = v2.NewLabel,
			variant = BadgeVariant.Contrast,
			shape = BadgeShape.Box
		})
	end

	local profileFramePreview

	if not (FFlagProfileFramesNewLabelEnabled and v4) then
		profileFramePreview = React.createElement(ProfileFramePreviewThumbnail, {
			frameAssetId = frameAssetId,
			isLoading = v3 == true
		})
	end

	v7.trailing = createElement3(View, { tag = "row align-y-center gap-small auto-xy" }, {
		NewLabel = newLabel,
		ProfileFramePreview = profileFramePreview
	})

	v7.onActivated = not v3 and { onActivated = onActivated } or nil
	return createElement(root, v6, { ProfileFramesRow = createElement2(item, v7) })
end

return EditProfileProfileFramesSection
