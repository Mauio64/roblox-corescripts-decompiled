local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local RoactFitComponents = require(parent3.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical

local Style = require(parent3.Style)
local Colors = Style.Colors

local UIBlox = require(parent3.UIBlox)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle

local FFlagLowCogsBannerInfoIcon = require(parent2.Flags.FFlagLowCogsBannerInfoIcon)
local InfoIconWithTooltip = require(parent2.Generic.InfoIconWithTooltip)

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)
local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent3.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent3.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Localization3 = require(parent3.Localization)
local withLocalization = Localization3.withLocalization

local v = require(parent3.IXPServiceWrapper)
v = v.IXPServiceWrapper
local SharedFlags = require(parent3.SharedFlags)

local LoggingProtocol = require(parent3.LoggingProtocol)
local default = LoggingProtocol.default
local LegacyUpsellCounter = require(parent2.Generic.Events.LegacyUpsellCounter)
local logger = require(parent2.Utility.logger)

local FFlagMobilePopularItemBadgingExperimentEnabled = require(parent2.Flags.FFlagMobilePopularItemBadgingExperimentEnabled)
require(parent2.Flags.GetFStringMobilePopularItemBadgingLayer)

local ProductDetails = require(parent.ProductDetails)
local ProductDetailsNew = require(parent.ProductDetailsNew)

local Constants = require(parent2.Generic.Constants)
local getEnableCondenseRobuxUpsell = require(parent2.Flags.getEnableCondenseRobuxUpsell)

local FFlagIntroduceMetricsLegacyUpsell = require(parent2.Flags.FFlagIntroduceMetricsLegacyUpsell)

local extended = Roact.Component:extend(script.Name)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0),
	isLoading = false,
	isDisabled = false,
	isDelayedInput = false,
	isQuest = false,
	enableInputDelayed = false,
	inputDelaySec = 3,
	isVng = false
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = {
		contentSize = Vector2.new(0, 0),
		footerSize = Vector2.new(0, 0),
		isCondensed = false
	}

	function self.validateCondensedCondition(p)
		if not getEnableCondenseRobuxUpsell() then
			return
		end

		local v2 = p.AbsoluteSize.Y + Constants.MODAL_HEIGHT_WITHOUT_CONTENT + Constants.MODAL_NORMAL_SECTION_PADDING * 2 + Constants.MODAL_NORMAL_BUTTON_HEIGHT * 2

		if self.state.isCondensed then
			self:setState({
				isCondensed = self.props.screenSize.Y < v2 + (Constants.MODAL_NORMAL_CONTENT_PADDING - Constants.MODAL_CONDENSED_CONTENT_PADDING) * 6 + (Constants.MODAL_NORMAL_BUTTON_MARGIN - Constants.MODAL_CONDENSED_BUTTON_MARGIN) + (Constants.NORMAL_ICON_SIZE - Constants.CONDENSED_ICON_SIZE)
			})
		else
			self:setState({
				isCondensed = self.props.screenSize.Y < v2 + Constants.MODAL_NORMAL_BUTTON_MARGIN
			})
		end
	end

	function self.changeContentSize(p)
		self.validateCondensedCondition(p)

		if self.state.contentSize ~= p.AbsoluteSize then
			self:setState({ contentSize = p.AbsoluteSize })
		end
	end
end

function extended.didMount(_)
	if FFlagIntroduceMetricsLegacyUpsell then
		logger.debug({ message = "Legacy Upsell Modal Shown" })

		default:logRobloxTelemetryCounter(LegacyUpsellCounter.LegacyUpsellShownCounter, 1, {})
	end
end

