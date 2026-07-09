local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AXPartialPageModal = require(Parent.AvatarExperienceCommon).Components.AXPartialPageModal
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function GoToCustomizeToEditPrompt(t1: {[any]: any}) -- line: 20
	-- upvalues: useLocalization (copy), React (copy), RoactNavigation (copy), View (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy)
	local v13 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.GoToCustomize",
		cancelButtonText = "Feature.Avatar.Action.Stay",
		titleText = "Feature.Catalog.Title.Checkout.GoToCustomizeTitle",
		bodyText = "Feature.Catalog.Label.Checkout.GoToCustomizeBody"
	})
	local v14 = React.useCallback(function() -- line: 28
		-- upvalues: t1 (copy), RoactNavigation (copy)
		t1.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { t1.navigation })
	local v15 = React.useCallback(function() -- line: 32
		-- upvalues: v14 (copy), t1 (copy)
		v14()
		t1.onConfirm()
	end, {
		t1.onConfirm,
		v14
	})
	local v16 = React.useCallback(function() -- line: 37
		-- upvalues: v14 (copy)
		v14()
	end, { v14 })

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v16,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v15,
						text = v13.confirmButtonText,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium
					}
				},
				{
					props = {
						onActivated = v16,
						text = v13.cancelButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, ((function() -- line: 41
		-- upvalues: React (copy), View (copy), FoundationText (copy), v13 (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			}, {
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
					LayoutOrder = 2,
					Text = v13.titleText
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 3,
					Text = v13.bodyText
				})
			})
		}
	end)()))
end

return GoToCustomizeToEditPrompt
