local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local Foundation = require(EditProfileParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local EnumsRadius = Foundation.Enums.Radius
local IconButton = Foundation.IconButton
local List = Foundation.List
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local useProfileCardWidth = require(EditProfileParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local UserTile = require(EditProfileParent.UserTile)
local EditProfileHeaderBar = require(EditProfile.BaseComponents.EditProfileHeaderBar)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab
local t1 = {
	isContained = true,
	hasDivider = {
		hasDivider = true,
		isInset = false
	}
}

local function renderRowTrailing(b1: boolean, s1: string, n1: number) -- line: 54
	-- upvalues: React (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy)
	if b1 then
		return React.createElement(Skeleton, {
			Size = UDim2.new(0.3, 0, 0, n1),
			radius = EnumsRadius.Medium
		})
	end

	return React.createElement(FoundationText, {
		tag = "auto-xy text-body-small text-truncate-end",
		Text = s1
	})
end
local function EditProfileLandingV2(t2: {[any]: any}) -- line: 68
	-- upvalues: useProfileCardWidth (copy), useTokens (copy), FFlagAXEnableProfileTab (copy), TextKeys (copy), useLocalization (copy), React (copy), View (copy), EditProfileHeaderBar (copy), UserTile (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy), List (copy), t1 (copy), renderRowTrailing (copy)
	local v28 = useProfileCardWidth()
	local v29 = useTokens()
	local v30 = FFlagAXEnableProfileTab and t2.fullBleed == true
	local v31 = if not t2.isPolicyEnabled then TextKeys.DisplayName else TextKeys.AgedUpDisplayName
	local v32 = useLocalization({
		TopBarTitle = TextKeys.Title,
		UsernameLabel = TextKeys.Username,
		DisplayNameLabel = v31,
		BioLabel = TextKeys.About,
		BioPlaceholder = TextKeys.AboutPlaceholder
	})
	local v33 = if t2.bioText == "" or t2.bioText == nil then v32.BioPlaceholder else string.gsub(t2.bioText, "\n", " ")
	local Size_400 = v29.Size.Size_400

	return React.createElement(View, {
		tag = not FFlagAXEnableProfileTab and "col items-start position-top-right anchor-top-right bg-surface-0" or {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not v30,
			["size-full-full"] = v30
		},
		Size = if not v30 then UDim2.new(0, v28, 1, 0) else nil
	}, {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = t2.onClose,
			headerText = v32.TopBarTitle
		}),
		EditableComponents = React.createElement(View, {
			tag = "col gap-xxlarge size-full-0 auto-y padding-xlarge"
		}, {
			AvatarEditRow = React.createElement(View, {
				tag = "size-full-2400",
				LayoutOrder = 1
			}, {
				AvatarContainer = React.createElement(View, {
					tag = "position-center-center anchor-center-center size-2400-2400"
				}, {
					AvatarHeadshot = React.createElement(View, {
						tag = "size-full-full"
					}, {
						UserTile = React.createElement(UserTile.UserTile, {
							userId = t2.userId,
							layoutMode = UserTile.LayoutMode.compact,
							onActivated = t2.settingButtonOnActivated.avatar
						})
					}),
					EditAvatarIconButton = React.createElement(View, {
						tag = "position-bottom-right anchor-bottom-right auto-xy radius-circle bg-over-media-0"
					}, {
						IconButton = React.createElement(IconButton, {
							isCircular = true,
							icon = IconName.PhotoCamera,
							size = IconSize.Small,
							onActivated = t2.settingButtonOnActivated.avatar,
							variant = ButtonVariant.Standard
						})
					})
				})
			}),
			TextComponentsList = React.createElement(List.Root, {
				testId = "TextComponentsList",
				LayoutOrder = 2,
				isContained = t1.isContained,
				hasDivider = t1.hasDivider
			}, {
				EditDisplayNameRow = React.createElement(List.Item, {
					testId = "EditDisplayNameRow",
					LayoutOrder = 1,
					title = v32.DisplayNameLabel,
					trailing = renderRowTrailing(t2.areNamesLoading, t2.displayName, Size_400),
					onActivated = if not t2.areNamesLoading then {
						onActivated = t2.settingButtonOnActivated.displayName
					} else nil,
					ref = t2.firstItemRef
				}),
				UsernameEditRow = React.createElement(List.Item, {
					testId = "UsernameEditRow",
					LayoutOrder = 2,
					title = v32.UsernameLabel,
					trailing = renderRowTrailing(t2.areNamesLoading, t2.username, Size_400),
					onActivated = if not t2.areNamesLoading then {
						onActivated = t2.settingButtonOnActivated.username
					} else nil
				}),
				BioEditRow = React.createElement(List.Item, {
					testId = "BioEditRow",
					LayoutOrder = 3,
					title = v32.BioLabel,
					trailing = renderRowTrailing(t2.isBioLoading, v33, Size_400),
					onActivated = if not t2.isBioLoading then {
						onActivated = t2.settingButtonOnActivated.bio
					} else nil
				})
			})
		})
	})
end

return EditProfileLandingV2