function extended:render()
	local v2 = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL"
		or "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL"

	if SharedFlags.FFlagLowCogsBannerExperiment then
		return Roact.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{ Alert = self:renderNewAlert() }
		)
	end

	if FFlagMobilePopularItemBadgingExperimentEnabled then
		return Roact.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{
				Alert = self:renderAlertNewProductDetails()
			}
		)
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientRobuxTitle = { key = "IAPExperience.RobuxUpsell.Title.InsufficientRobux" },
			AdditionalRobux = { key = "IAPExperience.RobuxUpsell.Text.AdditionalRobux" },
			WouldYouBuy = { key = "IAPExperience.RobuxUpsell.Text.WouldYouBuy" },
			DisclosurePayment = { key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment" },
			DisclosureTermsURL = { key = v2 },
			TermsOfUse = { key = "IAPExperience.RobuxUpsell.Text.TermsOfUse" },
			BuyRobuxButton = { key = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem" },
			ButtonCancel = { key = "IAPExperience.RobuxUpsell.Action.Cancel" },
			LoadingText = { key = "IAPExperience.RobuxUpsell.Text.Loading" },
			PurchaseNotAvialableForQuest = {
				key = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet"
			}
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(data)
	local props = self.props
	local state = self.state

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font
		local textSize = font.BaseSize * font.Body.RelativeSize
		textSize = getEnableCondenseRobuxUpsell() and state.isCondensed and textSize * 0.9 or textSize

		local v2 = props.itemRobuxCost - props.balanceAmount
		local v3 = data.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v2))

		local color = Color3.new(
			math.round(theme.TextEmphasis.Color.R * 255),
			math.round(theme.TextEmphasis.Color.G * 255),
			(math.round(theme.TextEmphasis.Color.B * 255))
		)

		local v4 = string.format(
			"<font color=\"rgb(%s)\">%s%s</font>",
			tostring(color),
			utf8.char(57346),
			(tostring(props.robuxPurchaseAmount))
		)

		local v5 = data.WouldYouBuy:gsub("{robux}", v4)

		local v6 = string.split(data.DisclosureTermsURL, "{termsofuse}")

		local text = data.TermsOfUse

		if props.termsOfUseActivated then
			text = "<u>" .. text .. "</u>"
		end

		local createElement = Roact.createElement
		local v7 = {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = data.InsufficientRobuxTitle,
			middleContent = function()
				local createElement2 = Roact.createElement
				local v7 = {
					BackgroundTransparency = 1,
					["width"] = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}
				local contentPadding

				if getEnableCondenseRobuxUpsell() then
					contentPadding = UDim.new(
						0,
						state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING
					)
				else
					contentPadding = UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING)
				end

				v7.contentPadding = contentPadding

				v7[Roact.Ref] = self.contentRef
				v7[Roact.Change.AbsoluteSize] = self.changeContentSize

				local createElement3 = Roact.createElement
				local v8 = {
					layoutOrder = 1,
					model = props.model,
					itemIcon = props.itemIcon,
					itemName = props.itemName,
					itemRobuxCost = props.itemRobuxCost,
					itemIconWidth = 0,
					itemIconHeight = 0
				}
				local itemIconWidth

				if getEnableCondenseRobuxUpsell() then
					itemIconWidth = state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
				end

				v8.itemIconWidth = itemIconWidth
				local itemIconHeight

				if getEnableCondenseRobuxUpsell() then
					itemIconHeight = state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
				end

				v8.itemIconHeight = itemIconHeight
				local children = {
					ProductDetails = createElement3(ProductDetails, v8),
					Underline = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					}),
					AdditionalBuyText = 0,
					Underline2 = 0,
					DisclosureFrame = 0
				}

				local createElement4 = Roact.createElement
				local v9 = {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, self.state.contentSize.X, 0, 0),
					RichText = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
					Text = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0
				}
				local text2

				if self.props.isQuest then
					text2 = v3
				else
					text2 = v3 .. " " .. v5
				end

				v9.Text = text2
				v9.TextSize = textSize
				v9.TextColor3 = theme.TextDefault.Color
				v9.TextTransparency = theme.TextDefault.Transparency
				children.AdditionalBuyText = createElement4("TextLabel", v9)

				children.Underline2 = Roact.createElement("Frame", {
					LayoutOrder = 4,
					BorderSizePixel = 0,
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				})

				local createElement5 = Roact.createElement
				local v10 = {
					LayoutOrder = 5,
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 1)
				}

				local createElement6 = Roact.createElement
				local v11 = {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
					Text = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextWrapped = true
				}
				local text3

				if self.props.isQuest then
					text3 = data.PurchaseNotAvailableOnHeadSet
				else
					text3 = data.DisclosurePayment
				end

				v11.Text = text3

				v11.TextSize = textSize
				v11.TextColor3 = theme.TextDefault.Color
				v11.TextTransparency = theme.TextDefault.Transparency
				local v12 = {
					DisclosurePayment = createElement6("TextLabel", v11),
					DisclosureTermsFrame = 0
				}
				local disclosureTermsFrame

				if not self.props.isQuest then
					disclosureTermsFrame = Roact.createElement(FitFrameVertical, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}, {
						BeforeDisclosureText = Roact.createElement("TextLabel", {
							LayoutOrder = 0,
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.XY,
							FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
							Text = v6[1],
							TextSize = textSize,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency
						}),
						TermsOfUse = Roact.createElement("TextButton", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							RichText = true,
							AutomaticSize = Enum.AutomaticSize.XY,
							FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
							Text = text,
							TextSize = textSize,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							Selectable = props.termsOfUseActivated ~= nil,
							[Roact.Event.Activated] = props.termsOfUseActivated
						}),
						AfterDisclosureText = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.XY,
							FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
							Text = v6[2],
							TextSize = textSize,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency
						})
					})
				end

				v12.DisclosureTermsFrame = disclosureTermsFrame
				children.DisclosureFrame = createElement5(FitFrameVertical, v10, v12)
				return createElement2(FitFrameVertical, v7, children)
			end,
			buttonStackInfo = 0
		}

		local buttonStackInfo = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			marginBetween = 0,
			buttons = 0
		}
		local marginBetween

		if getEnableCondenseRobuxUpsell() then
			marginBetween = state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN
				or Constants.MODAL_NORMAL_BUTTON_MARGIN
		else
			marginBetween = Constants.MODAL_NORMAL_BUTTON_MARGIN
		end

		buttonStackInfo.marginBetween = marginBetween
		local buttons

		if self.props.isQuest then
			buttons = {
				{
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = data.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}
			}
		else
			buttons = { nil, nil }
			local v8 = {
				props = {
					isDisabled = props.isDisabled,
					onActivated = props.cancelPurchaseActivated,
					text = data.ButtonCancel,
					inputIcon = props.cancelControllerIcon
				}
			}

			local v9 = { buttonType = ButtonType.PrimarySystem, props = 0 }
			local props3 = {
				isLoading = props.isLoading,
				isDisabled = props.isDisabled,
				isDelayedInput = props.isDelayedInput,
				enableInputDelayed = props.enableInputDelayed,
				delayInputSeconds = props.inputDelaySec,
				onActivated = props.buyItemActivated,
				text = 0,
				inputIcon = 0
			}
			local text2

			if props.enableInputDelayed then
				text2 = data.LoadingText
			else
				text2 = data.BuyRobuxButton
			end

			props3.text = text2
			props3.inputIcon = props.buyItemControllerIcon
			v9.props = props3
			buttons[1], buttons[2] = v8, v9
		end

		buttonStackInfo.buttons = buttons
		v7.buttonStackInfo = buttonStackInfo
		return createElement(InteractiveAlert, v7)
	end)
