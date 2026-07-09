local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local RoactNavigation = require(AvatarExperienceCatalogParent.RoactNavigation)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(AvatarExperienceCatalogParent.AvatarExperienceNavigation).withMappedNavigationParams
local AXPartialPageModal = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Components.AXPartialPageModal
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Checkbox = Foundation.Checkbox
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useMultiItemShoppingFtux = require(AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux)

local function WearAvatarReplaceAllItemsPrompt(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), useMultiItemShoppingFtux (copy), React (copy), RoactNavigation (copy), View (copy), FoundationText (copy), Checkbox (copy), InputSize (copy), AXPartialPageModal (copy), ButtonVariant (copy)
	local v17 = useLocalization({
		confirmButtonText = "Feature.Catalog.Action.Checkout.Wear",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = "Feature.Catalog.Title.Checkout.WearAvatarReplaceAllItemsTitle",
		bodyText = "Feature.Catalog.Label.Checkout.WearAvatarReplaceAllItemsBody",
		checkboxText = "Feature.Catalog.Label.Checkout.DontWarnAgainText"
	})
	local v18 = useMultiItemShoppingFtux()
	local v19, v20 = React.useState(false)
	local v21 = React.useCallback(function() -- line: 36
		-- upvalues: t1 (copy), RoactNavigation (copy), v18 (copy)
		t1.navigation.dispatch(RoactNavigation.Actions.back(nil))
		v18.incrementWearAvatarReplaceAllItemsPromptCount()
	end, { t1.navigation })
	local v22 = React.useCallback(function() -- line: 42
		-- upvalues: v21 (copy), t1 (copy), v19 (copy)
		v21()
		t1.onConfirm(v19)
	end, {
		t1.onConfirm,
		v21,
		v19
	})
	local v23 = React.useCallback(function() -- line: 47
		-- upvalues: v21 (copy)
		v21()
	end, { v21 })

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v23,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v22,
						text = v17.confirmButtonText,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium
					}
				},
				{
					props = {
						onActivated = v23,
						text = v17.cancelButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, ((function() -- line: 51
		-- upvalues: React (copy), View (copy), FoundationText (copy), v17 (copy), Checkbox (copy), v19 (copy), v20 (copy), InputSize (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			}, {
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
					LayoutOrder = 1,
					Text = v17.titleText
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-xxlarge text-align-x-left text-truncate-end text-body-large text-wrap",
					LayoutOrder = 2,
					Text = v17.bodyText
				}),
				DontWarnCheckbox = React.createElement(Checkbox, {
					LayoutOrder = 3,
					isChecked = v19,
					onActivated = function() -- line: 68
						-- upvalues: v20 (copy), v19 (copy)
						v20(not v19)
					end,
					size = InputSize.Medium,
					label = v17.checkboxText
				})
			})
		}
	end)()))
end

return (withMappedNavigationParams(WearAvatarReplaceAllItemsPrompt))
