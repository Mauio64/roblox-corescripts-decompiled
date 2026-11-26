local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local fitFrameVertical = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame").FitFrameVertical

local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Style").Colors

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Utility.normalizeFontFace
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle

local FFlagLowCogsBannerInfoIcon = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagLowCogsBannerInfoIcon")
local InfoIconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/InfoIconWithTooltip")

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")
local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").LocalizationProvider
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").withLocalization

local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/IxpServiceWrapper").IXPServiceWrapper
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local LegacyUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/LegacyUpsellCounter")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")

local FFlagMobilePopularItemBadgingExperimentEnabled = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagMobilePopularItemBadgingExperimentEnabled")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFStringMobilePopularItemBadgingLayer")

local module10 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/ProductDetails")
local ProductDetailsNew = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/ProductDetailsNew")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants")
local getEnableCondenseRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/getEnableCondenseRobuxUpsell")

local FFlagIntroduceMetricsLegacyUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagIntroduceMetricsLegacyUpsell")

local extended = Roact.Component:extend("RobuxUpsellPrompt")

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

	function self.validateCondensedCondition(p2)
		if not getEnableCondenseRobuxUpsell() then
			return
		end

		local v5 = p2.AbsoluteSize.Y + Constants.MODAL_HEIGHT_WITHOUT_CONTENT + Constants.MODAL_NORMAL_SECTION_PADDING * 2 + Constants.MODAL_NORMAL_BUTTON_HEIGHT * 2

		if self.state.isCondensed then
			self:setState({
				isCondensed = self.props.screenSize.Y < v5 + (Constants.MODAL_NORMAL_CONTENT_PADDING - Constants.MODAL_CONDENSED_CONTENT_PADDING) * 6 + (Constants.MODAL_NORMAL_BUTTON_MARGIN - Constants.MODAL_CONDENSED_BUTTON_MARGIN) + (Constants.NORMAL_ICON_SIZE - Constants.CONDENSED_ICON_SIZE)
			})
		else
			self:setState({
				isCondensed = self.props.screenSize.Y < v5 + Constants.MODAL_NORMAL_BUTTON_MARGIN
			})
		end
	end

	function self.changeContentSize(p2)
		self.validateCondensedCondition(p2)

		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end
end

function extended.didMount(p2)
	if FFlagIntroduceMetricsLegacyUpsell then
		logger.debug({ message = "Legacy Upsell Modal Shown" })

		default:logRobloxTelemetryCounter(LegacyUpsellCounter.LegacyUpsellShownCounter, 1, {})
	end
end

