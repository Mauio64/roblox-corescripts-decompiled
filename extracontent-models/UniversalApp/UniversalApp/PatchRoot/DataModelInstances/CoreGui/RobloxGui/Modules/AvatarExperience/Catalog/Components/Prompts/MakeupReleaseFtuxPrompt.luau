local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local AXPartialPageModal = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AXPartialPageModal
local UIBlox = require(CorePackages.Packages.UIBlox)
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationCloudAssets = require(CorePackages.Packages.FoundationCloudAssets)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FFlagAXFixAvatarScreenVR = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixAvatarScreenVR
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local Assets = FoundationCloudAssets.Assets

FoundationCloudAssets.preloadAsset("pictograms/makeup_look")

local v21 = Assets["pictograms/makeup_look"]

local function MakeupReleaseFtuxPrompt(t1: {[any]: any}) -- line: 38
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy), getIconSize (copy), IconSize (copy), RoactNavigation (copy), View (copy), v21 (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy)
	local v25 = useLocalization({
		viewButtonText = "CommonUI.Messages.Action.View",
		dismissButtonText = "CommonUI.Messages.Action.Dismiss",
		titleText = "Feature.Avatar.Title.MakeupIntroFtux",
		bodyText = "Feature.Avatar.Description.MakeupIntroFtux"
	})
	local v26, v27 = React.useState(false)
	local v28 = Foundation.Hooks.useTokens()
	local v29 = getIconSize(IconSize.XXLarge)
	local v30 = React.useCallback(function() -- line: 51
		-- upvalues: t1 (copy), RoactNavigation (copy)
		t1.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { t1.navigation })
	local v31 = React.useCallback(function() -- line: 55
		-- upvalues: v30 (copy), t1 (copy)
		v30()
		t1.onView()
	end, {
		t1.onView,
		v30
	})
	local v32 = React.useCallback(function() -- line: 60
		-- upvalues: v30 (copy), t1 (copy)
		v30()
		t1.onDismiss()
	end, {
		t1.onDismiss,
		v30
	})

	React.useEffect(function() -- line: 65
		-- upvalues: v27 (copy)
		v27(true)
	end, {})

	local v33 = React.useCallback(function() -- line: 69
		-- upvalues: React (copy), View (copy), v29 (copy), Foundation (copy), v21 (copy), v28 (copy), FoundationText (copy), v25 (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			}, {
				GraphicContainer = React.createElement(View, {
					tag = "position-center-center grow padding-bottom-small",
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v29)
				}, {
					MakeupCategoryArt = React.createElement(Foundation.Image, {
						tag = "size-full",
						Image = v21 and v21.assetId,
						ScaleType = Enum.ScaleType.Fit,
						imageStyle = v28.Color.Content.Emphasis
					})
				}),
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small padding-top-medium text-align-x-left text-heading-small text-wrap",
					LayoutOrder = 3,
					Text = v25.titleText
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 4,
					Text = v25.bodyText
				})
			})
		}
	end, {
		v29,
		v28,
		v25,
		v21
	})

	return React.createElement(AXPartialPageModal, {
		visible = v26,
		onBackgroundPress = v32,
		buttonStackProps = {
			rowLayout = true,
			buttons = {
				{
					props = {
						onActivated = v31,
						text = v25.viewButtonText,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium
					}
				},
				{
					props = {
						onActivated = v32,
						text = v25.dismissButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, v33())
end

local v23 = withMappedNavigationParams(MakeupReleaseFtuxPrompt)

if FFlagAXFixAvatarScreenVR then
	v23 = withOverlayFocusHandling(v23)
end

return v23
