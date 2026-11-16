local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactNavigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local withMappedNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").withMappedNavigationParams
local axPartialPageModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Components.AXPartialPageModal
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function CartUnavailableItemsPrompt(p2)
	local v5 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.UnavailableItems",
		titleText = "Feature.Catalog.Title.Checkout.UnavailableItems",
		bodyText = "Feature.Catalog.Message.Checkout.UnavailableItems"
	})

	local v6 = React.useCallback(function()
		p2.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { p2.navigation })

	local v7 = React.useCallback(function()
		v6()

		if p2.onConfirm then
			p2.onConfirm()
		end
	end, { p2.onConfirm, v6 })

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
					})
				}
			)
		}
	end

	return React.createElement(axPartialPageModal, {
		onBackgroundPress = v7,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v7,
						text = v5.confirmButtonText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium
					}
				}
			}
		}
	}, fn())
end

return (withMappedNavigationParams(CartUnavailableItemsPrompt))
