local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local AXPartialPageModal = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AXPartialPageModal
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Checkbox = Foundation.Checkbox
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FFlagAXFixAvatarScreenVR = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixAvatarScreenVR
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)

local function MakeupMax6LayersPrompt(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), React (copy), RoactNavigation (copy), View (copy), FoundationText (copy), Checkbox (copy), InputSize (copy), AXPartialPageModal (copy), ButtonVariant (copy)
	local v20 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Replace",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = "Feature.Catalog.Title.Makeup.MakeupMax6LayersPromptTitle",
		bodyText = "Feature.Catalog.Label.Makeup.MakeupMax6LayersPromptBody",
		checkboxText = "Feature.Catalog.Label.Checkout.DontWarnAgainText"
	})
	local v21, v22 = React.useState(false)
	local v23 = React.useCallback(function() -- line: 40
		-- upvalues: t1 (copy), RoactNavigation (copy)
		t1.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { t1.navigation })
	local v24 = React.useCallback(function() -- line: 44
		-- upvalues: v23 (copy), t1 (copy), v21 (copy)
		v23()
		t1.onConfirm(v21)
	end, {
		t1.onConfirm,
		v23,
		v21
	})
	local v25 = React.useCallback(function() -- line: 49
		-- upvalues: v23 (copy)
		v23()
	end, { v23 })
	local v26 = React.useCallback(function() -- line: 53
		-- upvalues: React (copy), View (copy), FoundationText (copy), v20 (copy), Checkbox (copy), v21 (copy), v22 (copy), InputSize (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			}, {
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
					LayoutOrder = 1,
					Text = v20.titleText
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-xxlarge text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 2,
					Text = v20.bodyText
				}),
				DontWarnCheckbox = React.createElement(Checkbox, {
					LayoutOrder = 3,
					isChecked = v21,
					onActivated = function() -- line: 70
						-- upvalues: v22 (copy), v21 (copy)
						v22(not v21)
					end,
					size = InputSize.Medium,
					label = v20.checkboxText
				})
			})
		}
	end, {
		v20,
		v21
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v25,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v24,
						text = v20.confirmButtonText,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium
					}
				},
				{
					props = {
						onActivated = v25,
						text = v20.cancelButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, v26())
end

local v18 = withMappedNavigationParams(MakeupMax6LayersPrompt)

if FFlagAXFixAvatarScreenVR then
	v18 = withOverlayFocusHandling(v18)
end

return v18
