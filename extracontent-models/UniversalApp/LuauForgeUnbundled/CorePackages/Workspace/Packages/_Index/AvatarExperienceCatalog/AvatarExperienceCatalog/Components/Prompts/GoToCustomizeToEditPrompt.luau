local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactNavigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local axPartialPageModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Components.AXPartialPageModal
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function GoToCustomizeToEditPrompt(p2)
	local v5 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.GoToCustomize",
		cancelButtonText = "Feature.Avatar.Action.Stay",
		titleText = "Feature.Catalog.Title.Checkout.GoToCustomizeTitle",
		bodyText = "Feature.Catalog.Label.Checkout.GoToCustomizeBody"
	})

	local v6 = React.useCallback(function()
		p2.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { p2.navigation })

	local v7 = React.useCallback(function()
		v6()
		p2.onConfirm()
	end, { p2.onConfirm, v6 })

	local v8 = React.useCallback(function()
		v6()
	end, { v6 })

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
						LayoutOrder = 2
					}),
					PromptBodyText = React.createElement(text, {
						tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
						Text = v5.bodyText,
						LayoutOrder = 3
					})
				}
			)
		}
	end

	return React.createElement(axPartialPageModal, {
		onBackgroundPress = v8,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v7,
						text = v5.confirmButtonText,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium
					}
				},
				{
					props = {
						onActivated = v8,
						text = v5.cancelButtonText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium
					}
				}
			}
		}
	}, fn())
end

return GoToCustomizeToEditPrompt
