local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local useSelector = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)

local getFoundationIconName = require(script.Parent.getFoundationIconName)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local useTokens = Foundation.Hooks.useTokens
local IconVariant = Foundation.Enums.IconVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FFlagAXPartialPageModalBackgroundShim = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXPartialPageModalBackgroundShim

local function selectScreenSize(p1) -- line: 46
	return p1.ScreenSize
end
local function getTermsScrollHeight(vector2: Vector2) -- line: 50
	local v21 = vector2.X < 540
	local v22 = not v21 and 0.5 or 0.35
	local v23 = not v21 and 540 or 280

	return (math.clamp(math.floor(vector2.Y * v22), 180, v23))
end
local function RichTextBlock(t1: {[any]: any}) -- line: 64
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Text, {
		RichText = true,
		tag = t1.tag,
		Text = t1.segment,
		LayoutOrder = t1.layoutOrder
	})
end
local function CatalogOffersBannerOfferModals(t2: {[any]: any}) -- line: 83
	-- upvalues: useTokens (copy), useLocalization (copy), useSelector (copy), selectScreenSize (copy), React (copy), Foundation (copy), RichTextBlock (copy), AXPartialPageModal (copy), FFlagAXPartialPageModalBackgroundShim (copy), ButtonVariant (copy), InputSize (copy), getFoundationIconName (copy), IconVariant (copy)
	local v26 = useTokens()
	local v27 = useLocalization({
		viewTermsButtonText = "Feature.Catalog.Action.ViewTerms"
	})
	local modal = t2.modal
	local onOpenTermsModal = t2.onOpenTermsModal
	local termsBody = modal.termsBody
	local v31 = termsBody ~= nil and termsBody ~= ""
	local v32 = if not v31 then modal.offerBodyLinkText else modal.offerBodyLinkText .. " "
	local v33 = useSelector(selectScreenSize)
	local v34 = v33.X < 540
	local v35 = not v34 and 0.5 or 0.35
	local v36 = not v34 and 540 or 280
	local v37 = math.clamp(math.floor(v33.Y * v35), 180, v36)
	local v38 = React.createElement(Foundation.View, {
		tag = "row wrap align-x-left align-y-top gap-xsmall size-full-0 auto-y"
	}, {
		Body = if v32 == "" then nil else React.createElement(RichTextBlock, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			layoutOrder = 1,
			segment = v32
		}),
		TermsLink = if not v31 then nil else React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left content-muted",
			RichText = true,
			LayoutOrder = 2,
			Text = `<u>{ v27.viewTermsButtonText }</u>`,
			onActivated = onOpenTermsModal
		})
	})
	local v39 = if not t2.offersModalOpen then nil else React.createElement(AXPartialPageModal, {
		visible = true,
		onBackgroundPress = t2.onCloseOffersModal,
		hasBackgroundShim = not not FFlagAXPartialPageModalBackgroundShim or nil,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					text = t2.okButtonText,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					onActivated = t2.onCloseOffersModal
				}
			}}
		}
	}, {
		ViewFrame = React.createElement(Foundation.View, {
			tag = "col align-x-left align-y-top size-full-0 auto-y padding-y-xxlarge"
		}, {
			Contents = React.createElement(Foundation.View, {
				tag = "col align-x-left gap-medium size-full-0 auto-y padding-y-xlarge"
			}, {
				HeroIcon = React.createElement(Foundation.View, {
					tag = "row align-x-center align-y-center auto-y",
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 136)
				}, {
					HeroIconSlot = React.createElement(Foundation.View, {
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(136, 136)
					}, {
						TiltedSquare = React.createElement(Foundation.View, {
							BackgroundTransparency = 1,
							Rotation = -15,
							Size = UDim2.fromOffset(108, 108),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							cornerRadius = UDim.new(0, v26.Radius.Small),
							stroke = {
								Transparency = 0.84,
								Color = v26.Color.Content.Emphasis.Color3,
								Thickness = v26.Stroke.Standard
							}
						}, {
							IconCounterRotate = React.createElement(Foundation.View, {
								tag = "size-full",
								BackgroundTransparency = 1,
								Rotation = 15
							}, {
								Icon = React.createElement(Foundation.Icon, {
									size = 64,
									name = getFoundationIconName(modal.modalHeroIcon),
									variant = IconVariant.Regular,
									style = v26.Color.Content.Emphasis,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5)
								})
							})
						})
					})
				}),
				ModalTitle = React.createElement(Foundation.Text, {
					tag = "size-full-0 auto-xy padding-bottom-small text-heading-small text-wrap text-align-x-left",
					LayoutOrder = 1,
					Text = modal.modalTitle
				}),
				ModalBody = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					Body = v38
				})
			})
		})
	})
	local v40 = if not t2.termsModalOpen or not v31 then nil else React.createElement(AXPartialPageModal, {
		visible = true,
		onBackgroundPress = t2.onCloseTermsModal,
		hasBackgroundShim = not not FFlagAXPartialPageModalBackgroundShim or nil,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					text = t2.okButtonText,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium,
					onActivated = t2.onCloseTermsModal
				}
			}}
		}
	}, {
		ViewFrame = React.createElement(Foundation.View, {
			tag = "col align-x-left gap-medium size-full-0 auto-y padding-y-large"
		}, {
			TermsTitle = if not modal.termsModalTitle then nil else React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-xy text-heading-small text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = modal.termsModalTitle
			}),
			TermsScroll = React.createElement(Foundation.ScrollView, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v37),
				scroll = {
					scrollBarVisibility = Foundation.Enums.Visibility.None,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 1)
				},
				selection = {
					Selectable = false
				}
			}, {
				TermsBody = React.createElement(Foundation.Text, {
					tag = "size-full-0 auto-xy padding-bottom-large text-body-medium text-wrap text-align-x-left",
					RichText = true,
					Text = termsBody or "",
					selection = {
						Selectable = false
					}
				})
			})
		})
	})

	return React.createElement(React.Fragment, nil, {
		OffersModal = v39,
		TermsModal = v40
	})
end

return CatalogOffersBannerOfferModals
