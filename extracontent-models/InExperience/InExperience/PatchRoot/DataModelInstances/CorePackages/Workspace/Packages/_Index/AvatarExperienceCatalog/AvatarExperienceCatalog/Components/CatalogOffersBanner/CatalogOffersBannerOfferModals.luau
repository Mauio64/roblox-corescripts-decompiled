local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)
local getFoundationIconName = require(script.Parent.getFoundationIconName)

local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal

local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXPartialPageModalBackgroundShim = AvatarExperienceFlags.FFlagAXPartialPageModalBackgroundShim
local defineFastFlag = game:DefineFastFlag("AXUpdateOffersModalHero", false)

local udim = UDim2.new(0.5, -82, 0.5, 12)

local udim2 = UDim2.new(0.5, 92, 0.5, -19)
local v = defineFastFlag and 230 or 540

local function selectScreenSize(p)
	return p.ScreenSize
end

local function getTermsScrollHeight(vector2: Vector2) -- 1 equivalent call inferred from this helper
	local v2 = vector2.X < 540

	return (math.clamp(math.floor(vector2.Y * (v2 and 0.35 or 0.5)), 180, v2 and 280 or v))
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
	local v2 = useTokens()

	return React.createElement(Foundation.View, {
		testId = props.testId,
		tag = "bg-surface-100 stroke-standard stroke-emphasis",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = props.position,
		Size = UDim2.fromOffset(props.framePx, props.framePx),
		Rotation = props.rotation,
		ZIndex = props.zIndex,
		cornerRadius = UDim.new(0, v2.Radius.Small)
	}, {
		IconCenter = React.createElement(Foundation.View, {
			tag = "size-full col align-x-center align-y-center"
		}, {
			Glyph = React.createElement(Foundation.Icon, {
				testId = `{props.testId}Icon`,
				name = props.iconName,
				variant = IconVariant.Regular,
				size = props.iconSize,
				style = v2.Color.Content.Emphasis
			})
		})
	})
end

