local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local IconButton = Foundation.IconButton
local List = Foundation.List
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth = ProfilePlatformCommon.Hooks.useProfileCardWidth
local UserTile = require(parent.UserTile)

local EditProfileHeaderBar = require(EditProfile.BaseComponents.EditProfileHeaderBar)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagEditProfileAlignBioTranslationKeys = require(EditProfile.Flags.FFlagEditProfileAlignBioTranslationKeys)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSplitPaneFullBleedEditProfile = SharedFlags2.FFlagSplitPaneFullBleedEditProfile
local FFlagFixNonTruncatedText = require(EditProfile.Flags.FFlagFixNonTruncatedText)
local SharedFlags3 = require(parent.SharedFlags)
local EditProfileProfileFramesSection

if SharedFlags3.FFlagEditProfileFramesEnabled then
	EditProfileProfileFramesSection = require(EditProfile.Components.EditProfileLanding.EditProfileProfileFramesSection)
else
	EditProfileProfileFramesSection = nil
end

local v = tonumber(game:DefineFastString("EditProfileLandingTrailingWidthRatio", "0.4")) or 0.4

local v2 = {
	isContained = true,
	hasDivider = { hasDivider = true, isInset = false }
}

local function renderRowTrailing(flag: boolean, text: string, size_400: number, p: number?)
	if flag then
		return React.createElement(Skeleton, {
			Size = UDim2.new(0.3, 0, 0, size_400),
			radius = Radius.Medium
		})
	end

	if FFlagFixNonTruncatedText and p ~= nil then
		return React.createElement(Text, {
			tag = "auto-y text-body-small text-align-x-right text-truncate-end",
			Text = text,
			Size = UDim2.new(0, p * v, 0, 0)
		})
	end

	return React.createElement(Text, {
		tag = "auto-xy text-body-small text-truncate-end",
		Text = text
	})
end

local function EditProfileLandingV2(props)
	local v3 = useProfileCardWidth()
	local v4 = useTokens()
	local sizefullfull = (FFlagAXEnableProfileTab or FFlagSplitPaneFullBleedEditProfile) and props.fullBleed == true
	local displayNameLabel

	if props.isPolicyEnabled then
		displayNameLabel = TextKeys.AgedUpDisplayName
	else
		displayNameLabel = TextKeys.DisplayName
	end

	local v5 = {
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

	v5.BioLabel = bioLabel
	v5.BioPlaceholder = TextKeys.AboutPlaceholder
	local v6 = useLocalization(v5)
	local v7

	if props.bioText == "" or props.bioText == nil then
		v7 = v6.BioPlaceholder
	else
		v7 = string.gsub(props.bioText, "\n", " ")
	end

	local size_400 = v4.Size.Size_400

	local createElement = React.createElement
	local v8 = {
		tag = (FFlagAXEnableProfileTab or FFlagSplitPaneFullBleedEditProfile) and {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not sizefullfull,
			["size-full-full"] = sizefullfull
		} or "col items-start position-top-right anchor-top-right bg-surface-0",
		Size = 0
	}
	local size

	if not sizefullfull then
		size = UDim2.new(0, v3, 1, 0)
	end

	v8.Size = size
	local v9 = {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v6.TopBarTitle
		}),
		EditableComponents = 0
	}

	local createElement2 = React.createElement

	local v10 = {
		AvatarEditRow = React.createElement(View, { tag = "size-full-2400", LayoutOrder = 1 }, {
			AvatarContainer = React.createElement(
				View,
				{ tag = "position-center-center anchor-center-center size-2400-2400" },
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
							tag = "position-bottom-right anchor-bottom-right auto-xy radius-circle bg-over-media-0"
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
		TextComponentsList = 0,
		ProfileFramesList = 0
	}

	local createElement3 = React.createElement
	local root = List.Root
	local v11 = {
		testId = "TextComponentsList",
		LayoutOrder = 2,
		isContained = v2.isContained,
		hasDivider = v2.hasDivider
	}

	local createElement4 = React.createElement
	local item = List.Item
	local v12 = {
		testId = "EditDisplayNameRow",
		title = v6.DisplayNameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 1,
		ref = 0
	}

	local areNamesLoading = props.areNamesLoading
	local displayName = props.displayName
	local v13

	if FFlagFixNonTruncatedText then
		v13 = v3
	end

	v12.trailing = renderRowTrailing(areNamesLoading, displayName, size_400, v13)

	v12.onActivated = not props.areNamesLoading and {
		onActivated = props.settingButtonOnActivated.displayName
	} or nil

	v12.ref = props.firstItemRef
	local children = {
		EditDisplayNameRow = createElement4(item, v12),
		UsernameEditRow = 0,
		BioEditRow = 0
	}

	local createElement5 = React.createElement
	local item2 = List.Item
	local v14 = {
		testId = "UsernameEditRow",
		title = v6.UsernameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 2
	}

	local areNamesLoading2 = props.areNamesLoading
	local username = props.username
	local v15

	if FFlagFixNonTruncatedText then
		v15 = v3
	end

	v14.trailing = renderRowTrailing(areNamesLoading2, username, size_400, v15)

	v14.onActivated = not props.areNamesLoading and {
		onActivated = props.settingButtonOnActivated.username
	} or nil
	children.UsernameEditRow = createElement5(item2, v14)

	local createElement6 = React.createElement
	local item3 = List.Item
	local v16 = {
		testId = "BioEditRow",
		title = v6.BioLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 3
	}

	local isBioLoading = props.isBioLoading

	if not FFlagFixNonTruncatedText then
		v3 = nil
	end

	v16.trailing = renderRowTrailing(isBioLoading, v7, size_400, v3)

	v16.onActivated = not props.isBioLoading and {
		onActivated = props.settingButtonOnActivated.bio
	} or nil
	children.BioEditRow = createElement6(item3, v16)
	v10.TextComponentsList = createElement3(root, v11, children)
	local profileFramesList

	if EditProfileProfileFramesSection ~= nil then
		profileFramesList = React.createElement(EditProfileProfileFramesSection, {
			userId = props.userId,
			onActivated = props.onProfileFramesActivated,
			layoutOrder = 3
		})
	end

	v10.ProfileFramesList = profileFramesList
	v9.EditableComponents = createElement2(View, {
		tag = "col gap-xxlarge size-full-0 auto-y padding-xlarge"
	}, v10)
	return createElement(View, v8, v9)
end

return EditProfileLandingV2
