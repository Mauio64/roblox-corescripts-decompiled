local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/deferred/gfb")
local axPartialPageModal = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AXPartialPageModal
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local text = Foundation.Text
local checkbox = Foundation.Checkbox
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local fFlagAXFixAvatarScreenVR = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixAvatarScreenVR

local module2 = require("@luauforge/deferred/gfc")

local function MakeupMax6LayersPrompt(p2)
	local v5 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Replace",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = "Feature.Catalog.Title.Makeup.MakeupMax6LayersPromptTitle",
		bodyText = "Feature.Catalog.Label.Makeup.MakeupMax6LayersPromptBody",
		checkboxText = "Feature.Catalog.Label.Checkout.DontWarnAgainText"
	})

	local state, setState = React.useState(false)

	local v6 = React.useCallback(function()
		p2.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { p2.navigation })

	local v7 = React.useCallback(function()
		v6()
		p2.onConfirm(state)
	end, { p2.onConfirm, v6, state })

	local v8 = React.useCallback(function()
		v6()
	end, { v6 })

	local v9 = React.useCallback(function()
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
	end, { v5, state })

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
	}, v9())
end

local v5 = module(MakeupMax6LayersPrompt)

if fFlagAXFixAvatarScreenVR then
	v5 = module2(v5)
end

return v5
