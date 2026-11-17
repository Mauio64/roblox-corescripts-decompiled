local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconButton = Foundation.IconButton
local View = Foundation.View

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth = ProfilePlatformCommon.Hooks.useProfileCardWidth
local UserTile = require(parent.UserTile)

local EditComponentRow = require(EditProfile.BaseComponents.EditComponentRow)
local EditProfileHeaderBar = require(EditProfile.BaseComponents.EditProfileHeaderBar)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagEditProfileAlignBioTranslationKeys = require(EditProfile.Flags.FFlagEditProfileAlignBioTranslationKeys)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSplitPaneFullBleedEditProfile = SharedFlags2.FFlagSplitPaneFullBleedEditProfile

local function EditProfileLanding(props)
	local v = useProfileCardWidth()
	local sizefullfull = (FFlagAXEnableProfileTab or FFlagSplitPaneFullBleedEditProfile) and props.fullBleed == true
	local displayNameLabel

	if props.isPolicyEnabled then
		displayNameLabel = TextKeys.AgedUpDisplayName
	else
		displayNameLabel = TextKeys.DisplayName
	end

	local v2 = {
		TopBarTitle = TextKeys.Title,
		UsernameLabel = TextKeys.Username,
		DisplayNameLabel = displayNameLabel,
		BioLabel = 0,
		BioPlaceholder = 0
	}
	local bioLabel

	if FFlagEditProfileAlignBioTranslationKeys then
		bioLabel = TextKeys.Bio
	else
		bioLabel = TextKeys.About
	end

	v2.BioLabel = bioLabel
	v2.BioPlaceholder = TextKeys.AboutPlaceholder
	local v3 = useLocalization(v2)

	local createElement = React.createElement
	local v4 = {
		tag = (FFlagAXEnableProfileTab or FFlagSplitPaneFullBleedEditProfile) and {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not sizefullfull,
			["size-full-full"] = sizefullfull
		} or "col items-start position-top-right anchor-top-right bg-surface-0",
		Size = 0
	}
	local size

	if not sizefullfull then
		size = UDim2.new(0, v, 1, 0)
	end

	v4.Size = size
	local v5 = {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v3.TopBarTitle
		}),
		EditableComponents = 0
	}

	local createElement2 = React.createElement

	local v6 = {
		AvatarEditRow = React.createElement(View, { tag = "size-full-2400", LayoutOrder = 1 }, {
			AvatarContainer = React.createElement(
				View,
				{ tag = "size-2400-2400 position-center-center anchor-center-center" },
				{
					AvatarHeadshot = React.createElement(View, { tag = "size-full-full" }, {
						UserTile = React.createElement(UserTile.UserTile, {
							userId = props.userId,
							layoutMode = UserTile.LayoutMode.compact,
							onActivated = props.settingButtonOnActivated.avatar
						})
					}),
					EditAvatarIconButton = React.createElement(
						View,
						{
							tag = "position-bottom-right anchor-bottom-right auto-xy bg-over-media-0 radius-circle"
						},
						{
							IconButton = React.createElement(IconButton, {
								icon = IconName.PhotoCamera,
								size = IconSize.Small,
								onActivated = props.settingButtonOnActivated.avatar,
								isCircular = true,
								variant = ButtonVariant.Standard
							})
						}
					)
				}
			)
		}),
		TextComponentsList = 0
	}

	local createElement3 = React.createElement

	local v7 = {
		EditDisplayNameRow = React.createElement(EditComponentRow, {
			label = v3.DisplayNameLabel,
			currentValue = props.displayName,
			onActivated = props.areNamesLoading and function() end or props.settingButtonOnActivated.displayName,
			layoutOrder = 1,
			shouldShimmer = props.areNamesLoading,
			forwardRef = props.firstItemRef
		}),
		UsernameEditRow = React.createElement(EditComponentRow, {
			label = v3.UsernameLabel,
			currentValue = props.username,
			onActivated = props.settingButtonOnActivated.username,
			layoutOrder = 2,
			shouldShimmer = props.areNamesLoading
		}),
		BioEditRow = 0
	}

	local createElement4 = React.createElement
	local v8 = {
		label = v3.BioLabel,
		currentValue = 0,
		onActivated = 0,
		layoutOrder = 3,
		shouldShimmer = 0
	}
	local currentValue

	if props.bioText == "" or props.bioText == nil then
		currentValue = v3.BioPlaceholder
	else
		currentValue = props.bioText
	end

	v8.currentValue = currentValue

	v8.onActivated = props.settingButtonOnActivated.bio

	v8.shouldShimmer = props.isBioLoading
	v7.BioEditRow = createElement4(EditComponentRow, v8)
	v6.TextComponentsList = createElement3(
		View,
		{ tag = "col size-full-0 auto-y bg-surface-100 radius-medium", LayoutOrder = 2 },
		v7
	)
	v5.EditableComponents = createElement2(View, {
		tag = "col padding-xlarge gap-xxlarge size-full-0 auto-y"
	}, v6)
	return createElement(View, v4, v5)
end

return EditProfileLanding
