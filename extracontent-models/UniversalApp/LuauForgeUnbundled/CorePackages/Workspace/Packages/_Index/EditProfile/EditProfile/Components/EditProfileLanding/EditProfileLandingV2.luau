local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local iconButton = Foundation.IconButton
local list = Foundation.List
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ProfilePlatformCommon").Hooks.useProfileCardWidth
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UserTile")

local EditProfileHeaderBar = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileHeaderBar")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local FFlagEditProfileAlignBioTranslationKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileAlignBioTranslationKeys")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXEnableProfileTab
local fFlagSplitPaneFullBleedEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagSplitPaneFullBleedEditProfile
local FFlagFixNonTruncatedText = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagFixNonTruncatedText")
local v5 = if require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagEditProfileFramesEnabled then require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileLanding/EditProfileProfileFramesSection") else nil

local v6 = tonumber(game:DefineFastString("EditProfileLandingTrailingWidthRatio", "0.4")) or 0.4

local v7 = {
	isContained = true,
	hasDivider = { hasDivider = true, isInset = false }
}

local function renderRowTrailing(p2, p3, p4, p5)
	if p2 then
		return React.createElement(skeleton, {
			Size = UDim2.new(0.3, 0, 0, p4),
			radius = radius.Medium
		})
	end

	if FFlagFixNonTruncatedText and p5 ~= nil then
		return React.createElement(text, {
			tag = "auto-y text-body-small text-align-x-right text-truncate-end",
			Text = p3,
			Size = UDim2.new(0, p5 * v6, 0, 0)
		})
	end

	return React.createElement(text, {
		tag = "auto-xy text-body-small text-truncate-end",
		Text = p3
	})
end

local function EditProfileLandingV2(props)
	local v8 = useProfileCardWidth()
	local v9 = useTokens()
	local v10 = (fFlagAXEnableProfileTab or fFlagSplitPaneFullBleedEditProfile) and props.fullBleed == true

	local v11 = if props.isPolicyEnabled then TextKeys.AgedUpDisplayName else TextKeys.DisplayName

	local v13 = {
		TopBarTitle = TextKeys.Title,
		UsernameLabel = TextKeys.Username,
		DisplayNameLabel = v11,
		BioLabel = 0,
		BioPlaceholder = 0
	}

	local v14 = if FFlagEditProfileAlignBioTranslationKeys then TextKeys.Bio else TextKeys.About
	v13.BioLabel = v14
	v13.BioPlaceholder = TextKeys.AboutPlaceholder
	local v15 = useLocalization(v13)
	local v16

	if props.bioText == "" or props.bioText == nil then
		v16 = v15.BioPlaceholder
	else
		v16 = string.gsub(props.bioText, "\n", " ")
	end

	local size_400 = v9.Size.Size_400

	local createElement = React.createElement
	local v18 = {
		tag = (fFlagAXEnableProfileTab or fFlagSplitPaneFullBleedEditProfile) and {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not v10,
			["size-full-full"] = v10
		} or "col items-start position-top-right anchor-top-right bg-surface-0",
		Size = 0
	}

	local v19 = if not v10 then UDim2.new(0, v8, 1, 0) else nil
	v18.Size = v19
	local v20 = {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v15.TopBarTitle
		}),
		EditableComponents = 0
	}

	local createElement2 = React.createElement

	local v23 = {
		AvatarEditRow = React.createElement(view, {
			tag = "size-full-2400",
			LayoutOrder = 1
		}, {
			AvatarContainer = React.createElement(
				view,
				{ tag = "position-center-center anchor-center-center size-2400-2400" },
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
							tag = "position-bottom-right anchor-bottom-right auto-xy radius-circle bg-over-media-0"
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
		TextComponentsList = 0,
		ProfileFramesList = 0
	}

	local createElement3 = React.createElement
	local root = list.Root
	local v24 = {
		testId = "TextComponentsList",
		LayoutOrder = 2,
		isContained = v7.isContained,
		hasDivider = v7.hasDivider
	}

	local createElement4 = React.createElement
	local item = list.Item
	local v25 = {
		testId = "EditDisplayNameRow",
		title = v15.DisplayNameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 1,
		ref = 0
	}

	local areNamesLoading = props.areNamesLoading
	local displayName = props.displayName
	local v27 = if FFlagFixNonTruncatedText then v8 else nil
	v25.trailing = renderRowTrailing(areNamesLoading, displayName, size_400, v27)

	v25.onActivated = not props.areNamesLoading
		and { onActivated = props.settingButtonOnActivated.displayName }
		or nil

	v25.ref = props.firstItemRef
	local children = {
		EditDisplayNameRow = createElement4(item, v25),
		UsernameEditRow = 0,
		BioEditRow = 0
	}

	local createElement5 = React.createElement
	local item2 = list.Item
	local v28 = {
		testId = "UsernameEditRow",
		title = v15.UsernameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 2
	}

	local areNamesLoading2 = props.areNamesLoading
	local username = props.username
	local v30 = if FFlagFixNonTruncatedText then v8 else nil
	v28.trailing = renderRowTrailing(areNamesLoading2, username, size_400, v30)

	v28.onActivated = not props.areNamesLoading
		and { onActivated = props.settingButtonOnActivated.username }
		or nil
	children.UsernameEditRow = createElement5(item2, v28)

	local createElement6 = React.createElement
	local item3 = list.Item
	local v31 = {
		testId = "BioEditRow",
		title = v15.BioLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 3
	}

	local isBioLoading = props.isBioLoading

	if not FFlagFixNonTruncatedText then
		v8 = nil
	end

	v31.trailing = renderRowTrailing(isBioLoading, v16, size_400, v8)

	v31.onActivated = not props.isBioLoading and {
		onActivated = props.settingButtonOnActivated.bio
	} or nil
	children.BioEditRow = createElement6(item3, v31)
	v23.TextComponentsList = createElement3(root, v24, children)

	local v33 = if v5 ~= nil then React.createElement(v5, {
		userId = props.userId,
		onActivated = props.onProfileFramesActivated,
		layoutOrder = 3
	}) else nil
	v23.ProfileFramesList = v33
	v20.EditableComponents = createElement2(
		view,
		{ tag = "col gap-xxlarge size-full-0 auto-y padding-xlarge" },
		v23
	)
	return createElement(view, v18, v20)
end

return EditProfileLandingV2