function extended:render()
	local v5 = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL"
		or "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL"

	if SharedFlags.FFlagLowCogsBannerExperiment then
		return Roact.createElement(
			localizationProvider,
			{
				localization = localization.new(LocalizationService.RobloxLocaleId)
			},
			{ Alert = self:renderNewAlert() }
		)
	end

	if FFlagMobilePopularItemBadgingExperimentEnabled then
		return Roact.createElement(
			localizationProvider,
			{
				localization = localization.new(LocalizationService.RobloxLocaleId)
			},
			{
				Alert = self:renderAlertNewProductDetails()
			}
		)
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientRobuxTitle = {
				key = "IAPExperience.RobuxUpsell.Title.InsufficientRobux"
			},
			AdditionalRobux = { key = "IAPExperience.RobuxUpsell.Text.AdditionalRobux" },
			WouldYouBuy = { key = "IAPExperience.RobuxUpsell.Text.WouldYouBuy" },
			DisclosurePayment = {
				key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment"
			},
			DisclosureTermsURL = { key = v5 },
			TermsOfUse = { key = "IAPExperience.RobuxUpsell.Text.TermsOfUse" },
			BuyRobuxButton = {
				key = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem"
			},
			ButtonCancel = { key = "IAPExperience.RobuxUpsell.Action.Cancel" },
			LoadingText = { key = "IAPExperience.RobuxUpsell.Text.Loading" },
			PurchaseNotAvialableForQuest = {
				key = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet"
			}
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(data2)
	local props = self.props
	local state = self.state

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font
		local v5 = font.BaseSize * font.Body.RelativeSize
		v5 = getEnableCondenseRobuxUpsell() and state.isCondensed and v5 * 0.9 or v5

		local v6 = props.itemRobuxCost - props.balanceAmount
		local v7 = data2.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v6))

		local color = Color3.new(
			math.round(theme.TextEmphasis.Color.R * 255),
			math.round(theme.TextEmphasis.Color.G * 255),
			(math.round(theme.TextEmphasis.Color.B * 255))
		)

		local v8 = string.format(
			"<font color=\"rgb(%s)\">%s%s</font>",
			tostring(color),
			utf8.char(57346),
			(tostring(props.robuxPurchaseAmount))
		)

		local v9 = data2.WouldYouBuy:gsub("{robux}", v8)

		local v10 = string.split(data2.DisclosureTermsURL, "{termsofuse}")

		local v11 = data2.TermsOfUse

		if props.termsOfUseActivated then
			v11 = "<u>" .. v11 .. "</u>"
		end

		local createElement = Roact.createElement
		local v13 = {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = data2.InsufficientRobuxTitle,
			middleContent = function()
				local createElement2 = Roact.createElement
				local v15 = {
					BackgroundTransparency = 1,
					["width"] = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}
				local v16 = if getEnableCondenseRobuxUpsell() then UDim.new(
					0,
					state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING
				) else UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING)
				v15.contentPadding = v16

				v15[Roact.Ref] = self.contentRef
				v15[Roact.Change.AbsoluteSize] = self.changeContentSize

				local createElement3 = Roact.createElement
				local v18 = {
					layoutOrder = 1,
					model = props.model,
					itemIcon = props.itemIcon,
					itemName = props.itemName,
					itemRobuxCost = props.itemRobuxCost,
					itemIconWidth = 0,
					itemIconHeight = 0
				}
				local v19 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil else nil
				v18.itemIconWidth = v19

				local v20 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil else nil
				v18.itemIconHeight = v20
				local children = {
					ProductDetails = createElement3(module10, v18),
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
				local v22 = {
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
				local v23 = if self.props.isQuest then v7 else v7 .. " " .. v9
				v22.Text = v23
				v22.TextSize = v5
				v22.TextColor3 = theme.TextDefault.Color
				v22.TextTransparency = theme.TextDefault.Transparency
				children.AdditionalBuyText = createElement4("TextLabel", v22)

				children.Underline2 = Roact.createElement("Frame", {
					LayoutOrder = 4,
					BorderSizePixel = 0,
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				})

				local createElement5 = Roact.createElement
				local v25 = {
					LayoutOrder = 5,
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 1)
				}

				local createElement6 = Roact.createElement
				local v28 = {
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
				local v29 = if self.props.isQuest then data2.PurchaseNotAvailableOnHeadSet else data2.DisclosurePayment
				v28.Text = v29

				v28.TextSize = v5
				v28.TextColor3 = theme.TextDefault.Color
				v28.TextTransparency = theme.TextDefault.Transparency
				local v26 = {
					DisclosurePayment = createElement6("TextLabel", v28),
					DisclosureTermsFrame = 0
				}
				local v30

				if not self.props.isQuest then
					v30 = Roact.createElement(fitFrameVertical, {
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
							Text = v10[1],
							TextSize = v5,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency
						}),
						TermsOfUse = Roact.createElement("TextButton", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							RichText = true,
							AutomaticSize = Enum.AutomaticSize.XY,
							FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
							Text = v11,
							TextSize = v5,
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
							Text = v10[2],
							TextSize = v5,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency
						})
					})
				end

				v26.DisclosureTermsFrame = v30
				children.DisclosureFrame = createElement5(fitFrameVertical, v25, v26)
				return createElement2(fitFrameVertical, v15, children)
			end,
			buttonStackInfo = 0
		}

		local v14 = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			marginBetween = 0,
			buttons = 0
		}
		local v15 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN or Constants.MODAL_NORMAL_BUTTON_MARGIN else Constants.MODAL_NORMAL_BUTTON_MARGIN
		v14.marginBetween = v15
		local v16

		if self.props.isQuest then
			v16 = {
				{
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = data2.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}
			}
		else
			v16 = { nil, nil }
			local v17 = {
				props = {
					isDisabled = props.isDisabled,
					onActivated = props.cancelPurchaseActivated,
					text = data2.ButtonCancel,
					inputIcon = props.cancelControllerIcon
				}
			}

			local v18 = { buttonType = buttonType.PrimarySystem, props = 0 }
			local v19 = {
				isLoading = props.isLoading,
				isDisabled = props.isDisabled,
				isDelayedInput = props.isDelayedInput,
				enableInputDelayed = props.enableInputDelayed,
				delayInputSeconds = props.inputDelaySec,
				onActivated = props.buyItemActivated,
				text = 0,
				inputIcon = 0
			}
			local v20 = if props.enableInputDelayed then data2.LoadingText else data2.BuyRobuxButton
			v19.text = v20
			v19.inputIcon = props.buyItemControllerIcon
			v18.props = v19
			v16[1], v16[2] = v17, v18
		end

		v14.buttons = v16
		v13.buttonStackInfo = v14
		return createElement(interactiveAlert, v13)
	end)
