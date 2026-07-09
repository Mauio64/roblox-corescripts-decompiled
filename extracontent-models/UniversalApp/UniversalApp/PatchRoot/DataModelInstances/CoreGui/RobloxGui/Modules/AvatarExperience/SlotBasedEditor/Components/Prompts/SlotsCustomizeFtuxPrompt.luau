local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local AXPartialPageModal = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Components.AXPartialPageModal
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ThemeName = UIBlox.App.Style.Constants.ThemeName
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function SlotsCustomizeFtuxPrompt(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), useStyleMetadata (copy), getIconSize (copy), IconSize (copy), ThemeName (copy), React (copy), NavigationUtils (copy), View (copy), Foundation (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonType (copy)
	local v19 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.GotIt",
		customizeIntroTitle = "Feature.Avatar.Title.NewCustomizeLook",
		customizeIntroMessage = "Feature.Avatar.Message.NewCustomize"
	})
	local v20 = useStyleMetadata()
	local v21 = getIconSize(IconSize.XXLarge)
	local v22 = v20.ThemeName ~= ThemeName.Dark and "icons/graphic/clothes_category_art_light" or "icons/graphic/clothes_category_art_dark"
	local v23 = React.useCallback(function() -- line: 40
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeFocusedScreen(t1.navigation)
	end, { t1.navigation })

	return React.createElement(AXPartialPageModal, {
		screenSize = t1.screenSize,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = function() -- line: 82
						-- upvalues: v23 (copy), t1 (copy)
						v23()
						t1.onConfirm()
					end,
					text = v19.confirmButtonText
				}
			}}
		}
	}, ((function() -- line: 44
		-- upvalues: React (copy), View (copy), v21 (copy), Foundation (copy), v22 (copy), FoundationText (copy), v19 (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y padding-bottom-medium col align-x-left align-y-top",
				Size = UDim2.fromScale(1, 0)
			}, {
				GraphicContainer = React.createElement(View, {
					tag = "position-center-center grow padding-bottom-small",
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v21)
				}, {
					ClothingCategoryArt = React.createElement(Foundation.Image, {
						tag = "size-full",
						Image = v22,
						ScaleType = Enum.ScaleType.Fit
					})
				}),
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = " auto-xy padding-y-small text-align-x-left text-truncate-end text-heading-small text-wrap",
					LayoutOrder = 2,
					Text = v19.customizeIntroTitle
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy padding-y-small text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 3,
					Text = v19.customizeIntroMessage
				})
			})
		}
	end)()))
end

return (withMappedNavigationParams(SlotsCustomizeFtuxPrompt))
