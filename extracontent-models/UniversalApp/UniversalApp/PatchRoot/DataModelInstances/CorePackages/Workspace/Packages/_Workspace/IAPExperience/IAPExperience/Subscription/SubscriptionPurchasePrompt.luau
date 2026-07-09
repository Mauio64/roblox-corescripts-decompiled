local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UrlBuilder = require(ParentParentParent.UrlBuilder).UrlBuilder
local NavigateDown = require(ParentParentParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ParentParentParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v6 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local useDispatch = require(ParentParentParent.RoactUtils).Hooks.RoactRodux.useDispatch
local AppPage = require(ParentParentParent.RobloxAppEnums).AppPage
local TextService = game:GetService("TextService")
local VerifiedBadges = require(ParentParentParent.VerifiedBadges)
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local SubscriptionTitle = require(ParentParent.Subscription.SubscriptionTitle)
local getEnableDisableSubPurchase = require(ParentParent.Flags.getEnableDisableSubPurchase)
local FFlagHideDevSubsPriceIfSubscribed = require(ParentParent.Parent.SharedFlags).FFlagHideDevSubsPriceIfSubscribed
local FFlagEnableDevSubsFastFollowFixes = require(ParentParent.Parent.SharedFlags).FFlagEnableDevSubsFastFollowFixes

local function generateTestmodeDisclaimer(p1, p2, p3, p4) -- line: 88
	-- upvalues: TextService (copy), React (copy)
	local v39 = TextService:GetTextSize(p1, 12, p2.Footer.Font, Vector2.new(p4, 1e999)).Y + 2

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 16),
		Size = UDim2.new(1, -48, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		DisclaimerText = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			TextWrapped = true,
			TextSize = 12,
			Size = UDim2.new(1, 0, 0, v39),
			Font = p2.Footer.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = p1,
			TextColor3 = p3.TextDefault.Color
		})
	})
end
local function generatePromptText(p5, p6, p7, p8, p9, p10) -- line: 118
	-- upvalues: React (copy), TextService (copy)
	return React.createElement("TextLabel", {
		LayoutOrder = p10 or 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, p8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = p6.Body.Font,
		Text = p5.description,
		TextSize = 16,
		TextWrapped = true,
		TextColor3 = p7.TextDefault.Color,
		TextTransparency = p7.TextDefault.Transparency,
		RichText = true,
		[React.Change.AbsoluteSize] = function(p11) -- line: 132
			-- upvalues: TextService (copy), p9 (copy)
			local Y = TextService:GetTextSize(p11.Text, p11.TextSize, p11.Font, Vector2.new(p11.AbsoluteSize.X, 1e999)).Y

			p9(Y)
		end
	})
end
local function createSubscribeButtonStacks(t1: {[any]: any}, p12) -- line: 140
	-- upvalues: getEnableDisableSubPurchase (copy), ButtonType (copy)
	if (getEnableDisableSubPurchase() or t1.shouldUseNewModalDesign) and t1.disablePurchase then
		return {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				isDisabled = true,
				layoutOrder = 0,
				onActivated = function() -- line: 146
				end,
				text = t1.disablePurchaseText
			}
		}}
	end

	if t1.secondaryPaymentMethod == nil or t1.secondaryPaymentMethod == "" then
		return {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				layoutOrder = 0,
				onActivated = function() -- line: 160
					-- upvalues: t1 (copy)
					t1.purchaseSubscriptionActivated(t1.primaryPaymentMethod)
				end,
				text = p12.subscribe
			}
		}}
	end

	local subscribeWithCreditDebitCard = nil

	if t1.primaryPaymentMethod == "Stripe" then
		subscribeWithCreditDebitCard = p12.subscribeWithCreditDebitCard
	elseif t1.primaryPaymentMethod == "CreditBalance" then
		subscribeWithCreditDebitCard = p12.subscribeWithRobloxCredit
	end

	return {
		{
			buttonType = ButtonType.PrimarySystem,
			props = {
				layoutOrder = 0,
				onActivated = function() -- line: 181
					-- upvalues: t1 (copy)
					t1.purchaseSubscriptionActivated(t1.primaryPaymentMethod)
				end,
				text = subscribeWithCreditDebitCard
			}
		},
		{
			buttonType = ButtonType.Secondary,
			props = {
				layoutOrder = 1,
				onActivated = function() -- line: 191
					-- upvalues: t1 (copy)
					t1.purchaseSubscriptionActivated(t1.secondaryPaymentMethod)
				end,
				text = p12.payAnotherWay
			}
		}
	}