end

function extended:renderAlertNewProductDetails(_)
	local props = self.props
	local state = self.state
	return withLocalization({
		InsufficientRobuxTitle = "IAPExperience.RobuxUpsell.Title.InsufficientRobux",
		AdditionalRobux = "IAPExperience.RobuxUpsell.Text.AdditionalRobux",
		WouldYouBuy = "IAPExperience.RobuxUpsell.Text.WouldYouBuy",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL" or "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		PurchaseNotAvialableForQuest = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet",
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		BadgeText = "IAPExperience.RobuxUpsell.Text.PopularItem"
	})(function(data)
		return withStyle(function(props2)
			local theme = props2.Theme
			local font = props2.Font

			local textSize = font.BaseSize * font.Body.RelativeSize
			textSize = getEnableCondenseRobuxUpsell() and state.isCondensed and textSize * 0.9 or textSize

			local v2 = props.itemRobuxCost - props.balanceAmount

			local v3 = data.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v2))

			local color = Color3.new(
				math.round(theme.TextEmphasis.Color.R * 255),
				math.round(theme.TextEmphasis.Color.G * 255),
				(math.round(theme.TextEmphasis.Color.B * 255))
			)

			local v4 = string.format(
				"<font color=\"rgb(%s)\">%s%s</font>",
				tostring(color),
				utf8.char(57346),
				(tostring(props.robuxPurchaseAmount))
			)

			local v5 = data.WouldYouBuy:gsub("{robux}", v4)

			local v6 = string.split(data.DisclosureTermsURL, "{termsofuse}")

			local text = data.TermsOfUse

			if props.termsOfUseActivated then
				text = "<u>" .. text .. "</u>"
			end

			local gameId

			if game.GameId then
				gameId = tostring(game.GameId)
			end

			local v7

			if props.itemProductId then
				v7 = tostring(props.itemProductId)
			end

			local v8 = {
				layoutOrder = 1,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				itemRobuxCost = props.itemRobuxCost,
				itemIconWidth = 0,
				itemIconHeight = 0
			}
			local itemIconWidth

			if getEnableCondenseRobuxUpsell() then
				itemIconWidth = state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
			end

			v8.itemIconWidth = itemIconWidth
			local itemIconHeight

			if getEnableCondenseRobuxUpsell() then
				itemIconHeight = state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
			end

			v8.itemIconHeight = itemIconHeight
			v7 = gameId and v7 or v7
			local productDetails
			productDetails = Roact.createElement(ProductDetails, v8)

			local createElement = Roact.createElement
			local v9 = {
				screenSize = props.screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint,
				title = data.NeedMoreRobux,
				middleContent = function()
					local createElement2 = Roact.createElement
					local v9 = {
						BackgroundTransparency = 1,
						["width"] = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}
					local contentPadding

					if getEnableCondenseRobuxUpsell() then
						contentPadding = UDim.new(
							0,
							state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING
						)
					else
						contentPadding = UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING)
					end

					v9.contentPadding = contentPadding

					v9[Roact.Ref] = self.contentRef
					v9[Roact.Change.AbsoluteSize] = self.changeContentSize
					local children = {
						ProductDetails = productDetails,
						SimulateMargin = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(0, 12, 0, 12)
						}),
						Underline = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							BackgroundColor3 = theme.Divider.Color,
							BackgroundTransparency = theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						AdditionalBuyText = 0,
						Underline2 = 0,
						DisclosureFrame = 0
					}

					local createElement3 = Roact.createElement
					local v10 = {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, self.state.contentSize.X, 0, 0),
						RichText = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextWrapped = true,
						FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
						Text = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0
					}
					local text2

					if self.props.isQuest then
						text2 = v3
					else
						text2 = v3 .. " " .. v5
					end

					v10.Text = text2

					v10.TextSize = textSize
					v10.TextColor3 = theme.TextDefault.Color
					v10.TextTransparency = theme.TextDefault.Transparency
					children.AdditionalBuyText = createElement3("TextLabel", v10)

					children.Underline2 = Roact.createElement("Frame", {
						LayoutOrder = 4,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					})

					local createElement4 = Roact.createElement
					local v11 = {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}

					local createElement5 = Roact.createElement
					local v12 = {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
						Text = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextWrapped = true
					}
					local text3

					if self.props.isQuest then
						text3 = data.PurchaseNotAvailableOnHeadSet
					else
						text3 = data.DisclosurePayment
					end

					v12.Text = text3

					v12.TextSize = textSize
					v12.TextColor3 = theme.TextDefault.Color
					v12.TextTransparency = theme.TextDefault.Transparency
					local v13 = {
						DisclosurePayment = createElement5("TextLabel", v12),
						DisclosureTermsFrame = 0
					}
					local disclosureTermsFrame

					if not self.props.isQuest then
						disclosureTermsFrame = Roact.createElement(FitFrameVertical, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							BeforeDisclosureText = Roact.createElement("TextLabel", {
								LayoutOrder = 0,
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = v6[1],
								TextSize = textSize,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							}),
							TermsOfUse = Roact.createElement("TextButton", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								RichText = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = text,
								TextSize = textSize,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency,
								Selectable = props.termsOfUseActivated ~= nil,
								[Roact.Event.Activated] = props.termsOfUseActivated
							}),
							AfterDisclosureText = Roact.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = v6[2],
								TextSize = textSize,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							})
						})
					end

					v13.DisclosureTermsFrame = disclosureTermsFrame
					children.DisclosureFrame = createElement4(FitFrameVertical, v11, v13)
					return createElement2(FitFrameVertical, v9, children)
				end,
				buttonStackInfo = 0
			}

			local buttonStackInfo = {
				forcedFillDirection = Enum.FillDirection.Vertical,
				marginBetween = 0,
				buttons = 0
			}
			local marginBetween

			if getEnableCondenseRobuxUpsell() then
				marginBetween = state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN
					or Constants.MODAL_NORMAL_BUTTON_MARGIN
			else
				marginBetween = Constants.MODAL_NORMAL_BUTTON_MARGIN
			end

			buttonStackInfo.marginBetween = marginBetween
			local buttons

			if self.props.isQuest then
				buttons = {
					{
						props = {
							isDisabled = props.isDisabled,
							onActivated = props.cancelPurchaseActivated,
							text = data.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					}
				}
			else
				buttons = { nil, nil }
				local v10 = {
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = data.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}

				local v11 = { buttonType = ButtonType.PrimarySystem, props = 0 }
				local props3 = {
					isLoading = props.isLoading,
					isDisabled = props.isDisabled,
					isDelayedInput = props.isDelayedInput,
					enableInputDelayed = props.enableInputDelayed,
					delayInputSeconds = props.inputDelaySec,
					onActivated = props.buyItemActivated,
					text = 0,
					inputIcon = 0
				}
				local text2

				if props.enableInputDelayed then
					text2 = data.LoadingText
				else
					text2 = data.BuyRobuxButton
				end

				props3.text = text2

				props3.inputIcon = props.buyItemControllerIcon
				v11.props = props3
				buttons[1], buttons[2] = v10, v11
			end

			buttonStackInfo.buttons = buttons
			v9.buttonStackInfo = buttonStackInfo
			return createElement(InteractiveAlert, v9)
		end)
	end)
