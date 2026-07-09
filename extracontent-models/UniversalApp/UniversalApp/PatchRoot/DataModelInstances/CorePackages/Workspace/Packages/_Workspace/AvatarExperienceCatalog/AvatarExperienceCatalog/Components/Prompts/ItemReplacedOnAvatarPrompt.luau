local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local BuilderIcons = require(Parent.BuilderIcons)
local RoactNavigation = require(Parent.RoactNavigation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local withMappedNavigationParams = require(Parent.AvatarExperienceNavigation).withMappedNavigationParams
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(Parent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconSize = Foundation.Enums.IconSize

local function ItemReplacedOnAvatarPrompt(t1: {[any]: any}) -- line: 38
	-- upvalues: useLocalization (copy), React (copy), RoactNavigation (copy), View (copy), CatalogItemCard (copy), ItemCardThumbnail (copy), Foundation (copy), BuilderIcons (copy), IconSize (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy)
	local v21 = useLocalization({
		confirmButtonText = "CommonUI.Controls.Action.OK",
		titleText = "Feature.Catalog.Title.Checkout.ItemReplacedOnAvatarTitle",
		bodyText = "Feature.Catalog.Label.Checkout.ItemReplacedOnAvatarBody"
	})
	local v22 = React.useCallback(function() -- line: 45
		-- upvalues: t1 (copy), RoactNavigation (copy)
		t1.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { t1.navigation })
	local v23 = React.useCallback(function() -- line: 49
		-- upvalues: v22 (copy), t1 (copy)
		v22()
		t1.onConfirm()
	end, {
		t1.onConfirm,
		v22
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v23,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					onActivated = v23,
					text = v21.confirmButtonText,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium
				}
			}}
		}
	}, ((function() -- line: 54
		-- upvalues: React (copy), View (copy), CatalogItemCard (copy), ItemCardThumbnail (copy), t1 (copy), Foundation (copy), BuilderIcons (copy), IconSize (copy), FoundationText (copy), v21 (copy)
		local t2 = {}
		local createElement = React.createElement
		local v26 = View
		local t3 = {
			tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
		}
		local t4 = {}
		local createElement2 = React.createElement
		local v30 = View
		local t5 = {
			tag = "row size-full-0 auto-y align-x-center padding-bottom-xxlarge",
			LayoutOrder = 1
		}
		local t6 = {}
		local createElement3 = React.createElement
		local v34 = CatalogItemCard
		local t7 = {
			LayoutOrder = 1,
			Selectable = false,
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local createElement4 = React.createElement
		local v37 = View
		local t8 = {
			Size = UDim2.fromOffset(80, 80)
		}
		local createElement5 = React.createElement
		local v40 = ItemCardThumbnail
		local t9 = {}
		local itemId = t1.beforeItem.itemId

		t9.url = `rbxthumb://type={ t1.beforeItem.thumbType }&id={ itemId }&w=150&h=150`
		t7.presentationSlot = createElement4(v37, t8, createElement5(v40, t9))
		t6.BeforeItem = createElement3(v34, t7)
		t6.ReplaceIcon = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row auto-x auto-y align-x-center align-y-center",
			Size = UDim2.fromOffset(60, 80)
		}, React.createElement(Foundation.Icon, {
			name = BuilderIcons.Icon.TwoArrowsSpinClockwise,
			size = IconSize.Large,
			variant = BuilderIcons.IconVariant.Regular
		}))

		local createElement6 = React.createElement
		local v44 = CatalogItemCard
		local t10 = {
			LayoutOrder = 3,
			Selectable = false,
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local createElement7 = React.createElement
		local v47 = View
		local t11 = {
			Size = UDim2.fromOffset(80, 80)
		}
		local createElement8 = React.createElement
		local v50 = ItemCardThumbnail
		local t12 = {}
		local itemId2 = t1.afterItem.itemId

		t12.url = `rbxthumb://type={ t1.afterItem.thumbType }&id={ itemId2 }&w=150&h=150`
		t10.presentationSlot = createElement7(v47, t11, createElement8(v50, t12))
		t6.AfterItem = createElement6(v44, t10)
		t4.GraphicContainer = createElement2(v30, t5, t6)
		t4.PromptBodyTitle = React.createElement(FoundationText, {
			tag = "auto-xy padding-bottom-small padding-top-large text-align-x-left text-heading-small text-wrap",
			LayoutOrder = 2,
			Text = v21.titleText
		})
		t4.PromptBodyText = React.createElement(FoundationText, {
			tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
			LayoutOrder = 3,
			Text = v21.bodyText
		})
		t2.ViewFrame = createElement(v26, t3, t4)

		return t2
	end)()))
end

return (withMappedNavigationParams(ItemReplacedOnAvatarPrompt))
