local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local Foundation = require(EditProfileParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconButton = Foundation.IconButton
local View = Foundation.View
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local useProfileCardWidth = require(EditProfileParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local UserTile = require(EditProfileParent.UserTile)
local EditComponentRow = require(EditProfile.BaseComponents.EditComponentRow)
local EditProfileHeaderBar = require(EditProfile.BaseComponents.EditProfileHeaderBar)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab

local function EditProfileLanding(t1: {[any]: any}) -- line: 42
	-- upvalues: useProfileCardWidth (copy), FFlagAXEnableProfileTab (copy), TextKeys (copy), useLocalization (copy), React (copy), View (copy), EditProfileHeaderBar (copy), UserTile (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy), EditComponentRow (copy)
	local v19 = useProfileCardWidth()
	local v20 = FFlagAXEnableProfileTab and t1.fullBleed == true
	local v21 = if not t1.isPolicyEnabled then TextKeys.DisplayName else TextKeys.AgedUpDisplayName
	local v22 = useLocalization({
		TopBarTitle = TextKeys.Title,
		UsernameLabel = TextKeys.Username,
		DisplayNameLabel = v21,
		BioLabel = TextKeys.About,
		BioPlaceholder = TextKeys.AboutPlaceholder
	})

	return React.createElement(View, {
		tag = not FFlagAXEnableProfileTab and "col items-start position-top-right anchor-top-right bg-surface-0" or {
			["col items-start bg-surface-0"] = true,
			["position-top-right anchor-top-right"] = not v20,
			["size-full-full"] = v20
		},
		Size = if not v20 then UDim2.new(0, v19, 1, 0) else nil
	}, {
		TopBar = React.createElement(EditProfileHeaderBar, {
			onClose = t1.onClose,
			headerText = v22.TopBarTitle
		}),
		EditableComponents = React.createElement(View, {
			tag = "col padding-xlarge gap-xxlarge size-full-0 auto-y"
		}, {
			AvatarEditRow = React.createElement(View, {
				tag = "size-full-2400",
				LayoutOrder = 1
			}, {
				AvatarContainer = React.createElement(View, {
					tag = "size-2400-2400 position-center-center anchor-center-center"
				}, {
					AvatarHeadshot = React.createElement(View, {
						tag = "size-full-full"
					}, {
						UserTile = React.createElement(UserTile.UserTile, {
							userId = t1.userId,
							layoutMode = UserTile.LayoutMode.compact,
							onActivated = t1.settingButtonOnActivated.avatar
						})
					}),
					EditAvatarIconButton = React.createElement(View, {
						tag = "position-bottom-right anchor-bottom-right auto-xy bg-over-media-0 radius-circle"
					}, {
						IconButton = React.createElement(IconButton, {
							isCircular = true,
							icon = IconName.PhotoCamera,
							size = IconSize.Small,
							onActivated = t1.settingButtonOnActivated.avatar,
							variant = ButtonVariant.Standard
						})
					})
				})
			}),
			TextComponentsList = React.createElement(View, {
				tag = "col size-full-0 auto-y bg-surface-100 radius-medium",
				LayoutOrder = 2
			}, {
				EditDisplayNameRow = React.createElement(EditComponentRow, {
					layoutOrder = 1,
					label = v22.DisplayNameLabel,
					currentValue = t1.displayName,
					onActivated = if not t1.areNamesLoading then t1.settingButtonOnActivated.displayName else function() -- line: 115
					end,
					shouldShimmer = t1.areNamesLoading,
					forwardRef = t1.firstItemRef
				}),
				UsernameEditRow = React.createElement(EditComponentRow, {
					layoutOrder = 2,
					label = v22.UsernameLabel,
					currentValue = t1.username,
					onActivated = t1.settingButtonOnActivated.username,
					shouldShimmer = t1.areNamesLoading
				}),
				BioEditRow = React.createElement(EditComponentRow, {
					layoutOrder = 3,
					label = v22.BioLabel,
					currentValue = if t1.bioText == "" or t1.bioText == nil then v22.BioPlaceholder else t1.bioText,
					onActivated = t1.settingButtonOnActivated.bio,
					shouldShimmer = t1.isBioLoading
				})
			})
		})
	})
end

return EditProfileLanding
