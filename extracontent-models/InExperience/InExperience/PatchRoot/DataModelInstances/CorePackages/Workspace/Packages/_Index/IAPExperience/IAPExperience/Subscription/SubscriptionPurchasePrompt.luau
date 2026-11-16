local parent = script.Parent.Parent
local parent2 = parent.Parent
local UrlBuilder = require(parent2.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local NavigationRodux = require(parent2.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent2.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent2.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RoactUtils = require(parent2.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local TextService = game:GetService("TextService")

local VerifiedBadges = require(parent2.VerifiedBadges)
local React = require(parent2.React)
local Style = require(parent2.Style)
local GetTextSize = Style.GetTextSize

local UIBlox = require(parent2.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useTokens = Foundation.Hooks.useTokens

local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)
local SubscriptionTitle = require(parent.Subscription.SubscriptionTitle)

local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagHideDevSubsPriceIfSubscribed = SharedFlags2.FFlagHideDevSubsPriceIfSubscribed

local SharedFlags3 = require(parent.Parent.SharedFlags)
local FFlagEnableDevSubsFastFollowFixes = SharedFlags3.FFlagEnableDevSubsFastFollowFixes

local function generateTestmodeDisclaimer(footerText, p, p2, p3, p4)
	local v

	if FoundationFontFaceMigration then
		v = GetTextSize(footerText, 12, p4.Typography.CaptionSmall.Font, Vector2.new(p3, 1e999), {
			addTemporaryPadding = false
		}).Y + 2
	else
		v = TextService:GetTextSize(footerText, 12, p.Footer.Font, Vector2.new(p3, 1e999)).Y + 2
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 16),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, -48, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		DisclaimerText = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v),
			Font = if not FoundationFontFaceMigration then p.Footer.Font else nil,
			FontFace = if FoundationFontFaceMigration then normalizeFontFace(p4.Typography.CaptionSmall.Font) else nil,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Text = footerText,
			TextSize = 12,
			TextColor3 = p2.TextDefault.Color
		})
	})
end

local function generatePromptText(props, p, p2, p3, callback, value, p4)
	return React.createElement("TextLabel", {
		LayoutOrder = value or 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, p3, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = if not FoundationFontFaceMigration then p.Body.Font else nil,
		FontFace = if FoundationFontFaceMigration then normalizeFontFace(p4.Typography.BodyLarge.Font) else nil,
		Text = props.description,
		TextSize = 16,
		TextWrapped = true,
		TextColor3 = p2.TextDefault.Color,
		TextTransparency = p2.TextDefault.Transparency,
		RichText = true,
		[React.Change.AbsoluteSize] = function(data)
			local v = if FoundationFontFaceMigration then GetTextSize(
				data.Text,
				data.TextSize,
				p4.Typography.BodyLarge.Font,
				Vector2.new(data.AbsoluteSize.X, 1e999),
				{ addTemporaryPadding = false }
			).Y else TextService:GetTextSize(
				data.Text,
				data.TextSize,
				data.Font,
				Vector2.new(data.AbsoluteSize.X, 1e999)
			).Y
			callback(v)
		end
	})
end

local function createSubscribeButtonStacks(props, data)
	if props.disablePurchase then
		return {
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = function() end,
					isDisabled = true,
					text = props.disablePurchaseText,
					layoutOrder = 0
				}
			}
		}
	end

	if props.secondaryPaymentMethod == nil or props.secondaryPaymentMethod == "" then
		return {
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = function()
						props.purchaseSubscriptionActivated(props.primaryPaymentMethod)
					end,
					text = data.subscribe,
					layoutOrder = 0
				}
			}
		}
	end

	local text = nil

	if props.primaryPaymentMethod == "Stripe" then
		text = data.subscribeWithCreditDebitCard
	elseif props.primaryPaymentMethod == "CreditBalance" then
		text = data.subscribeWithRobloxCredit
	end

	return {
		{
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = function()
					props.purchaseSubscriptionActivated(props.primaryPaymentMethod)
				end,
				text = text,
				layoutOrder = 0
			}
		},
		{
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function()
					props.purchaseSubscriptionActivated(props.secondaryPaymentMethod)
				end,
				text = data.payAnotherWay,
				layoutOrder = 1
			}
		}
	}