end

function extended:renderNewAlert()
	local props = self.props
	local state = self.state

	return withLocalization({
		InsufficientRobuxTitle = "IAPExperience.RobuxUpsell.Title.InsufficientRobux",
		AdditionalRobux = "IAPExperience.RobuxUpsell.Text.AdditionalRobux",
		WouldYouBuy = "IAPExperience.RobuxUpsell.Text.WouldYouBuy",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL" or "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		PurchaseNotAvialableForQuest = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet",
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		BonusBannerV1 = "IAPExperience.RobuxUpsell.Text.BonusBannerV1",
		BonusBannerInfo = "IAPExperience.RobuxUpsell.Text.BonusBannerInfo"
	})(function(data)
		return withStyle(function(props2)
			local theme = props2.Theme
			local font = props2.Font
			local textSize = font.BaseSize * font.Body.RelativeSize
			textSize = getEnableCondenseRobuxUpsell() and state.isCondensed and textSize * 0.9 or textSize

			local textSize2 = font.BaseSize * font.Footer.RelativeSize
			local v2 = props.itemRobuxCost - props.balanceAmount

			local v3 = data.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v2))

			local color = Color3.new(
				math.round(theme.TextEmphasis.Color.R * 255),
				math.round(theme.TextEmphasis.Color.G * 255),
				(math.round(theme.TextEmphasis.Color.B * 255))
			)

			local v4 = string.format(
				"<font color=\"rgb(%s)\">%s%s</font>",
				tostring(color),
				utf8.char(57346),
				(tostring(props.robuxPurchaseAmount))
			)

			local v5 = data.WouldYouBuy:gsub("{robux}", v4)

			local v6 = string.split(data.DisclosureTermsURL, "{termsofuse}")

			local text = data.TermsOfUse

			if props.termsOfUseActivated then
				text = "<u>" .. text .. "</u>"
			end

			local v7

			if props.robuxPurchaseAmountBeforeBonus == nil then
				v7 = ""
			else
				local robuxPurchaseAmountBeforeBonus = tostring(props.robuxPurchaseAmountBeforeBonus)
				local robuxPurchaseAmount = tostring(props.robuxPurchaseAmount)
				local v8 = utf8.char(57346) .. "<s>" .. robuxPurchaseAmountBeforeBonus .. "</s>" .. utf8.char(57346) .. robuxPurchaseAmount
				v5 = data.WouldYouBuy:gsub("{robux}", v8)

				local v9 = props.robuxPurchaseAmount - props.robuxPurchaseAmountBeforeBonus
				local v10 = utf8.char(57346) .. tostring(v9)
				v7 = data.BonusBannerV1:gsub("{robux}", v10)
			end

			local createElement = Roact.createElement
			local v8 = {
				screenSize = props.screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint,
				title = data.NeedMoreRobux,
				middleContent = function()
					local createElement2 = Roact.createElement
					local v8 = {
						["BackgroundTransparency"] = nil,
						["BackgroundTransparency"] = nil,
						["BackgroundTransparency"] = nil,
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(0, 255, 0),
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}
					local contentPadding

					if getEnableCondenseRobuxUpsell() then
						contentPadding = UDim.new(
							0,
							state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING
						)
					else
						contentPadding = UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING)
					end

					v8.contentPadding = contentPadding

					v8[Roact.Ref] = self.contentRef
					v8[Roact.Change.AbsoluteSize] = self.changeContentSize

					local createElement3 = Roact.createElement
					local v9 = {
						layoutOrder = 1,
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						itemIconWidth = 0,
						itemIconHeight = 0
					}
					local itemIconWidth

					if getEnableCondenseRobuxUpsell() then
						itemIconWidth = state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
					end

					v9.itemIconWidth = itemIconWidth
					local itemIconHeight

					if getEnableCondenseRobuxUpsell() then
						itemIconHeight = state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
					end

					v9.itemIconHeight = itemIconHeight
					local children = {
						ProductDetails = createElement3(ProductDetails, v9),
						Underline = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							BackgroundColor3 = theme.Divider.Color,
							BackgroundTransparency = theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						AdditionalBuyText = 0,
						Underline2 = 0,
						DisclosureFrame = 0
					}

					local createElement4 = Roact.createElement
					local v10 = {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, self.state.contentSize.X, 0, 0),
						RichText = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextWrapped = true,
						FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
						Text = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0
					}
					local text2

					if self.props.isQuest then
						text2 = v3
					else
						text2 = v3 .. " " .. v5
					end

					v10.Text = text2

					v10.TextSize = textSize
					v10.TextColor3 = theme.TextDefault.Color
					v10.TextTransparency = theme.TextDefault.Transparency
					children.AdditionalBuyText = createElement4("TextLabel", v10)

					children.Underline2 = Roact.createElement("Frame", {
						LayoutOrder = 4,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					})

					local createElement5 = Roact.createElement
					local v11 = {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}

					local createElement6 = Roact.createElement
					local v12 = {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
						Text = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextWrapped = true
					}
					local text3

					if self.props.isQuest then
						text3 = data.PurchaseNotAvailableOnHeadSet
					else
						text3 = data.DisclosurePayment
					end

					v12.Text = text3

					v12.TextSize = textSize2
					v12.TextColor3 = theme.TextDefault.Color
					v12.TextTransparency = theme.TextDefault.Transparency
					local v13 = {
						DisclosurePayment = createElement6("TextLabel", v12),
						DisclosureTermsFrame = 0
					}
					local disclosureTermsFrame

					if not self.props.isQuest then
						disclosureTermsFrame = Roact.createElement(FitFrameVertical, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							BeforeDisclosureText = Roact.createElement("TextLabel", {
								LayoutOrder = 0,
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = v6[1],
								TextSize = textSize2,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							}),
							TermsOfUse = Roact.createElement("TextButton", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								RichText = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = text,
								TextSize = textSize2,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency,
								Selectable = props.termsOfUseActivated ~= nil,
								[Roact.Event.Activated] = props.termsOfUseActivated
							}),
							AfterDisclosureText = Roact.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = v6[2],
								TextSize = textSize2,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							})
						})
					end

					v13.DisclosureTermsFrame = disclosureTermsFrame
					children.DisclosureFrame = createElement5(FitFrameVertical, v11, v13)
					return createElement2(FitFrameVertical, v8, children)
				end,
				buttonStackInfo = 0,
				footerContent = 0
			}

			local buttonStackInfo = {
				forcedFillDirection = Enum.FillDirection.Vertical,
				marginBetween = 0,
				buttons = 0
			}
			local marginBetween

			if getEnableCondenseRobuxUpsell() then
				marginBetween = state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN
					or Constants.MODAL_NORMAL_BUTTON_MARGIN
			else
				marginBetween = Constants.MODAL_NORMAL_BUTTON_MARGIN
			end

			buttonStackInfo.marginBetween = marginBetween
			local buttons

			if self.props.isQuest then
				buttons = {
					{
						props = {
							isDisabled = props.isDisabled,
							onActivated = props.cancelPurchaseActivated,
							text = data.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					}
				}
			else
				buttons = { nil, nil }
				local v9 = {
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = data.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}

				local v10 = { buttonType = ButtonType.PrimarySystem, props = 0 }
				local props3 = {
					isLoading = props.isLoading,
					isDisabled = props.isDisabled,
					isDelayedInput = props.isDelayedInput,
					enableInputDelayed = props.enableInputDelayed,
					delayInputSeconds = props.inputDelaySec,
					onActivated = props.buyItemActivated,
					text = 0,
					inputIcon = 0
				}
				local text2

				if props.enableInputDelayed then
					text2 = data.LoadingText
				else
					text2 = data.BuyRobuxButton
				end

				props3.text = text2

				props3.inputIcon = props.buyItemControllerIcon
				v10.props = props3
				buttons[1], buttons[2] = v9, v10
			end

			buttonStackInfo.buttons = buttons
			v8.buttonStackInfo = buttonStackInfo

			function v8.footerContent()
				return self:renderFooterExperiment(props2, v7, data.BonusBannerInfo)
			end

			return createElement(InteractiveAlert, v8)
		end)
	end)
