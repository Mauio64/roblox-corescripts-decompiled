local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AXPartialPageModal = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Components.AXPartialPageModal
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local IconOnlyMenu = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar).IconOnlyMenu
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local ThemeName = UIBlox.App.Style.Constants.ThemeName
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot

local function selectUserId(p1) -- line: 37
	return p1.LocalUserId
end
local function SlotsAvatarSwitcherFtuxPrompt(t1: {[any]: any}) -- line: 41
	-- upvalues: useLocalization (copy), useTokens (copy), useSelector (copy), selectUserId (copy), React (copy), NavigationUtils (copy), useStyleMetadata (copy), ThemeName (copy), View (copy), IconOnlyMenu (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), FoundationText (copy), Icon (copy), IconSize (copy), AXPartialPageModal (copy), ButtonType (copy)
	local v28 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.GotIt",
		avatarSwitcherTitle = "Feature.Avatar.Title.SavedAvatarsLocation",
		avatarSwitcherMessageProfile = "Feature.Avatar.Message.NewControlLocationProfile",
		avatarSwitcherMessageBundles = "Feature.Avatar.Message.NewControlLocationFullBody",
		profilePhoto = "Feature.Avatar.Label.Title.ProfilePhoto"
	})
	local v29 = useTokens()
	local v30 = useSelector(selectUserId)
	local v31 = React.useCallback(function() -- line: 52
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeFocusedScreen(t1.navigation)
	end, { t1.navigation })
	local v32 = useStyleMetadata().ThemeName == ThemeName.Dark and v29.Color.Surface.Surface_200 or v29.Color.Extended.Gray.Gray_400

	return React.createElement(AXPartialPageModal, {
		screenSize = t1.screenSize,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = function() -- line: 143
						-- upvalues: v31 (copy), t1 (copy)
						v31()
						t1.onConfirm()
					end,
					text = v28.confirmButtonText
				}
			}}
		}
	}, ((function() -- line: 60
		-- upvalues: React (copy), View (copy), v32 (copy), v29 (copy), IconOnlyMenu (copy), getRbxthumbWithTypeSizeAndOptions (copy), v30 (copy), AvatarHeadShot (copy), v28 (copy), FoundationText (copy), Icon (copy), IconSize (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y grow size-full-0 col align-x-left align-y-top"
			}, {
				ControlBarDiagram = React.createElement(View, {
					tag = "auto-y position-center-center self-center grow radius-medium size-full-0",
					LayoutOrder = 1,
					backgroundStyle = v32,
					padding = {
						top = UDim.new(0, v29.Margin.Large),
						bottom = UDim.new(0, v29.Margin.Large)
					}
				}, {
					IconOnlyMenu = React.createElement(IconOnlyMenu, {
						direction = "vertical",
						activeItemId = "",
						Position = UDim2.fromScale(0.3, 0),
						items = {
							{
								type = "image",
								id = "1",
								thumbnailUrl = getRbxthumbWithTypeSizeAndOptions(v30, AvatarHeadShot, 150, true, true)
							},
							{
								type = "icon",
								id = "2",
								icon = "icons/menu/customize"
							},
							{
								type = "icon",
								id = "3",
								icon = "icons/common/hamburgermenu",
								toolTipConfig = {
									open = true,
									bodyText = v28.profilePhoto
								}
							}
						}
					})
				}),
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small padding-top-xxlarge text-align-x-left text-truncate-end text-heading-small text-wrap",
					LayoutOrder = 2,
					Text = v28.avatarSwitcherTitle
				}),
				PromptBodyText1 = React.createElement(View, {
					tag = "auto-y row align-x-left align-y-center size-full-0",
					LayoutOrder = 3
				}, {
					BodyText = React.createElement(FoundationText, {
						tag = "auto-xy padding-y-small text-align-x-left text-truncate-end text-body-large text-wrap",
						LayoutOrder = 1,
						Text = v28.avatarSwitcherMessageProfile
					}),
					MenuIcon = React.createElement(Icon, {
						name = "icons/common/hamburgermenu",
						LayoutOrder = 2,
						size = IconSize.Medium
					})
				}),
				PromptBodyText2 = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-xxlarge text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 4,
					Text = v28.avatarSwitcherMessageBundles
				})
			})
		}
	end)()))
end

return (withMappedNavigationParams(SlotsAvatarSwitcherFtuxPrompt))