end
local function generateDisclosure(p13, p14) -- line: 201
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	local parts = string.split(p13.DisclosureTermsURL, " {termsofuse} ")
	local v52 = "<u>" .. p13.TermsOfUse .. "</u>"

	return React.createElement(View, {
		tag = "row wrap auto-y align-y-center align-x-center size-full-0 gap-xsmall padding-x-xsmall padding-bottom-xsmall"
	}, {
		DisclosurePayment = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
			Text = p13.DisclosurePayment
		}),
		BeforeText = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
			Text = parts[1]
		}),
		TextLink = React.createElement(FoundationText, {
			LayoutOrder = 3,
			RichText = true,
			tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
			Text = v52,
			onActivated = p14
		}),
		AfterText = React.createElement(FoundationText, {
			LayoutOrder = 4,
			tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
			Text = parts[2]
		})
	})
end
local function renderNewModalDesign(t2: {[any]: any}, p15, p16, p17, p18, p19, p20, p21, p22) -- line: 234
	-- upvalues: VerifiedBadges (copy), getIconRichText (copy), Enums (copy), React (copy), PartialPageModal (copy), createSubscribeButtonStacks (copy), generateTestmodeDisclaimer (copy), FFlagEnableDevSubsFastFollowFixes (copy), generateDisclosure (copy), ImageSetLabel (copy), View (copy), FoundationText (copy), FFlagHideDevSubsPriceIfSubscribed (copy), Foundation (copy), generatePromptText (copy)
	local v62 = if not t2.creatorName then nil else t2.creatorName .. " " .. (t2.creatorVerified and VerifiedBadges.emoji.verified or "")
	local v63 = (not t2.isRobuxSubscription and "" or getIconRichText(Enums.IconName.Robux) .. " ") .. t2.displayPrice .. t2.period

	return React.createElement(PartialPageModal, {
		screenSize = t2.screenSize,
		contentPadding = UDim.new(0, 24),
		buttonStackProps = {
			buttonHeight = 48,
			buttons = createSubscribeButtonStacks(t2, p15),
			forcedFillDirection = Enum.FillDirection.Vertical
		},
		onCloseClicked = t2.cancelPurchaseActivated,
		footerContent = function() -- line: 260
			-- upvalues: t2 (copy), generateTestmodeDisclaimer (copy), p15 (copy), p17 (copy), p16 (copy), p18 (copy), FFlagEnableDevSubsFastFollowFixes (copy), generateDisclosure (copy), p20 (copy)
			if t2.isTestingMode then
				return generateTestmodeDisclaimer(p15.footerText, p17, p16, p18)
			end

			if FFlagEnableDevSubsFastFollowFixes then
				return nil
			end

			return generateDisclosure(p15, p20)
		end
	}, { React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		PromptScroll = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			BorderSizePixel = 0,
			ZIndex = 2,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, (math.min(p19, t2.screenSize.Y - 240))),
			ScrollingEnabled = p19 > t2.screenSize.Y - 240,
			ScrollBarThickness = if not (p19 > t2.screenSize.Y - 240) then nil else 5,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.new(1, 0, 0, p19)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			HeroImage = React.createElement(ImageSetLabel, {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150, 0, 150),
				ScaleType = Enum.ScaleType.Fit,
				Image = t2.itemIcon
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				})
			}),
			AttributionSection = React.createElement(View, {
				LayoutOrder = 1,
				tag = "auto-xy col align-x-start size-full-0"
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, 4)
				}),
				SubscriptionName = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy content-emphasis text-align-x-left",
					Text = t2.name,
					fontStyle = p22.Typography.HeadingSmall
				}),
				CreatorName = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy content-default text-align-x-left",
					Text = v62,
					fontStyle = p22.Typography.TitleLarge
				}),
				PriceRow = if not not t2.disablePurchase and FFlagHideDevSubsPriceIfSubscribed then nil else React.createElement(FoundationText, {
					LayoutOrder = 3,
					RichText = true,
					tag = "auto-xy content-emphasis text-align-x-left",
					Text = v63,
					fontStyle = p22.Typography.TitleLarge
				})
			}),
			ActionButtonsRow = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row gap-small auto-y size-full-0 align-x-left"
			}, {
				ShareButton = if not t2.onShare then nil else React.createElement(Foundation.Chip, {
					LayoutOrder = 1,
					text = p15.shareText,
					leading = {
						iconName = Enums.IconName.ArrowThickToRight
					},
					size = Enums.ChipSize.Small,
					onActivated = t2.onShare
				}),
				ReportButton = if not t2.onReport then nil else React.createElement(Foundation.Chip, {
					LayoutOrder = 2,
					text = p15.reportText,
					leading = {
						iconName = Enums.IconName.Flag
					},
					size = Enums.ChipSize.Small,
					onActivated = t2.onReport
				})
			}),
			generatePromptText(t2, p17, p16, p18, p21, 3)
		})
	}) })
