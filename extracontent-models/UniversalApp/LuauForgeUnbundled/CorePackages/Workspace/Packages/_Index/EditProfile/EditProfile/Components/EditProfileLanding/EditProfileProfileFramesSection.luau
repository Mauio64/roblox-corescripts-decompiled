local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local badgeShape = Foundation.Enums.BadgeShape
local badgeVariant = Foundation.Enums.BadgeVariant
local badge = Foundation.Badge
local list = Foundation.List
local view = Foundation.View

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local AvatarExperienceProfilePictureEditor = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/AvatarExperienceProfilePictureEditor")
local profileFramePreviewThumbnail = AvatarExperienceProfilePictureEditor.ProfileFramePreviewThumbnail
local useUserAvatarConfigurations = AvatarExperienceProfilePictureEditor.useUserAvatarConfigurations

local useProfileFramesNewLabel = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useProfileFramesNewLabel")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local FFlagProfileFramesNewLabelEnabled = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagProfileFramesNewLabelEnabled")

local v5 = {
	isContained = true,
	hasDivider = { hasDivider = true, isInset = false }
}

local function EditProfileProfileFramesSection(props)
	local v6 = useLocalization({
		ProfileFrameLabel = TextKeys.ProfileFrame,
		NewLabel = TextKeys.New
	})

	local v7, v8, v9 = useUserAvatarConfigurations(props.userId)
	local v10, v11 = useProfileFramesNewLabel()

	local function onActivated()
		if FFlagProfileFramesNewLabelEnabled then
			v11()
		end

		props.onActivated()
	end

	local createElement = React.createElement
	local root = list.Root
	local v12 = {
		testId = "ProfileFramesList",
		LayoutOrder = props.layoutOrder,
		isContained = v5.isContained,
		hasDivider = v5.hasDivider
	}

	local createElement2 = React.createElement
	local item = list.Item
	local v14 = {
		testId = "ProfileFramesRow",
		title = v6.ProfileFrameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 1
	}
	local createElement3 = React.createElement

	local v18 = if FFlagProfileFramesNewLabelEnabled and v10 then React.createElement(badge, {
		text = v6.NewLabel,
		variant = badgeVariant.Contrast,
		shape = badgeShape.Box
	}) else nil

	local v19 = if not (FFlagProfileFramesNewLabelEnabled and v10) then React.createElement(profileFramePreviewThumbnail, {
		frameAssetId = v8,
		isLoading = v9 == true
	}) else nil
	v14.trailing = createElement3(view, { tag = "row align-y-center gap-small auto-xy" }, {
		NewLabel = v18,
		ProfileFramePreview = v19
	})

	v14.onActivated = not v9 and { onActivated = onActivated } or nil
	return createElement(root, v12, { ProfileFramesRow = createElement2(item, v14) })
end

return EditProfileProfileFramesSection
