local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/BuilderIcons")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactNavigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local withMappedNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").withMappedNavigationParams
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local axPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local iconSize = Foundation.Enums.IconSize

local function ItemReplacedOnAvatarPrompt(props)
	local v5 = useLocalization({
		confirmButtonText = "CommonUI.Controls.Action.OK",
		titleText = "Feature.Catalog.Title.Checkout.ItemReplacedOnAvatarTitle",
		bodyText = "Feature.Catalog.Label.Checkout.ItemReplacedOnAvatarBody"
	})

	local v6 = React.useCallback(function()
		props.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { props.navigation })

	local v7 = React.useCallback(function()
		v6()
		props.onConfirm()
	end, { props.onConfirm, v6 })

	local function fn()
		local createElement = React.createElement

		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v12 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1,
			Selectable = false,
			presentationSlot = 0
		}

		local createElement4 = React.createElement

		local v14 = { Size = UDim2.fromOffset(80, 80) }

		local createElement5 = React.createElement
		local itemId = props.beforeItem.itemId
		v12.presentationSlot = createElement4(
			view,
			v14,
			createElement5(itemCardThumbnail, {
				url = `rbxthumb://type={props.beforeItem.thumbType}&id={itemId}&w=150&h=150`
			})
		)
		local children2 = {
			BeforeItem = createElement3(catalogItemCard, v12),
			ReplaceIcon = React.createElement(
				view,
				{
					Size = UDim2.fromOffset(60, 80),
					LayoutOrder = 2,
					tag = "row auto-x auto-y align-x-center align-y-center"
				},
				React.createElement(Foundation.Icon, {
					name = BuilderIcons.Icon.TwoArrowsSpinClockwise,
					size = iconSize.Large,
					variant = BuilderIcons.IconVariant.Regular
				})
			),
			AfterItem = 0
		}

		local createElement6 = React.createElement
		local v18 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 3,
			Selectable = false,
			presentationSlot = 0
		}

		local createElement7 = React.createElement

		local v20 = { Size = UDim2.fromOffset(80, 80) }

		local createElement8 = React.createElement
		local itemId2 = props.afterItem.itemId
		v18.presentationSlot = createElement7(
			view,
			v20,
			createElement8(itemCardThumbnail, {
				url = `rbxthumb://type={props.afterItem.thumbType}&id={itemId2}&w=150&h=150`
			})
		)
		children2.AfterItem = createElement6(catalogItemCard, v18)
		return {
			ViewFrame = createElement(
				view,
				{
					tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
				},
				{
					GraphicContainer = createElement2(
						view,
						{
							tag = "row size-full-0 auto-y align-x-center padding-bottom-xxlarge",
							LayoutOrder = 1
						},
						children2
					),
					PromptBodyTitle = React.createElement(text, {
						tag = "auto-xy padding-bottom-small padding-top-large text-align-x-left text-heading-small text-wrap",
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

return (withMappedNavigationParams(ItemReplacedOnAvatarPrompt))