end

local function generateDisclosure(props, onActivated)
	local v = string.split(props.DisclosureTermsURL, " {termsofuse} ")
	local text = "<u>" .. props.TermsOfUse .. "</u>"

	return React.createElement(
		View,
		{
			tag = "row wrap auto-y align-y-center align-x-center size-full-0 gap-xsmall padding-x-xsmall padding-bottom-xsmall"
		},
		{
			DisclosurePayment = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.DisclosurePayment,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			BeforeText = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v[1],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			TextLink = React.createElement(Text, {
				LayoutOrder = 3,
				RichText = true,
				Text = text,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				onActivated = onActivated
			}),
			AfterText = React.createElement(Text, {
				LayoutOrder = 4,
				Text = v[2],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			})
		}
	)
end

local function renderNewModalDesign(props, props2, theme, font, partialPageModalMiddleContentWidth, state, openTermsOfUse, calculatePromptHeight, p)
	local text

	if props.creatorName then
		text = props.creatorName .. " " .. (props.creatorVerified and VerifiedBadges.emoji.verified or "")
	end

	local text2 = (not props.isRobuxSubscription and "" or getIconRichText(Enums.IconName.Robux) .. " ") .. props.displayPrice .. props.period
	return React.createElement(PartialPageModal, {
		screenSize = props.screenSize,
		contentPadding = UDim.new(0, 24),
		buttonStackProps = {
			buttons = createSubscribeButtonStacks(props, props2),
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Vertical
		},
		onCloseClicked = props.cancelPurchaseActivated,
		footerContent = function()
			if props.isTestingMode then
				return generateTestmodeDisclaimer(props2.footerText, font, theme, partialPageModalMiddleContentWidth, p)
			end

			if FFlagEnableDevSubsFastFollowFixes then
				return nil
			end

			return generateDisclosure(props2, openTermsOfUse)
		end
	}, { React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				PromptScroll = React.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, (math.min(state, props.screenSize.Y - 240))),
					BorderSizePixel = 0,
					ZIndex = 2,
					ScrollingEnabled = props.screenSize.Y - 240 < state,
					ScrollBarThickness = props.screenSize.Y - 240 < state and 5 or nil,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Selectable = false,
					CanvasSize = UDim2.new(1, 0, 0, state)
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
						Image = props.itemIcon
					}, {
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 12)
						})
					}),
					AttributionSection = React.createElement(
						View,
						{ LayoutOrder = 1, tag = "auto-xy col align-x-start size-full-0" },
						{
							Layout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								Padding = UDim.new(0, 4)
							}),
							SubscriptionName = React.createElement(Text, {
								LayoutOrder = 1,
								Text = props.name,
								tag = "auto-xy content-emphasis text-align-x-left",
								fontStyle = p.Typography.HeadingSmall
							}),
							CreatorName = React.createElement(Text, {
								LayoutOrder = 2,
								Text = text,
								tag = "auto-xy content-default text-align-x-left",
								fontStyle = p.Typography.TitleLarge
							}),
							PriceRow = if not (props.disablePurchase and FFlagHideDevSubsPriceIfSubscribed) then React.createElement(Text, {
								LayoutOrder = 3,
								Text = text2,
								RichText = true,
								tag = "auto-xy content-emphasis text-align-x-left",
								fontStyle = p.Typography.TitleLarge
							}) else nil
						}
					),
					ActionButtonsRow = React.createElement(
						View,
						{ LayoutOrder = 2, tag = "row gap-small auto-y size-full-0 align-x-left" },
						{
							ShareButton = if props.onShare then React.createElement(Foundation.Chip, {
								text = props2.shareText,
								leading = { iconName = Enums.IconName.ArrowThickToRight },
								size = Enums.ChipSize.Small,
								onActivated = props.onShare,
								LayoutOrder = 1
							}) else nil,
							ReportButton = if props.onReport then React.createElement(Foundation.Chip, {
								text = props2.reportText,
								leading = { iconName = Enums.IconName.Flag },
								size = Enums.ChipSize.Small,
								onActivated = props.onReport,
								LayoutOrder = 2
							}) else nil
						}
					),
					generatePromptText(
						props,
						font,
						theme,
						partialPageModalMiddleContentWidth,
						calculatePromptHeight,
						3,
						p
					)
				})
			}
		) })
