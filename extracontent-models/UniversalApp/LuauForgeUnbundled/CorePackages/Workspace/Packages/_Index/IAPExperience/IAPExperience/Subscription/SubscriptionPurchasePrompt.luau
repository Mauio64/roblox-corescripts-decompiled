local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UrlBuilder").UrlBuilder
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RobloxAppEnums").AppPage

local TextService = game:GetService("TextService")

local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/VerifiedBadges")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Style").GetTextSize

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local buttonType = UIBlox.App.Button.Enum.ButtonType
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text
local enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useTokens = Foundation.Hooks.useTokens

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")
local SubscriptionTitle = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Subscription/SubscriptionTitle")

local fFlagHideDevSubsPriceIfSubscribed = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagHideDevSubsPriceIfSubscribed

local fFlagEnableDevSubsFastFollowFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableDevSubsFastFollowFixes

local function generateTestmodeDisclaimer(footerText, p2, p3, p4, p5)
	local v5

	if foundationFontFaceMigration then
		v5 = getTextSize(footerText, 12, p5.Typography.CaptionSmall.Font, Vector2.new(p4, 1e999), {
			addTemporaryPadding = false
		}).Y + 2
	else
		v5 = TextService:GetTextSize(footerText, 12, p2.Footer.Font, Vector2.new(p4, 1e999)).Y + 2
	end

	local createElement = React.createElement
	local v7 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 16),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, -48, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v5),
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextWrapped = true,
		Text = 0,
		TextSize = 12,
		TextColor3 = 0
	}
	local v11 = if not foundationFontFaceMigration then p2.Footer.Font else nil
	v10.Font = v11

	local v12 = if foundationFontFaceMigration then normalizeFontFace(p5.Typography.CaptionSmall.Font) else nil
	v10.FontFace = v12

	v10.TextXAlignment = Enum.TextXAlignment.Left

	v10.Text = footerText

	v10.TextColor3 = p3.TextDefault.Color
	return createElement("Frame", v7, {
		DisclaimerText = createElement2("TextLabel", v10)
	})
end

local function generatePromptText(props, p2, p3, p4, callback, value, p5)
	local createElement = React.createElement
	local v6 = {}
	v6.LayoutOrder = value or 2
	v6.BackgroundTransparency = 1
	v6.Size = UDim2.new(0, p4, 0, 0)
	v6.AutomaticSize = Enum.AutomaticSize.Y
	v6.TextXAlignment = Enum.TextXAlignment.Left
	local v7 = if not foundationFontFaceMigration then p2.Body.Font else nil
	v6.Font = v7

	local v8 = if foundationFontFaceMigration then normalizeFontFace(p5.Typography.BodyLarge.Font) else nil
	v6.FontFace = v8

	v6.Text = props.description
	v6.TextSize = 16
	v6.TextWrapped = true
	v6.TextColor3 = p3.TextDefault.Color
	v6.TextTransparency = p3.TextDefault.Transparency
	v6.RichText = true
	v6[React.Change.AbsoluteSize] = function(data)
		local v9 = if foundationFontFaceMigration then getTextSize(
			data.Text,
			data.TextSize,
			p5.Typography.BodyLarge.Font,
			Vector2.new(data.AbsoluteSize.X, 1e999),
			{ addTemporaryPadding = false }
		).Y else TextService:GetTextSize(
			data.Text,
			data.TextSize,
			data.Font,
			Vector2.new(data.AbsoluteSize.X, 1e999)
		).Y
		callback(v9)
	end

	return createElement("TextLabel", v6)
end

