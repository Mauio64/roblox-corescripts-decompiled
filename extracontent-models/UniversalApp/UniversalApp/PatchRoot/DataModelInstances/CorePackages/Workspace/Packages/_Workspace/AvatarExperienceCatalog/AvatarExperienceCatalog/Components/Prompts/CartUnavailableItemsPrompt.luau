local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(Parent.AvatarExperienceNavigation).withMappedNavigationParams
local AXPartialPageModal = require(Parent.AvatarExperienceCommon).Components.AXPartialPageModal
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function CartUnavailableItemsPrompt(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), React (copy), RoactNavigation (copy), View (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy)
	local v14 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.UnavailableItems",
		titleText = "Feature.Catalog.Title.Checkout.UnavailableItems",
		bodyText = "Feature.Catalog.Message.Checkout.UnavailableItems"
	})
	local v15 = React.useCallback(function() -- line: 28
		-- upvalues: t1 (copy), RoactNavigation (copy)
		t1.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { t1.navigation })
	local v16 = React.useCallback(function() -- line: 32
		-- upvalues: v15 (copy), t1 (copy)
		v15()

		if t1.onConfirm then
			t1.onConfirm()
		end
	end, {
		t1.onConfirm,
		v15
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v16,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					onActivated = v16,
					text = v14.confirmButtonText,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium
				}
			}}
		}
	}, ((function() -- line: 39
		-- upvalues: React (copy), View (copy), FoundationText (copy), v14 (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			}, {
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
					LayoutOrder = 1,
					Text = v14.titleText
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-xxlarge text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 2,
					Text = v14.bodyText
				})
			})
		}
	end)()))
end

return (withMappedNavigationParams(CartUnavailableItemsPrompt))