end

local function SubscriptionPurchasePrompt(props)
	local state, setState = React.useState(0)
	local v = useDispatch()
	local v2 = useTokens()

	local function openTermsOfUse()
		local terms = urlBuilder.static.about.terms()
		local v3 = { name = AppPage.GenericWebPage, detail = terms }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v3))
		else
			v(NavigateDown(v3))
		end
	end

	local function calculatePromptHeight(p)
		if props.shouldUseNewModalDesign then
			setState(338 + p + 24)
		else
			setState(24 + SubscriptionTitle:getTitleHeight(props.screenSize.Y - 240) + 24 + p)
		end
	end

	return React.createElement(MultiTextLocalizer, {
		keys = {
			titleText = { key = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription" },
			subscribe = { key = "Feature.Subscription.Action.Subscribe" },
			subscribeWithCreditDebitCard = {
				key = "Feature.Subscription.Action.SubscribeWithCreditDebitCard"
			},
			subscribeWithRobloxCredit = {
				key = "Feature.Subscription.Action.SubscribeWithRobloxCredit"
			},
			payAnotherWay = { key = "Feature.Subscription.Action.SubscribePayAnotherWay" },
			footerText = {
				key = "IAPExperience.SubscriptionPurchasePrompt.Label.TestFlowDisclaimer"
			},
			DisclosurePayment = { key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment" },
			DisclosureTermsURL = { key = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL" },
			TermsOfUse = { key = "IAPExperience.RobuxUpsell.Text.TermsOfUse" },
			shareText = { key = "Feature.SocialShare.Action.Share" },
			reportText = { key = "Feature.GameDetails.Action.Report" }
		},
		render = function(p)
			return withStyle(function(p2)
				local theme = p2.Theme
				local font = p2.Font
				local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

				if props.shouldUseNewModalDesign then
					return renderNewModalDesign(
						props,
						p,
						theme,
						font,
						partialPageModalMiddleContentWidth,
						state,
						openTermsOfUse,
						calculatePromptHeight,
						v2
					)
				end

				return React.createElement(PartialPageModal, {
					title = p.titleText,
					screenSize = props.screenSize,
					contentPadding = UDim.new(0, 24),
					buttonStackProps = {
						buttons = createSubscribeButtonStacks(props, p),
						buttonHeight = 48,
						forcedFillDirection = Enum.FillDirection.Vertical
					},
					onCloseClicked = props.cancelPurchaseActivated,
					footerContent = function()
						if props.isTestingMode then
							return generateTestmodeDisclaimer(
								p.footerText,
								font,
								theme,
								partialPageModalMiddleContentWidth,
								v2
							)
						end

						if FFlagEnableDevSubsFastFollowFixes then
							return nil
						end

						return generateDisclosure(p, openTermsOfUse)
					end
				}, { React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						},
						{
							PromptScroll = React.createElement("ScrollingFrame", {
								BackgroundTransparency = 1,
								LayoutOrder = 3,
								Size = UDim2.new(1, 0, 0, (math.min(state, props.screenSize.Y - 240))),
								BorderSizePixel = 0,
								ZIndex = 2,
								ScrollingEnabled = state > props.screenSize.Y - 240,
								ScrollBarThickness = state > props.screenSize.Y - 240 and 5 or nil,
								ScrollingDirection = Enum.ScrollingDirection.Y,
								Selectable = false,
								CanvasSize = UDim2.new(1, 0, 0, state)
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
									subscriptionProviderName = props.subscriptionProviderName,
									name = props.name,
									displayPrice = props.displayPrice,
									period = props.period,
									disclaimerText = props.disclaimerText,
									layoutOrder = 2,
									contentHeight = props.screenSize.Y - 240,
									itemIcon = props.itemIcon
								}),
								generatePromptText(
									props,
									font,
									theme,
									partialPageModalMiddleContentWidth,
									calculatePromptHeight,
									2,
									v2
								)
							})
						}
					) })
			end)
		end
	})
end

return SubscriptionPurchasePrompt