end

function extended:renderAlertNewProductDetails(p2)
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
	})(function(data2)
		return withStyle(function(props2)
			local theme = props2.Theme
			local font = props2.Font

			local v5 = font.BaseSize * font.Body.RelativeSize
			v5 = getEnableCondenseRobuxUpsell() and state.isCondensed and v5 * 0.9 or v5

			local v6 = props.itemRobuxCost - props.balanceAmount

			local v7 = data2.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v6))

			local color = Color3.new(
				math.round(theme.TextEmphasis.Color.R * 255),
				math.round(theme.TextEmphasis.Color.G * 255),
				(math.round(theme.TextEmphasis.Color.B * 255))
			)

			local v8 = string.format(
				"<font color=\"rgb(%s)\">%s%s</font>",
				tostring(color),
				utf8.char(57346),
				(tostring(props.robuxPurchaseAmount))
			)

			local v9 = data2.WouldYouBuy:gsub("{robux}", v8)

			local v10 = string.split(data2.DisclosureTermsURL, "{termsofuse}")

			local v11 = data2.TermsOfUse

			if props.termsOfUseActivated then
				v11 = "<u>" .. v11 .. "</u>"
			end

			local gameId = if game.GameId then tostring(game.GameId) else nil
			local v12 = if props.itemProductId then tostring(props.itemProductId) else nil

			local v13 = {
				layoutOrder = 1,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				itemRobuxCost = props.itemRobuxCost,
				itemIconWidth = 0,
				itemIconHeight = 0
			}
			local v14 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil else nil
			v13.itemIconWidth = v14

			local v15 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil else nil
			v13.itemIconHeight = v15
			v12 = gameId and v12 or v12
			local v20
			v20 = Roact.createElement(module10, v13)

			local createElement = Roact.createElement
			local v22 = {
				screenSize = props.screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint,
				title = data2.NeedMoreRobux,
				middleContent = function()
					local createElement2 = Roact.createElement
					local v24 = {
						BackgroundTransparency = 1,
						["width"] = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}
					local v25 = if getEnableCondenseRobuxUpsell() then UDim.new(
						0,
						state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING
					) else UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING)
					v24.contentPadding = v25

					v24[Roact.Ref] = self.contentRef
					v24[Roact.Change.AbsoluteSize] = self.changeContentSize
					local children = {
						ProductDetails = v20,
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
					local v27 = {
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
					local v28 = if self.props.isQuest then v7 else v7 .. " " .. v9
					v27.Text = v28

					v27.TextSize = v5
					v27.TextColor3 = theme.TextDefault.Color
					v27.TextTransparency = theme.TextDefault.Transparency
					children.AdditionalBuyText = createElement3("TextLabel", v27)

					children.Underline2 = Roact.createElement("Frame", {
						LayoutOrder = 4,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					})

					local createElement4 = Roact.createElement
					local v30 = {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}

					local createElement5 = Roact.createElement
					local v33 = {
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
					local v34 = if self.props.isQuest then data2.PurchaseNotAvailableOnHeadSet else data2.DisclosurePayment
					v33.Text = v34

					v33.TextSize = v5
					v33.TextColor3 = theme.TextDefault.Color
					v33.TextTransparency = theme.TextDefault.Transparency
					local v31 = {
						DisclosurePayment = createElement5("TextLabel", v33),
						DisclosureTermsFrame = 0
					}
					local v35

					if not self.props.isQuest then
						v35 = Roact.createElement(fitFrameVertical, {
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
								Text = v10[1],
								TextSize = v5,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							}),
							TermsOfUse = Roact.createElement("TextButton", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								RichText = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = v11,
								TextSize = v5,
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
								Text = v10[2],
								TextSize = v5,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							})
						})
					end

					v31.DisclosureTermsFrame = v35
					children.DisclosureFrame = createElement4(fitFrameVertical, v30, v31)
					return createElement2(fitFrameVertical, v24, children)
				end,
				buttonStackInfo = 0
			}

			local v23 = {
				forcedFillDirection = Enum.FillDirection.Vertical,
				marginBetween = 0,
				buttons = 0
			}
			local v24 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN or Constants.MODAL_NORMAL_BUTTON_MARGIN else Constants.MODAL_NORMAL_BUTTON_MARGIN
			v23.marginBetween = v24
			local v25

			if self.props.isQuest then
				v25 = {
					{
						props = {
							isDisabled = props.isDisabled,
							onActivated = props.cancelPurchaseActivated,
							text = data2.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					}
				}
			else
				v25 = { nil, nil }
				local v26 = {
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = data2.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}

				local v27 = { buttonType = buttonType.PrimarySystem, props = 0 }
				local v28 = {
					isLoading = props.isLoading,
					isDisabled = props.isDisabled,
					isDelayedInput = props.isDelayedInput,
					enableInputDelayed = props.enableInputDelayed,
					delayInputSeconds = props.inputDelaySec,
					onActivated = props.buyItemActivated,
					text = 0,
					inputIcon = 0
				}
				local v29 = if props.enableInputDelayed then data2.LoadingText else data2.BuyRobuxButton
				v28.text = v29

				v28.inputIcon = props.buyItemControllerIcon
				v27.props = v28
				v25[1], v25[2] = v26, v27
			end

			v23.buttons = v25
			v22.buttonStackInfo = v23
			return createElement(interactiveAlert, v22)
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
			local v5 = font.BaseSize * font.Body.RelativeSize
			v5 = getEnableCondenseRobuxUpsell() and state.isCondensed and v5 * 0.9 or v5

			local v6 = font.BaseSize * font.Footer.RelativeSize
			local v7 = props.itemRobuxCost - props.balanceAmount

			local v8 = data.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v7))

			local color = Color3.new(
				math.round(theme.TextEmphasis.Color.R * 255),
				math.round(theme.TextEmphasis.Color.G * 255),
				(math.round(theme.TextEmphasis.Color.B * 255))
			)

			local v9 = string.format(
				"<font color=\"rgb(%s)\">%s%s</font>",
				tostring(color),
				utf8.char(57346),
				(tostring(props.robuxPurchaseAmount))
			)

			local v10 = data.WouldYouBuy:gsub("{robux}", v9)

			local v11 = string.split(data.DisclosureTermsURL, "{termsofuse}")

			local v12 = data.TermsOfUse

			if props.termsOfUseActivated then
				v12 = "<u>" .. v12 .. "</u>"
			end

			local v13

			if props.robuxPurchaseAmountBeforeBonus == nil then
				v13 = ""
			else
				local robuxPurchaseAmountBeforeBonus = tostring(props.robuxPurchaseAmountBeforeBonus)
				local robuxPurchaseAmount = tostring(props.robuxPurchaseAmount)
				local v14 = utf8.char(57346) .. "<s>" .. robuxPurchaseAmountBeforeBonus .. "</s>" .. utf8.char(57346) .. robuxPurchaseAmount
				v10 = data.WouldYouBuy:gsub("{robux}", v14)

				local v15 = props.robuxPurchaseAmount - props.robuxPurchaseAmountBeforeBonus
				local v16 = utf8.char(57346) .. tostring(v15)
				v13 = data.BonusBannerV1:gsub("{robux}", v16)
			end

			local createElement = Roact.createElement
			local v15 = {
				screenSize = props.screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint,
				title = data.NeedMoreRobux,
				middleContent = function()
					local createElement2 = Roact.createElement
					local v17 = {
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
					local v18 = if getEnableCondenseRobuxUpsell() then UDim.new(
						0,
						state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING
					) else UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING)
					v17.contentPadding = v18

					v17[Roact.Ref] = self.contentRef
					v17[Roact.Change.AbsoluteSize] = self.changeContentSize

					local createElement3 = Roact.createElement
					local v20 = {
						layoutOrder = 1,
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						itemIconWidth = 0,
						itemIconHeight = 0
					}
					local v21 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil else nil
					v20.itemIconWidth = v21

					local v22 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil else nil
					v20.itemIconHeight = v22
					local children = {
						ProductDetails = createElement3(module10, v20),
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
					local v24 = {
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
					local v25 = if self.props.isQuest then v8 else v8 .. " " .. v10
					v24.Text = v25

					v24.TextSize = v5
					v24.TextColor3 = theme.TextDefault.Color
					v24.TextTransparency = theme.TextDefault.Transparency
					children.AdditionalBuyText = createElement4("TextLabel", v24)

					children.Underline2 = Roact.createElement("Frame", {
						LayoutOrder = 4,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					})

					local createElement5 = Roact.createElement
					local v27 = {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}

					local createElement6 = Roact.createElement
					local v30 = {
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
					local v31 = if self.props.isQuest then data.PurchaseNotAvailableOnHeadSet else data.DisclosurePayment
					v30.Text = v31

					v30.TextSize = v6
					v30.TextColor3 = theme.TextDefault.Color
					v30.TextTransparency = theme.TextDefault.Transparency
					local v28 = {
						DisclosurePayment = createElement6("TextLabel", v30),
						DisclosureTermsFrame = 0
					}
					local v32

					if not self.props.isQuest then
						v32 = Roact.createElement(fitFrameVertical, {
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
								Text = v11[1],
								TextSize = v6,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							}),
							TermsOfUse = Roact.createElement("TextButton", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								RichText = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								Text = v12,
								TextSize = v6,
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
								Text = v11[2],
								TextSize = v6,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency
							})
						})
					end

					v28.DisclosureTermsFrame = v32
					children.DisclosureFrame = createElement5(fitFrameVertical, v27, v28)
					return createElement2(fitFrameVertical, v17, children)
				end,
				buttonStackInfo = 0,
				footerContent = 0
			}

			local v16 = {
				forcedFillDirection = Enum.FillDirection.Vertical,
				marginBetween = 0,
				buttons = 0
			}
			local v17 = if getEnableCondenseRobuxUpsell() then state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN or Constants.MODAL_NORMAL_BUTTON_MARGIN else Constants.MODAL_NORMAL_BUTTON_MARGIN
			v16.marginBetween = v17
			local v18

			if self.props.isQuest then
				v18 = {
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
				v18 = { nil, nil }
				local v19 = {
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = data.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}

				local v20 = { buttonType = buttonType.PrimarySystem, props = 0 }
				local v21 = {
					isLoading = props.isLoading,
					isDisabled = props.isDisabled,
					isDelayedInput = props.isDelayedInput,
					enableInputDelayed = props.enableInputDelayed,
					delayInputSeconds = props.inputDelaySec,
					onActivated = props.buyItemActivated,
					text = 0,
					inputIcon = 0
				}
				local v22 = if props.enableInputDelayed then data.LoadingText else data.BuyRobuxButton
				v21.text = v22

				v21.inputIcon = props.buyItemControllerIcon
				v20.props = v21
				v18[1], v18[2] = v19, v20
			end

			v16.buttons = v18
			v15.buttonStackInfo = v16

			function v15.footerContent()
				return self:renderFooterExperiment(props2, v13, data.BonusBannerInfo)
			end

			return createElement(interactiveAlert, v15)
		end)
	end)
