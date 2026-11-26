local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
local getFoundationIconName = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/getFoundationIconName")

local axPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal

local useTokens = Foundation.Hooks.useTokens
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local fFlagAXPartialPageModalBackgroundShim = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXPartialPageModalBackgroundShim
local defineFastFlag = game:DefineFastFlag("AXUpdateOffersModalHero", false)

local udim = UDim2.new(0.5, -82, 0.5, 12)

local udim2 = UDim2.new(0.5, 92, 0.5, -19)
local v5 = defineFastFlag and 230 or 540

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function getTermsScrollHeight(p2)
	local v6 = p2.X < 540

	return (math.clamp(math.floor(p2.Y * (v6 and 0.35 or 0.5)), 180, v6 and 280 or v5))
end

local function RichTextBlock(props)
	return React.createElement(Foundation.Text, {
		tag = props.tag,
		Text = props.segment,
		RichText = true,
		LayoutOrder = props.layoutOrder
	})
end

local function HeroFrame(props)
	local v6 = useTokens()

	return React.createElement(Foundation.View, {
		testId = props.testId,
		tag = "bg-surface-100 stroke-standard stroke-emphasis",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = props.position,
		Size = UDim2.fromOffset(props.framePx, props.framePx),
		Rotation = props.rotation,
		ZIndex = props.zIndex,
		cornerRadius = UDim.new(0, v6.Radius.Small)
	}, {
		IconCenter = React.createElement(
			Foundation.View,
			{ tag = "size-full col align-x-center align-y-center" },
			{
				Glyph = React.createElement(Foundation.Icon, {
					testId = `{props.testId}Icon`,
					name = props.iconName,
					variant = iconVariant.Regular,
					size = props.iconSize,
					style = v6.Color.Content.Emphasis
				})
			}
		)
	})
end