end

function extended:renderFooterExperiment(p, text, text2)
	local font = p.Font
	local flint = Colors.Flint

	if text == "" then
		return nil
	end

	local createElement = Roact.createElement
	local v2 = {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = { top = 0, bottom = -24, left = -24, right = -24 },
		[Roact.Ref] = self.footerRef,
		[Roact.Change.AbsoluteSize] = self.changeFooterSize
	}

	local createElement2 = Roact.createElement
	local v3 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
		ImageColor3 = Color3.fromRGB(239, 215, 140),
		Size = UDim2.new(1, 0, 0, 40),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 0, 24, 16),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement3 = Roact.createElement
	local v4 = {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = { top = 12, bottom = 0, left = 0, right = 0 },
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}
	local v5 = {
		BonusBefore = Roact.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			RichText = true,
			FontFace = normalizeFontFace(p.Tokens.Typography.CaptionSmall.Font),
			Text = text,
			TextSize = font.BaseSize * font.Footer.RelativeSize,
			TextColor3 = flint,
			TextWrapped = true
		}),
		InfoIcon = 0
	}
	local infoIcon

	if FFlagLowCogsBannerInfoIcon then
		infoIcon = InfoIconWithTooltip({
			text = text2,
			layoutOrder = 2,
			color = flint,
			eventActivated = self.bonusBannerInfoIconStateChange
		})
	end

	v5.InfoIcon = infoIcon
	return createElement(FitFrameVertical, v2, {
		Banner = createElement2("ImageLabel", v3, {
			BannerContent = createElement3(FitFrameVertical, v4, v5)
		})
	})
end

return extended