local function createSubscribeButtonStacks(props, data)
	if props.disablePurchase then
		return {
			{
				buttonType = buttonType.PrimarySystem,
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
				buttonType = buttonType.PrimarySystem,
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

	local v5 = nil

	if props.primaryPaymentMethod == "Stripe" then
		v5 = data.subscribeWithCreditDebitCard
	elseif props.primaryPaymentMethod == "CreditBalance" then
		v5 = data.subscribeWithRobloxCredit
	end

	return {
		{
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = function()
					props.purchaseSubscriptionActivated(props.primaryPaymentMethod)
				end,
				text = v5,
				layoutOrder = 0
			}
		},
		{
			buttonType = buttonType.Secondary,
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
	local v5 = string.split(props.DisclosureTermsURL, " {termsofuse} ")
	local v6 = "<u>" .. props.TermsOfUse .. "</u>"

	return React.createElement(
		view,
		{
			tag = "row wrap auto-y align-y-center align-x-center size-full-0 gap-xsmall padding-x-xsmall padding-bottom-xsmall"
		},
		{
			DisclosurePayment = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.DisclosurePayment,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			BeforeText = React.createElement(text, {
				LayoutOrder = 2,
				Text = v5[1],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			TextLink = React.createElement(text, {
				LayoutOrder = 3,
				RichText = true,
				Text = v6,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				onActivated = onActivated
			}),
			AfterText = React.createElement(text, {
				LayoutOrder = 4,
				Text = v5[2],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			})
		}
	)
end

local function renderNewModalDesign(props, props2, theme, font, partialPageModalMiddleContentWidth, state, openTermsOfUse, calculatePromptHeight, p2)
	local v5

	if props.creatorName then
		v5 = props.creatorName .. " " .. (props.creatorVerified and VerifiedBadges.emoji.verified or "")
	end

	local v6 = (not props.isRobuxSubscription and "" or getIconRichText(enums.IconName.Robux) .. " ") .. props.displayPrice .. props.period
	local createElement = React.createElement
	local v8 = {
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
				return generateTestmodeDisclaimer(
					props2.footerText,
					font,
					theme,
					partialPageModalMiddleContentWidth,
					p2
				)
			end

			if fFlagEnableDevSubsFastFollowFixes then
				return nil
			end

			return generateDisclosure(props2, openTermsOfUse)
		end
	}

	local v9 = { nil }
	local createElement2 = React.createElement
	local v11 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v12 = { PromptScroll = 0 }
	local createElement3 = React.createElement
	local v14 = {
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
	}
	local children = {
		[1] = nil,
		[1] = nil,
		nil,
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		}),
		HeroImage = React.createElement(imageSetLabel, {
			LayoutOrder = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 150, 0, 150),
			ScaleType = Enum.ScaleType.Fit,
			Image = props.itemIcon
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			})
		})
	}

	local createElement4 = React.createElement

	local v17 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 4)
		}),
		SubscriptionName = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.name,
			tag = "auto-xy content-emphasis text-align-x-left",
			fontStyle = p2.Typography.HeadingSmall
		}),
		CreatorName = React.createElement(text, {
			LayoutOrder = 2,
			Text = v5,
			tag = "auto-xy content-default text-align-x-left",
			fontStyle = p2.Typography.TitleLarge
		}),
		PriceRow = 0
	}

	local v18 = if not (props.disablePurchase and fFlagHideDevSubsPriceIfSubscribed) then React.createElement(text, {
		LayoutOrder = 3,
		Text = v6,
		RichText = true,
		tag = "auto-xy content-emphasis text-align-x-left",
		fontStyle = p2.Typography.TitleLarge
	}) else nil
	v17.PriceRow = v18
	children.AttributionSection = createElement4(
		view,
		{ LayoutOrder = 1, tag = "auto-xy col align-x-start size-full-0" },
		v17
	)

	local createElement5 = React.createElement

	local v22 = if props.onShare then React.createElement(Foundation.Chip, {
		text = props2.shareText,
		leading = { iconName = enums.IconName.ArrowThickToRight },
		size = enums.ChipSize.Small,
		onActivated = props.onShare,
		LayoutOrder = 1
	}) else nil

	local v23 = if props.onReport then React.createElement(Foundation.Chip, {
		text = props2.reportText,
		leading = { iconName = enums.IconName.Flag },
		size = enums.ChipSize.Small,
		onActivated = props.onReport,
		LayoutOrder = 2
	}) else nil
	children.ActionButtonsRow = createElement5(
		view,
		{ LayoutOrder = 2, tag = "row gap-small auto-y size-full-0 align-x-left" },
		{ ShareButton = v22, ReportButton = v23 }
	)

	-- [TOVEK] unclear table creation
	-- Inserting from loop instead
	do
		local _values = table.pack(generatePromptText(
			props,
			font,
			theme,
			partialPageModalMiddleContentWidth,
			calculatePromptHeight,
			3,
			p2
		))
		for _k = 1, _values.n do
			children[_k] = _values[_k]
		end
	end
	v12.PromptScroll = createElement3("ScrollingFrame", v14, children)
	-- [TOVEK] unclear table creation
	-- Inserting from loop instead
	do
		local _values = table.pack(createElement2("Frame", v11, v12))
		for _k = 1, _values.n do
			v9[_k] = _values[_k]
		end
	end
	return createElement(partialPageModal, v8, v9)
end

local function SubscriptionPurchasePrompt(props)
	local state, setState = React.useState(0)
	local v5 = useDispatch()
	local v6 = useTokens()

	local function openTermsOfUse()
		local terms = urlBuilder.static.about.terms()
		local v7 = { name = appPage.GenericWebPage, detail = terms }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v5(navigateDown(v7))
		end
	end

	local function calculatePromptHeight(p2)
		if props.shouldUseNewModalDesign then
			setState(338 + p2 + 24)
		else
			setState(24 + SubscriptionTitle:getTitleHeight(props.screenSize.Y - 240) + 24 + p2)
		end
	end

	return React.createElement(MultiTextLocalizer, {
		keys = {
			titleText = {
				key = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription"
			},
			subscribe = { key = "Feature.Subscription.Action.Subscribe" },
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
			TermsOfUse = { key = "IAPExperience.RobuxUpsell.Text.TermsOfUse" },
			shareText = { key = "Feature.SocialShare.Action.Share" },
			reportText = { key = "Feature.GameDetails.Action.Report" }
		},
		render = function(p2)
			return withStyle(function(p3)
				local theme = p3.Theme
				local font = p3.Font
				local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

				if props.shouldUseNewModalDesign then
					return renderNewModalDesign(
						props,
						p2,
						theme,
						font,
						partialPageModalMiddleContentWidth,
						state,
						openTermsOfUse,
						calculatePromptHeight,
						v6
					)
				end

				return React.createElement(partialPageModal, {
					title = p2.titleText,
					screenSize = props.screenSize,
					contentPadding = UDim.new(0, 24),
					buttonStackProps = {
						buttons = createSubscribeButtonStacks(props, p2),
						buttonHeight = 48,
						forcedFillDirection = Enum.FillDirection.Vertical
					},
					onCloseClicked = props.cancelPurchaseActivated,
					footerContent = function()
						if props.isTestingMode then
							return generateTestmodeDisclaimer(
								p2.footerText,
								font,
								theme,
								partialPageModalMiddleContentWidth,
								v6
							)
						end

						if fFlagEnableDevSubsFastFollowFixes then
							return nil
						end

						return generateDisclosure(p2, openTermsOfUse)
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
									v6
								)
							})
						}
					) })
			end)
		end
	})
end

return SubscriptionPurchasePrompt
