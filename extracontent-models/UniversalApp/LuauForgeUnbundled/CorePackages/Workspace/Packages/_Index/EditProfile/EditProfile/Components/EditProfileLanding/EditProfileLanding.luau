local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconButton = Foundation.IconButton
local view = Foundation.View

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ProfilePlatformCommon").Hooks.useProfileCardWidth
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UserTile")

local EditComponentRow = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditComponentRow")
local EditProfileHeaderBar = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileHeaderBar")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local FFlagEditProfileAlignBioTranslationKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileAlignBioTranslationKeys")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXEnableProfileTab
local fFlagSplitPaneFullBleedEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagSplitPaneFullBleedEditProfile

local function EditProfileLanding(props)
	local v5 = useProfileCardWidth()
	local v6 = (fFlagAXEnableProfileTab or fFlagSplitPaneFullBleedEditProfile) and props.fullBleed == true

	local v7 = if props.isPolicyEnabled then TextKeys.AgedUpDisplayName else TextKeys.DisplayName

	local v9 = {
		TopBarTitle = TextKeys.Title,
		UsernameLabel = TextKeys.Username,
		DisplayNameLabel = v7,
		BioLabel = 0,
		BioPlaceholder = 0
	}

	local v10 = if FFlagEditProfileAlignBioTranslationKeys then TextKeys.Bio else TextKeys.About
	v9.BioLabel = v10
	v9.BioPlaceholder = TextKeys.AboutPlaceholder
	local v11 = useLocalization(v9)

	local createElement = React.createElement
	local v13 = {
		tag = (fFlagAXEnableProfileTab or fFlagSplitPaneFullBleedEditProfile) and {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not v6,
			["size-full-full"] = v6
		} or "col items-start position-top-right anchor-top-right bg-surface-0",
		Size = 0
	}

	local v14 = if not v6 then UDim2.new(0, v5, 1, 0) else nil
	v13.Size = v14
	local v15 = {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v11.TopBarTitle
		}),
		EditableComponents = 0
	}

	local createElement2 = React.createElement

	local v18 = {
		AvatarEditRow = React.createElement(view, {
			tag = "size-full-2400",
			LayoutOrder = 1
		}, {
			AvatarContainer = React.createElement(
				view,
				{ tag = "size-2400-2400 position-center-center anchor-center-center" },
				{
					AvatarHeadshot = React.createElement(view, {
						tag = "size-full-full"
					}, {
						UserTile = React.createElement(module3.UserTile, {
							userId = props.userId,
							layoutMode = module3.LayoutMode.compact,
							onActivated = props.settingButtonOnActivated.avatar
						})
					}),
					EditAvatarIconButton = React.createElement(
						view,
						{
							tag = "position-bottom-right anchor-bottom-right auto-xy bg-over-media-0 radius-circle"
						},
						{
							IconButton = React.createElement(iconButton, {
								icon = iconName.PhotoCamera,
								size = iconSize.Small,
								onActivated = props.settingButtonOnActivated.avatar,
								isCircular = true,
								variant = buttonVariant.Standard
							})
						}
					)
				}
			)
		}),
		TextComponentsList = 0
	}

	local createElement3 = React.createElement

	local v21 = {
		EditDisplayNameRow = React.createElement(EditComponentRow, {
			label = v11.DisplayNameLabel,
			currentValue = props.displayName,
			onActivated = props.areNamesLoading and function() end or props.settingButtonOnActivated.displayName,
			layoutOrder = 1,
			shouldShimmer = props.areNamesLoading,
			forwardRef = props.firstItemRef
		}),
		UsernameEditRow = React.createElement(EditComponentRow, {
			label = v11.UsernameLabel,
			currentValue = props.username,
			onActivated = props.settingButtonOnActivated.username,
			layoutOrder = 2,
			shouldShimmer = props.areNamesLoading
		}),
		BioEditRow = 0
	}

	local createElement4 = React.createElement
	local v23 = {
		label = v11.BioLabel,
		currentValue = 0,
		onActivated = 0,
		layoutOrder = 3,
		shouldShimmer = 0
	}
	local v24 = if props.bioText == "" or props.bioText == nil then v11.BioPlaceholder else props.bioText
	v23.currentValue = v24

	v23.onActivated = props.settingButtonOnActivated.bio

	v23.shouldShimmer = props.isBioLoading
	v21.BioEditRow = createElement4(EditComponentRow, v23)
	v18.TextComponentsList = createElement3(
		view,
		{ tag = "col size-full-0 auto-y bg-surface-100 radius-medium", LayoutOrder = 2 },
		v21
	)
	v15.EditableComponents = createElement2(
		view,
		{ tag = "col padding-xlarge gap-xxlarge size-full-0 auto-y" },
		v18
	)
	return createElement(view, v13, v15)
end

return EditProfileLanding
