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
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagFixNonTruncatedText = require(EditProfile.Flags.FFlagFixNonTruncatedText)
local SharedFlags2 = require(parent.SharedFlags)
local EditProfileProfileFramesSection

if SharedFlags2.FFlagEditProfileFramesEnabled then
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
	local sizefullfull = FFlagAXEnableProfileTab and props.fullBleed == true
	local displayNameLabel

	if props.isPolicyEnabled then
		displayNameLabel = TextKeys.AgedUpDisplayName
	else
		displayNameLabel = TextKeys.DisplayName
	end

	local v5 = useLocalization({
		TopBarTitle = TextKeys.Title,
		UsernameLabel = TextKeys.Username,
		DisplayNameLabel = displayNameLabel,
		BioLabel = TextKeys.About,
		BioPlaceholder = TextKeys.AboutPlaceholder
	})
	local v6

	if props.bioText == "" or props.bioText == nil then
		v6 = v5.BioPlaceholder
	else
		v6 = string.gsub(props.bioText, "\n", " ")
	end

	local size_400 = v4.Size.Size_400

	local createElement = React.createElement
	local v7 = {
		tag = FFlagAXEnableProfileTab and {
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

	v7.Size = size
	local v8 = {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = props.onClose,
			headerText = v5.TopBarTitle
		}),
		EditableComponents = 0
	}

	local createElement2 = React.createElement

	local v9 = {
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
	local v10 = {
		testId = "TextComponentsList",
		LayoutOrder = 2,
		isContained = v2.isContained,
		hasDivider = v2.hasDivider
	}

	local createElement4 = React.createElement
	local item = List.Item
	local v11 = {
		testId = "EditDisplayNameRow",
		title = v5.DisplayNameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 1,
		ref = 0
	}

	local areNamesLoading = props.areNamesLoading
	local displayName = props.displayName
	local v12

	if FFlagFixNonTruncatedText then
		v12 = v3
	end

	v11.trailing = renderRowTrailing(areNamesLoading, displayName, size_400, v12)

	v11.onActivated = not props.areNamesLoading and {
		onActivated = props.settingButtonOnActivated.displayName
	} or nil

	v11.ref = props.firstItemRef
	local children = {
		EditDisplayNameRow = createElement4(item, v11),
		UsernameEditRow = 0,
		BioEditRow = 0
	}

	local createElement5 = React.createElement
	local item2 = List.Item
	local v13 = {
		testId = "UsernameEditRow",
		title = v5.UsernameLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 2
	}

	local areNamesLoading2 = props.areNamesLoading
	local username = props.username
	local v14

	if FFlagFixNonTruncatedText then
		v14 = v3
	end

	v13.trailing = renderRowTrailing(areNamesLoading2, username, size_400, v14)

	v13.onActivated = not props.areNamesLoading and {
		onActivated = props.settingButtonOnActivated.username
	} or nil
	children.UsernameEditRow = createElement5(item2, v13)

	local createElement6 = React.createElement
	local item3 = List.Item
	local v15 = {
		testId = "BioEditRow",
		title = v5.BioLabel,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 3
	}

	local isBioLoading = props.isBioLoading

	if not FFlagFixNonTruncatedText then
		v3 = nil
	end

	v15.trailing = renderRowTrailing(isBioLoading, v6, size_400, v3)

	v15.onActivated = not props.isBioLoading and {
		onActivated = props.settingButtonOnActivated.bio
	} or nil
	children.BioEditRow = createElement6(item3, v15)
	v9.TextComponentsList = createElement3(root, v10, children)
	local profileFramesList

	if EditProfileProfileFramesSection ~= nil then
		profileFramesList = React.createElement(EditProfileProfileFramesSection, {
			userId = props.userId,
			onActivated = props.onProfileFramesActivated,
			layoutOrder = 3
		})
	end

	v9.ProfileFramesList = profileFramesList
	v8.EditableComponents = createElement2(View, {
		tag = "col gap-xxlarge size-full-0 auto-y padding-xlarge"
	}, v9)
	return createElement(View, v7, v8)
end

return EditProfileLandingV2
