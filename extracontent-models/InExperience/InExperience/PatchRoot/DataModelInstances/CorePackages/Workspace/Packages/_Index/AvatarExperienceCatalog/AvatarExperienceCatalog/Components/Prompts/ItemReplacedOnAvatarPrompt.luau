local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local BuilderIcons = require(parent.BuilderIcons)
local RoactNavigation = require(parent.RoactNavigation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local withMappedNavigationParams = AvatarExperienceNavigation.withMappedNavigationParams
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconSize = Foundation.Enums.IconSize

local function fn(itemId, thumbType) -- 2 equivalent calls inferred from this helper
	return `rbxthumb://type={thumbType}&id={itemId}&w=150&h=150`
end

local function ItemReplacedOnAvatarPrompt(props)
	local v = useLocalization({
		confirmButtonText = "CommonUI.Controls.Action.OK",
		titleText = "Feature.Catalog.Title.Checkout.ItemReplacedOnAvatarTitle",
		bodyText = "Feature.Catalog.Label.Checkout.ItemReplacedOnAvatarBody"
	})

	local v2 = React.useCallback(function()
		props.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { props.navigation })

	local v3 = React.useCallback(function()
		v2()
		props.onConfirm()
	end, { props.onConfirm, v2 })

	local function fn2()
		return {
			ViewFrame = React.createElement(
				View,
				{ tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top" },
				{
					GraphicContainer = React.createElement(
						View,
						{
							tag = "row size-full-0 auto-y align-x-center padding-bottom-xxlarge",
							LayoutOrder = 1
						},
						{
							BeforeItem = React.createElement(CatalogItemCard, {
								AutomaticSize = Enum.AutomaticSize.XY,
								LayoutOrder = 1,
								Selectable = false,
								presentationSlot = React.createElement(
									View,
									{ Size = UDim2.fromOffset(80, 80) },
									React.createElement(ItemCardThumbnail, {
										url = fn(props.beforeItem.itemId, props.beforeItem.thumbType) -- inferred equivalent call
									})
								)
							}),
							ReplaceIcon = React.createElement(
								View,
								{
									Size = UDim2.fromOffset(60, 80),
									LayoutOrder = 2,
									tag = "row auto-x auto-y align-x-center align-y-center"
								},
								React.createElement(Foundation.Icon, {
									name = BuilderIcons.Icon.TwoArrowsSpinClockwise,
									size = IconSize.Large,
									variant = BuilderIcons.IconVariant.Regular
								})
							),
							AfterItem = React.createElement(CatalogItemCard, {
								AutomaticSize = Enum.AutomaticSize.XY,
								LayoutOrder = 3,
								Selectable = false,
								presentationSlot = React.createElement(
									View,
									{ Size = UDim2.fromOffset(80, 80) },
									React.createElement(ItemCardThumbnail, {
										url = fn(props.afterItem.itemId, props.afterItem.thumbType) -- inferred equivalent call
									})
								)
							})
						}
					),
					PromptBodyTitle = React.createElement(Text, {
						tag = "auto-xy padding-bottom-small padding-top-large text-align-x-left text-heading-small text-wrap",
						Text = v.titleText,
						LayoutOrder = 2
					}),
					PromptBodyText = React.createElement(Text, {
						tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
						Text = v.bodyText,
						LayoutOrder = 3
					})
				}
			)
		}
	end

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v3,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v3,
						text = v.confirmButtonText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, fn2())
end

return (withMappedNavigationParams(ItemReplacedOnAvatarPrompt))
