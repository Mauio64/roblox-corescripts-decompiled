local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactNavigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local withMappedNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").withMappedNavigationParams
local axPartialPageModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Components.AXPartialPageModal
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local text = Foundation.Text
local checkbox = Foundation.Checkbox
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local useMultiItemShoppingFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMultiItemShoppingFtux")

local function ClearAllItemsOnAvatarPrompt(p2)
	local v5 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.Clear",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = "Feature.Catalog.Title.Checkout.ClearAllItemsOnAvatarTitle",
		bodyText = "Feature.Catalog.Label.Checkout.ClearAllItemsOnAvatarBody",
		checkboxText = "Feature.Catalog.Label.Checkout.DontWarnAgainText"
	})

	local v6 = useMultiItemShoppingFtux()

	local state, setState = React.useState(false)

	local v7 = React.useCallback(function()
		p2.navigation.dispatch(RoactNavigation.Actions.back(nil))

		v6.incrementClearAllItemsPromptCount()
	end, { p2.navigation })

	local v8 = React.useCallback(function()
		v7()
		p2.onConfirm(state)
	end, { p2.onConfirm, v7, state })

	local v9 = React.useCallback(function()
		v7()
	end, { v7 })

	local function fn()
		return {
			ViewFrame = React.createElement(
				view,
				{
					tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
				},
				{
					PromptBodyTitle = React.createElement(text, {
						tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
						Text = v5.titleText,
						LayoutOrder = 1
					}),
					PromptBodyText = React.createElement(text, {
						tag = "auto-xy padding-bottom-xxlarge text-align-x-left text-truncate-end text-body-large text-wrap",
						Text = v5.bodyText,
						LayoutOrder = 2
					}),
					DontWarnCheckbox = React.createElement(checkbox, {
						isChecked = state,
						onActivated = function()
							setState(not state)
						end,
						size = inputSize.Medium,
						label = v5.checkboxText,
						LayoutOrder = 3
					})
				}
			)
		}
	end

	return React.createElement(axPartialPageModal, {
		onBackgroundPress = v9,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v8,
						text = v5.confirmButtonText,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium
					}
				},
				{
					props = {
						onActivated = v9,
						text = v5.cancelButtonText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium
					}
				}
			}
		}
	}, fn())
end

return (withMappedNavigationParams(ClearAllItemsOnAvatarPrompt))