local function CatalogOffersBannerOfferModals(props)
	local v6 = useTokens()
	local v7 = useLocalization({
		viewTermsButtonText = "Feature.Catalog.Action.ViewTerms"
	})

	local modal = props.modal
	local onOpenTermsModal = props.onOpenTermsModal
	local termsBody = modal.termsBody
	local v8 = not (termsBody == nil) and termsBody ~= ""
	local v9 = if v8 then modal.offerBodyLinkText .. " " else modal.offerBodyLinkText
	local v10 = useSelector(selectScreenSize)
	local v11 = v10.X < 540

	local v13 = math.clamp(math.floor(v10.Y * (v11 and 0.35 or 0.5)), 180, v11 and 280 or v5)

	local createElement = React.createElement
	local view = Foundation.View

	local v16 = if v9 ~= "" then React.createElement(RichTextBlock, {
		segment = v9,
		tag = "auto-xy text-body-medium text-wrap text-align-x-left",
		layoutOrder = 1
	}) else nil

	local v17 = if v8 then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-medium text-wrap text-align-x-left content-muted",
		Text = `<u>{v7.viewTermsButtonText}</u>`,
		RichText = true,
		onActivated = onOpenTermsModal,
		LayoutOrder = 2
	}) else nil
	local element = createElement(
		view,
		{ tag = "row wrap align-x-left align-y-top gap-xsmall size-full-0 auto-y" },
		{ Body = v16, TermsLink = v17 }
	)
	local v18

	if props.offersModalOpen then
		local createElement2 = React.createElement

		local v20 = {
			visible = true,
			onBackgroundPress = props.onCloseOffersModal,
			hasBackgroundShim = fFlagAXPartialPageModalBackgroundShim and true or nil,
			buttonStackProps = {
				rowLayout = false,
				buttons = {
					{
						props = {
							text = props.okButtonText,
							variant = buttonVariant.Emphasis,
							size = inputSize.Medium,
							onActivated = props.onCloseOffersModal
						}
					}
				}
			}
		}

		local createElement3 = React.createElement
		local view2 = Foundation.View

		local createElement4 = React.createElement
		local view3 = Foundation.View

		local createElement5 = React.createElement
		local view4 = Foundation.View
		local v25 = {
			tag = {
				["row align-x-center align-y-center auto-y"] = true,
				["padding-bottom-xxlarge"] = defineFastFlag
			},
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 136)
		}

		local createElement6 = React.createElement
		local view5 = Foundation.View
		local v27 = { Size = UDim2.fromOffset(136, 136), BackgroundTransparency = 1 }

		local v29 = if not defineFastFlag then React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(108, 108),
			BackgroundTransparency = 1,
			Rotation = -15,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			cornerRadius = UDim.new(0, v6.Radius.Small),
			stroke = {
				Color = v6.Color.Content.Emphasis.Color3,
				Thickness = v6.Stroke.Standard,
				Transparency = 0.84
			}
		}, {
			IconCounterRotate = React.createElement(
				Foundation.View,
				{ tag = "size-full", BackgroundTransparency = 1, Rotation = 15 },
				{
					Icon = React.createElement(Foundation.Icon, {
						name = getFoundationIconName(modal.modalHeroIcon),
						variant = iconVariant.Regular,
						size = 64,
						style = v6.Color.Content.Emphasis,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					})
				}
			)
		}) else nil

		local v30 = if defineFastFlag then React.createElement(HeroFrame, {
			framePx = 74,
			position = udim,
			rotation = 15,
			zIndex = 1,
			iconName = iconName.Shirt,
			iconSize = v6.Size.Size_1200,
			testId = "CatalogOffersModalHeroFrameLeft"
		}) else nil

		local v31 = if defineFastFlag then React.createElement(HeroFrame, {
			framePx = 84,
			position = udim2,
			rotation = 15,
			zIndex = 1,
			iconName = iconName.Shoe,
			iconSize = v6.Size.Size_1200,
			testId = "CatalogOffersModalHeroFrameRight"
		}) else nil

		local v32 = if defineFastFlag then React.createElement(HeroFrame, {
			framePx = v6.Size.Size_2600,
			position = UDim2.fromScale(0.5, 0.5),
			rotation = -15,
			zIndex = 2,
			iconName = getFoundationIconName(modal.modalHeroIcon),
			iconSize = v6.Size.Size_1600,
			testId = "CatalogOffersModalHeroFrame"
		}) else nil
		v18 = createElement2(axPartialPageModal, v20, {
			ViewFrame = createElement3(view2, {
				tag = {
					["col align-x-left align-y-top size-full-0 auto-y"] = true,
					["padding-bottom-xxlarge"] = defineFastFlag,
					["padding-y-xxlarge"] = not defineFastFlag
				}
			}, {
				Contents = createElement4(view3, {
					tag = {
						["col align-x-left gap-medium size-full-0 auto-y"] = true,
						["padding-y-xlarge"] = not defineFastFlag
					}
				}, {
					HeroIcon = createElement5(view4, v25, {
						HeroIconSlot = createElement6(view5, v27, {
							TiltedSquare = v29,
							HeroFrameLeft = v30,
							HeroFrameRight = v31,
							HeroFrame = v32
						})
					}),
					ModalTitle = React.createElement(Foundation.Text, {
						tag = "size-full-0 auto-xy padding-bottom-small text-heading-small text-wrap text-align-x-left",
						Text = modal.modalTitle,
						LayoutOrder = 1
					}),
					ModalBody = React.createElement(
						Foundation.View,
						{ tag = "size-full-0 auto-y", LayoutOrder = 2 },
						{ Body = element }
					)
				})
			})
		})
	end

	local v19

	if props.termsModalOpen and v8 then
		local createElement2 = React.createElement

		local v21 = {
			visible = true,
			onBackgroundPress = props.onCloseTermsModal,
			hasBackgroundShim = fFlagAXPartialPageModalBackgroundShim and true or nil,
			buttonStackProps = {
				rowLayout = false,
				buttons = {
					{
						props = {
							text = props.okButtonText,
							variant = buttonVariant.Standard,
							size = inputSize.Medium,
							onActivated = props.onCloseTermsModal
						}
					}
				}
			}
		}

		local createElement3 = React.createElement
		local view2 = Foundation.View

		local v25 = if modal.termsModalTitle then React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-xy text-heading-small text-wrap text-align-x-left",
			Text = modal.termsModalTitle,
			LayoutOrder = 1
		}) else nil
		v19 = createElement2(axPartialPageModal, v21, {
			ViewFrame = createElement3(view2, {
				tag = {
					["col align-x-left gap-medium size-full-0 auto-y"] = true,
					["padding-bottom-large"] = defineFastFlag,
					["padding-y-large"] = not defineFastFlag
				}
			}, {
				TermsTitle = v25,
				TermsScroll = React.createElement(Foundation.ScrollView, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v13),
					scroll = {
						scrollBarVisibility = Foundation.Enums.Visibility.None,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.fromScale(0, 1)
					},
					selection = { Selectable = false }
				}, {
					TermsBody = React.createElement(Foundation.Text, {
						tag = "size-full-0 auto-xy padding-bottom-large text-body-medium text-wrap text-align-x-left",
						Text = termsBody or "",
						RichText = true,
						selection = { Selectable = false }
					})
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, {
		OffersModal = v18,
		TermsModal = v19
	})
end

return CatalogOffersBannerOfferModals
