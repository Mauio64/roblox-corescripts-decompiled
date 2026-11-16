local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local withMappedNavigationParams = AvatarExperienceNavigation.withMappedNavigationParams
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Checkbox = Foundation.Checkbox
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useMultiItemShoppingFtux = require(AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux)

local function WearAvatarReplaceAllItemsPrompt(p)
	local v = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.Wear",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = "Feature.Catalog.Title.Checkout.WearAvatarReplaceAllItemsTitle",
		bodyText = "Feature.Catalog.Label.Checkout.WearAvatarReplaceAllItemsBody",
		checkboxText = "Feature.Catalog.Label.Checkout.DontWarnAgainText"
	})

	local v2 = useMultiItemShoppingFtux()

	local state, setState = React.useState(false)

	local v3 = React.useCallback(function()
		p.navigation.dispatch(RoactNavigation.Actions.back(nil))

		v2.incrementWearAvatarReplaceAllItemsPromptCount()
	end, { p.navigation })

	local onActivated = React.useCallback(function()
		v3()
		p.onConfirm(state)
	end, { p.onConfirm, v3, state })

	local v4 = React.useCallback(function()
		v3()
	end, { v3 })

	local function fn()
		return {
			ViewFrame = React.createElement(
				View,
				{ tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top" },
				{
					PromptBodyTitle = React.createElement(Text, {
						tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
						Text = v.titleText,
						LayoutOrder = 1
					}),
					PromptBodyText = React.createElement(Text, {
						tag = "auto-xy padding-bottom-xxlarge text-align-x-left text-truncate-end text-body-large text-wrap",
						Text = v.bodyText,
						LayoutOrder = 2
					}),
					DontWarnCheckbox = React.createElement(Checkbox, {
						isChecked = state,
						onActivated = function()
							setState(not state)
						end,
						size = InputSize.Medium,
						label = v.checkboxText,
						LayoutOrder = 3
					})
				}
			)
		}
	end

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v4,
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
						onActivated = v4,
						text = v.cancelButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, fn())
end

return (withMappedNavigationParams(WearAvatarReplaceAllItemsPrompt))