local function CatalogOffersBannerOfferModals(props)
	local v2 = useTokens()
	local v3 = useLocalization({ viewTermsButtonText = "Feature.Catalog.Action.ViewTerms" })

	local modal = props.modal
	local onOpenTermsModal = props.onOpenTermsModal
	local termsBody = modal.termsBody
	local v4

	if termsBody == nil then
		v4 = false
	else
		v4 = termsBody ~= ""
	end

	local segment

	if v4 then
		segment = modal.offerBodyLinkText .. " "
	else
		segment = modal.offerBodyLinkText
	end

	local termsScrollHeight = getTermsScrollHeight(useSelector(selectScreenSize)) -- inferred equivalent call

	local createElement = React.createElement
	local view = Foundation.View
	local body

	if segment ~= "" then
		body = React.createElement(RichTextBlock, {
			segment = segment,
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			layoutOrder = 1
		})
	end

	local termsLink

	if v4 then
		termsLink = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left content-muted",
			Text = `<u>{v3.viewTermsButtonText}</u>`,
			RichText = true,
			onActivated = onOpenTermsModal,
			LayoutOrder = 2
		})
	end

	local element = createElement(view, {
		tag = "row wrap align-x-left align-y-top gap-xsmall size-full-0 auto-y"
	}, {
		Body = body,
		TermsLink = termsLink
	})
	local offersModal

	if props.offersModalOpen then
		local createElement2 = React.createElement

		local v5 = {
			visible = true,
			onBackgroundPress = props.onCloseOffersModal,
			hasBackgroundShim = FFlagAXPartialPageModalBackgroundShim and true or nil,
			buttonStackProps = {
				rowLayout = false,
				buttons = {
					{
						props = {
							text = props.okButtonText,
							variant = ButtonVariant.Emphasis,
							size = InputSize.Medium,
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
		local v6 = {
			tag = {
				["row align-x-center align-y-center auto-y"] = true,
				["padding-bottom-xxlarge"] = defineFastFlag
			},
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 136)
		}

		local createElement6 = React.createElement
		local view5 = Foundation.View
		local v7 = { Size = UDim2.fromOffset(136, 136), BackgroundTransparency = 1 }
		local tiltedSquare

		if not defineFastFlag then
			tiltedSquare = React.createElement(Foundation.View, {
				Size = UDim2.fromOffset(108, 108),
				BackgroundTransparency = 1,
				Rotation = -15,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				cornerRadius = UDim.new(0, v2.Radius.Small),
				stroke = {
					Color = v2.Color.Content.Emphasis.Color3,
					Thickness = v2.Stroke.Standard,
					Transparency = 0.84
				}
			}, {
				IconCounterRotate = React.createElement(
					Foundation.View,
					{ tag = "size-full", BackgroundTransparency = 1, Rotation = 15 },
					{
						Icon = React.createElement(Foundation.Icon, {
							name = getFoundationIconName(modal.modalHeroIcon),
							variant = IconVariant.Regular,
							size = 64,
							style = v2.Color.Content.Emphasis,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5)
						})
					}
				)
			})
		end

		local heroFrameLeft

		if defineFastFlag then
			heroFrameLeft = React.createElement(HeroFrame, {
				framePx = 74,
				position = udim,
				rotation = 15,
				zIndex = 1,
				iconName = IconName.Shirt,
				iconSize = v2.Size.Size_1200,
				testId = "CatalogOffersModalHeroFrameLeft"
			})
		end

		local heroFrameRight

		if defineFastFlag then
			heroFrameRight = React.createElement(HeroFrame, {
				framePx = 84,
				position = udim2,
				rotation = 15,
				zIndex = 1,
				iconName = IconName.Shoe,
				iconSize = v2.Size.Size_1200,
				testId = "CatalogOffersModalHeroFrameRight"
			})
		end

		local heroFrame

		if defineFastFlag then
			heroFrame = React.createElement(HeroFrame, {
				framePx = v2.Size.Size_2600,
				position = UDim2.fromScale(0.5, 0.5),
				rotation = -15,
				zIndex = 2,
				iconName = getFoundationIconName(modal.modalHeroIcon),
				iconSize = v2.Size.Size_1600,
				testId = "CatalogOffersModalHeroFrame"
			})
		end

		offersModal = createElement2(AXPartialPageModal, v5, {
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
					HeroIcon = createElement5(view4, v6, {
						HeroIconSlot = createElement6(view5, v7, {
							TiltedSquare = tiltedSquare,
							HeroFrameLeft = heroFrameLeft,
							HeroFrameRight = heroFrameRight,
							HeroFrame = heroFrame
						})
					}),
					ModalTitle = React.createElement(Foundation.Text, {
						tag = "size-full-0 auto-xy padding-bottom-small text-heading-small text-wrap text-align-x-left",
						Text = modal.modalTitle,
						LayoutOrder = 1
					}),
					ModalBody = React.createElement(Foundation.View, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 2
					}, {
						Body = element
					})
				})
			})
		})
	end

	local termsModal

	if props.termsModalOpen and v4 then
		local createElement2 = React.createElement

		local v5 = {
			visible = true,
			onBackgroundPress = props.onCloseTermsModal,
			hasBackgroundShim = FFlagAXPartialPageModalBackgroundShim and true or nil,
			buttonStackProps = {
				rowLayout = false,
				buttons = {
					{
						props = {
							text = props.okButtonText,
							variant = ButtonVariant.Standard,
							size = InputSize.Medium,
							onActivated = props.onCloseTermsModal
						}
					}
				}
			}
		}

		local createElement3 = React.createElement
		local view2 = Foundation.View
		local termsTitle

		if modal.termsModalTitle then
			termsTitle = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-xy text-heading-small text-wrap text-align-x-left",
				Text = modal.termsModalTitle,
				LayoutOrder = 1
			})
		end

		termsModal = createElement2(AXPartialPageModal, v5, {
			ViewFrame = createElement3(view2, {
				tag = {
					["col align-x-left gap-medium size-full-0 auto-y"] = true,
					["padding-bottom-large"] = defineFastFlag,
					["padding-y-large"] = not defineFastFlag
				}
			}, {
				TermsTitle = termsTitle,
				TermsScroll = React.createElement(Foundation.ScrollView, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, termsScrollHeight),
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
		OffersModal = offersModal,
		TermsModal = termsModal
	})
end

return CatalogOffersBannerOfferModals
