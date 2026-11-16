local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function GoToCustomizeToEditPrompt(p)
	local v = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.GoToCustomize",
		cancelButtonText = "Feature.Avatar.Action.Stay",
		titleText = "Feature.Catalog.Title.Checkout.GoToCustomizeTitle",
		bodyText = "Feature.Catalog.Label.Checkout.GoToCustomizeBody"
	})

	local v2 = React.useCallback(function()
		p.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { p.navigation })

	local onActivated = React.useCallback(function()
		v2()
		p.onConfirm()
	end, { p.onConfirm, v2 })

	local v3 = React.useCallback(function()
		v2()
	end, { v2 })

	local function fn()
		return {
			ViewFrame = React.createElement(
				View,
				{ tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top" },
				{
					PromptBodyTitle = React.createElement(Text, {
						tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
						Text = v.titleText,
						LayoutOrder = 2
					}),
					PromptBodyText = React.createElement(Text, {
						tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
						Text = v.bodyText,
						LayoutOrder = 3
					})
				}
			)
		}
	end

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v3,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = onActivated,
						text = v.confirmButtonText,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium
					}
				},
				{
					props = {
						onActivated = v3,
						text = v.cancelButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, fn())
end

return GoToCustomizeToEditPrompt