end

function extended:renderFooterExperiment(p2, p3, p4)
	local font = p2.Font
	local flint = colors.Flint

	if p3 == "" then
		return nil
	end

	local createElement = Roact.createElement
	local v6 = {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = { top = 0, bottom = -24, left = -24, right = -24 },
		[Roact.Ref] = self.footerRef,
		[Roact.Change.AbsoluteSize] = self.changeFooterSize
	}

	local createElement2 = Roact.createElement
	local v9 = {
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
	local v12 = {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = { top = 12, bottom = 0, left = 0, right = 0 },
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}
	local v13 = {
		BonusBefore = Roact.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			RichText = true,
			FontFace = normalizeFontFace(p2.Tokens.Typography.CaptionSmall.Font),
			Text = p3,
			TextSize = font.BaseSize * font.Footer.RelativeSize,
			TextColor3 = flint,
			TextWrapped = true
		}),
		InfoIcon = 0
	}

	local v14 = if FFlagLowCogsBannerInfoIcon then InfoIconWithTooltip({
		text = p4,
		layoutOrder = 2,
		color = flint,
		eventActivated = self.bonusBannerInfoIconStateChange
	}) else nil
	v13.InfoIcon = v14
	return createElement(fitFrameVertical, v6, {
		Banner = createElement2("ImageLabel", v9, {
			BannerContent = createElement3(fitFrameVertical, v12, v13)
		})
	})
end

return extended