end
local function SubscriptionPurchasePrompt(t3: {[any]: any}) -- line: 372
	-- upvalues: React (copy), useDispatch (copy), useTokens (copy), UrlBuilder (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v6 (copy), NavigateDown (copy), SubscriptionTitle (copy), MultiTextLocalizer (copy), withStyle (copy), getPartialPageModalMiddleContentWidth (copy), renderNewModalDesign (copy), PartialPageModal (copy), createSubscribeButtonStacks (copy), generateTestmodeDisclaimer (copy), FFlagEnableDevSubsFastFollowFixes (copy), generateDisclosure (copy), generatePromptText (copy)
	local v65, v66 = React.useState(0)
	local v67 = useDispatch()
	local v68 = useTokens()

	local function openTermsOfUse() -- line: 377
		-- upvalues: UrlBuilder (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v6 (copy), v67 (copy), NavigateDown (copy)
		local v73 = UrlBuilder.static.about.terms()
		local t4 = {
			name = AppPage.GenericWebPage,
			detail = v73
		}

		if FFlagSignalsNavP3Dispatch then
			v6.down(v6.fromLegacyPage(t4))

			return
		end

		v67(NavigateDown(t4))
	end
	local function calculatePromptHeight(p23) -- line: 390
		-- upvalues: t3 (copy), v66 (copy), SubscriptionTitle (copy)
		if t3.shouldUseNewModalDesign then
			v66(338 + p23 + 24)

			return
		end

		v66(24 + SubscriptionTitle:getTitleHeight(t3.screenSize.Y - 240) + 24 + p23)
	end

	return React.createElement(MultiTextLocalizer, {
		keys = {
			titleText = {
				key = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription"
			},
			subscribe = {
				key = "Feature.Subscription.Action.Subscribe"
			},
			subscribeWithCreditDebitCard = {
				key = "Feature.Subscription.Action.SubscribeWithCreditDebitCard"
			},
			subscribeWithRobloxCredit = {
				key = "Feature.Subscription.Action.SubscribeWithRobloxCredit"
			},
			payAnotherWay = {
				key = "Feature.Subscription.Action.SubscribePayAnotherWay"
			},
			footerText = {
				key = "IAPExperience.SubscriptionPurchasePrompt.Label.TestFlowDisclaimer"
			},
			DisclosurePayment = {
				key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment"
			},
			DisclosureTermsURL = {
				key = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL"
			},
			TermsOfUse = {
				key = "IAPExperience.RobuxUpsell.Text.TermsOfUse"
			},
			shareText = {
				key = "Feature.SocialShare.Action.Share"
			},
			reportText = {
				key = "Feature.GameDetails.Action.Report"
			}
		},
		render = function(p24) -- line: 427
			-- upvalues: withStyle (copy), getPartialPageModalMiddleContentWidth (copy), t3 (copy), renderNewModalDesign (copy), v65 (copy), openTermsOfUse (copy), calculatePromptHeight (copy), v68 (copy), React (copy), PartialPageModal (copy), createSubscribeButtonStacks (copy), generateTestmodeDisclaimer (copy), FFlagEnableDevSubsFastFollowFixes (copy), generateDisclosure (copy), SubscriptionTitle (copy), generatePromptText (copy)
			return withStyle(function(p25) -- line: 428
				-- upvalues: getPartialPageModalMiddleContentWidth (copy), t3 (copy), renderNewModalDesign (copy), p24 (copy), v65 (copy), openTermsOfUse (copy), calculatePromptHeight (copy), v68 (copy), React (copy), PartialPageModal (copy), createSubscribeButtonStacks (copy), generateTestmodeDisclaimer (copy), FFlagEnableDevSubsFastFollowFixes (copy), generateDisclosure (copy), SubscriptionTitle (copy), generatePromptText (copy)
				local Theme = p25.Theme
				local p25Font = p25.Font
				local v80 = getPartialPageModalMiddleContentWidth(t3.screenSize.X)

				if t3.shouldUseNewModalDesign then
					return renderNewModalDesign(t3, p24, Theme, p25Font, v80, v65, openTermsOfUse, calculatePromptHeight, v68)
				end

				return React.createElement(PartialPageModal, {
					title = p24.titleText,
					screenSize = t3.screenSize,
					contentPadding = UDim.new(0, 24),
					buttonStackProps = {
						buttonHeight = 48,
						buttons = createSubscribeButtonStacks(t3, p24),
						forcedFillDirection = Enum.FillDirection.Vertical
					},
					onCloseClicked = t3.cancelPurchaseActivated,
					footerContent = function() -- line: 457
						-- upvalues: t3 (copy), generateTestmodeDisclaimer (copy), p24 (copy), p25Font (copy), Theme (copy), v80 (copy), FFlagEnableDevSubsFastFollowFixes (copy), generateDisclosure (copy), openTermsOfUse (copy)
						if t3.isTestingMode then
							return generateTestmodeDisclaimer(p24.footerText, p25Font, Theme, v80)
						end

						if FFlagEnableDevSubsFastFollowFixes then
							return nil
						end

						return generateDisclosure(p24, openTermsOfUse)
					end
				}, { React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					PromptScroll = React.createElement("ScrollingFrame", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						BorderSizePixel = 0,
						ZIndex = 2,
						Selectable = false,
						Size = UDim2.new(1, 0, 0, (math.min(v65, t3.screenSize.Y - 240))),
						ScrollingEnabled = v65 > t3.screenSize.Y - 240,
						ScrollBarThickness = if not (v65 > t3.screenSize.Y - 240) then nil else 5,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						CanvasSize = UDim2.new(1, 0, 0, v65)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24),
							PaddingBottom = UDim.new(0, 24)
						}),
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 24)
						}),
						SubscriptionTitleSection = React.createElement(SubscriptionTitle, {
							layoutOrder = 2,
							subscriptionProviderName = t3.subscriptionProviderName,
							name = t3.name,
							displayPrice = t3.displayPrice,
							period = t3.period,
							disclaimerText = t3.disclaimerText,
							contentHeight = t3.screenSize.Y - 240,
							itemIcon = t3.itemIcon
						}),
						generatePromptText(t3, p25Font, Theme, v80, calculatePromptHeight, 2)
					})
				}) })
			end)
		end
	})
end

return SubscriptionPurchasePrompt
