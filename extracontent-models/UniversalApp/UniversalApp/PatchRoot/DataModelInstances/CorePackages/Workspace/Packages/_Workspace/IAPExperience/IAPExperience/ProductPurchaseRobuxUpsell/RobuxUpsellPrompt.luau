local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local FitFrameVertical = require(scriptParentParentParent.RoactFitComponents).FitFrameVertical
local Colors = require(scriptParentParentParent.Style).Colors
local UIBlox = require(scriptParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle
local FFlagLowCogsBannerInfoIcon = require(scriptParentParent.Flags.FFlagLowCogsBannerInfoIcon)
local InfoIconWithTooltip = require(scriptParentParent.Generic.InfoIconWithTooltip)
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(scriptParentParentParent.AppLocales).Localization
local LocalizationProvider = require(scriptParentParentParent.Localization).LocalizationProvider
local withLocalization = require(scriptParentParentParent.Localization).withLocalization
local _ = require(scriptParentParentParent.IXPServiceWrapper).IXPServiceWrapper
local SharedFlags = require(scriptParentParentParent.SharedFlags)
local default = require(scriptParentParentParent.LoggingProtocol).default
local LegacyUpsellCounter = require(scriptParentParent.Generic.Events.LegacyUpsellCounter)
local logger = require(scriptParentParent.Utility.logger)
local FFlagMobilePopularItemBadgingExperimentEnabled = require(scriptParentParent.Flags.FFlagMobilePopularItemBadgingExperimentEnabled)

require(scriptParentParent.Flags.GetFStringMobilePopularItemBadgingLayer)

local ProductDetails = require(scriptParent.ProductDetails)
local ProductDetailsNew = require(scriptParent.ProductDetailsNew)
local Constants = require(scriptParentParent.Generic.Constants)
local getEnableCondenseRobuxUpsell = require(scriptParentParent.Flags.getEnableCondenseRobuxUpsell)
local FFlagIntroduceMetricsLegacyUpsell = require(scriptParentParent.Flags.FFlagIntroduceMetricsLegacyUpsell)
local v29 = Roact.Component:extend(script.Name)

v29.defaultProps = {
	isLoading = false,
	isDisabled = false,
	isDelayedInput = false,
	isQuest = false,
	enableInputDelayed = false,
	inputDelaySec = 3,
	isVng = false,
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v29.init(p1) -- line: 107
	-- upvalues: Roact (copy), getEnableCondenseRobuxUpsell (copy), Constants (copy)
	p1.contentRef = Roact.createRef()
	p1.state = {
		isCondensed = false,
		contentSize = Vector2.new(0, 0),
		footerSize = Vector2.new(0, 0)
	}

	function p1.validateCondensedCondition(p2) -- line: 115
		-- upvalues: getEnableCondenseRobuxUpsell (copy), Constants (copy), p1 (copy)
		if not getEnableCondenseRobuxUpsell() then
			return
		end

		local v52 = p2.AbsoluteSize.Y + Constants.MODAL_HEIGHT_WITHOUT_CONTENT + Constants.MODAL_NORMAL_SECTION_PADDING * 2 + Constants.MODAL_NORMAL_BUTTON_HEIGHT * 2

		if p1.state.isCondensed then
			p1:setState({
				isCondensed = p1.props.screenSize.Y < v52 + (Constants.MODAL_NORMAL_CONTENT_PADDING - Constants.MODAL_CONDENSED_CONTENT_PADDING) * 6 + (Constants.MODAL_NORMAL_BUTTON_MARGIN - Constants.MODAL_CONDENSED_BUTTON_MARGIN) + (Constants.NORMAL_ICON_SIZE - Constants.CONDENSED_ICON_SIZE)
			})

			return
		end

		p1:setState({
			isCondensed = p1.props.screenSize.Y < v52 + Constants.MODAL_NORMAL_BUTTON_MARGIN
		})
	end
	function p1.changeContentSize(p3) -- line: 143
		-- upvalues: p1 (copy)
		p1.validateCondensedCondition(p3)

		if p1.state.contentSize ~= p3.AbsoluteSize then
			p1:setState({
				contentSize = p3.AbsoluteSize
			})
		end
	end
end
function v29.didMount(_) -- line: 153
	-- upvalues: FFlagIntroduceMetricsLegacyUpsell (copy), logger (copy), default (copy), LegacyUpsellCounter (copy)
	if FFlagIntroduceMetricsLegacyUpsell then
		logger.debug({
			message = "Legacy Upsell Modal Shown"
		})
		default:logRobloxTelemetryCounter(LegacyUpsellCounter.LegacyUpsellShownCounter, 1, {})
	end
end
function v29.render(p5) -- line: 162
	-- upvalues: SharedFlags (copy), Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), FFlagMobilePopularItemBadgingExperimentEnabled (copy), MultiTextLocalizer (copy)
	local v33 = not p5.props.isVng and "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL" or "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL"

	if SharedFlags.FFlagLowCogsBannerExperiment then
		return Roact.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			Alert = p5:renderNewAlert()
		})
	end

	if FFlagMobilePopularItemBadgingExperimentEnabled then
		return Roact.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			Alert = p5:renderAlertNewProductDetails()
		})
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientRobuxTitle = {
				key = "IAPExperience.RobuxUpsell.Title.InsufficientRobux"
			},
			AdditionalRobux = {
				key = "IAPExperience.RobuxUpsell.Text.AdditionalRobux"
			},
			WouldYouBuy = {
				key = "IAPExperience.RobuxUpsell.Text.WouldYouBuy"
			},
			DisclosurePayment = {
				key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment"
			},
			DisclosureTermsURL = {
				key = v33
			},
			TermsOfUse = {
				key = "IAPExperience.RobuxUpsell.Text.TermsOfUse"
			},
			BuyRobuxButton = {
				key = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem"
			},
			ButtonCancel = {
				key = "IAPExperience.RobuxUpsell.Action.Cancel"
			},
			LoadingText = {
				key = "IAPExperience.RobuxUpsell.Text.Loading"
			},
			PurchaseNotAvialableForQuest = {
				key = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet"
			}
		},
		render = function(t1: {[any]: any}) -- line: 220
			-- upvalues: p5 (copy)
			return p5:renderAlert(t1)
		end
	})
end
function v29.renderAlert(t2: {[any]: any}, t3: {[any]: any}) -- line: 226
	-- upvalues: withStyle (copy), getEnableCondenseRobuxUpsell (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), Constants (copy), ProductDetails (copy), ButtonType (copy)
	local props = t2.props
	local state = t2.state

	return withStyle(function(p6) -- line: 230
		-- upvalues: getEnableCondenseRobuxUpsell (copy), state (copy), props (copy), t3 (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), Constants (copy), t2 (copy), ProductDetails (copy), ButtonType (copy)
		local Theme = p6.Theme
		local p6Font = p6.Font
		local u58 = p6Font.BaseSize * p6Font.Body.RelativeSize

		if getEnableCondenseRobuxUpsell() then
			u58 = state.isCondensed and u58 * 0.9 or u58
		end

		local v59 = props.itemRobuxCost - props.balanceAmount
		local v60 = t3.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v59))
		local color3 = Color3.new(math.round(Theme.TextEmphasis.Color.R * 255), math.round(Theme.TextEmphasis.Color.G * 255), (math.round(Theme.TextEmphasis.Color.B * 255)))
		local v62 = string.format("<font color=\"rgb(%s)\">%s%s</font>", tostring(color3), utf8.char(57346), (tostring(props.robuxPurchaseAmount)))
		local v63 = t3.WouldYouBuy:gsub("{robux}", v62)
		local parts = string.split(t3.DisclosureTermsURL, "{termsofuse}")
		local TermsOfUse = t3.TermsOfUse

		if props.termsOfUseActivated then
			TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
		end

		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = t3.InsufficientRobuxTitle,
			middleContent = function() -- line: 266
				-- upvalues: Roact (copy), FitFrameVertical (copy), getEnableCondenseRobuxUpsell (copy), state (copy), Constants (copy), t2 (copy), ProductDetails (copy), props (copy), Theme (copy), p6Font (copy), v60 (copy), v63 (copy), u58 (ref), t3 (copy), parts (copy), TermsOfUse (ref)
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = if not getEnableCondenseRobuxUpsell() then UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING) else UDim.new(0, state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING),
					[Roact.Ref] = t2.contentRef,
					[Roact.Change.AbsoluteSize] = t2.changeContentSize
				}, {
					ProductDetails = Roact.createElement(ProductDetails, {
						layoutOrder = 1,
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						itemIconWidth = if not getEnableCondenseRobuxUpsell() then nil else state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil,
						itemIconHeight = if not getEnableCondenseRobuxUpsell() then nil else state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
					}),
					Underline = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					}),
					AdditionalBuyText = Roact.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						RichText = true,
						TextWrapped = true,
						Size = UDim2.new(0, t2.state.contentSize.X, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Font = p6Font.Body.Font,
						Text = if not t2.props.isQuest then v60 .. " " .. v63 else v60,
						TextSize = u58,
						TextColor3 = Theme.TextDefault.Color,
						TextTransparency = Theme.TextDefault.Transparency
					}),
					Underline2 = Roact.createElement("Frame", {
						LayoutOrder = 4,
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					}),
					DisclosureFrame = Roact.createElement(FitFrameVertical, {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}, {
						DisclosurePayment = Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							TextWrapped = true,
							AutomaticSize = Enum.AutomaticSize.XY,
							Font = p6Font.Body.Font,
							Text = if not t2.props.isQuest then t3.DisclosurePayment else t3.PurchaseNotAvailableOnHeadSet,
							TextSize = u58,
							TextColor3 = Theme.TextDefault.Color,
							TextTransparency = Theme.TextDefault.Transparency
						}),
						DisclosureTermsFrame = if not t2.props.isQuest then Roact.createElement(FitFrameVertical, {
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
								Font = p6Font.Body.Font,
								Text = parts[1],
								TextSize = u58,
								TextColor3 = Theme.TextDefault.Color,
								TextTransparency = Theme.TextDefault.Transparency
							}),
							TermsOfUse = Roact.createElement("TextButton", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								RichText = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								Font = p6Font.Body.Font,
								Text = TermsOfUse,
								TextSize = u58,
								TextColor3 = Theme.TextDefault.Color,
								TextTransparency = Theme.TextDefault.Transparency,
								Selectable = props.termsOfUseActivated ~= nil,
								[Roact.Event.Activated] = props.termsOfUseActivated
							}),
							AfterDisclosureText = Roact.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY,
								Font = p6Font.Body.Font,
								Text = parts[2],
								TextSize = u58,
								TextColor3 = Theme.TextDefault.Color,
								TextTransparency = Theme.TextDefault.Transparency
							})
						}) else nil
					})
				})
			end,
			buttonStackInfo = {
				forcedFillDirection = Enum.FillDirection.Vertical,
				marginBetween = if not getEnableCondenseRobuxUpsell() then Constants.MODAL_NORMAL_BUTTON_MARGIN else state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN or Constants.MODAL_NORMAL_BUTTON_MARGIN,
				buttons = if not t2.props.isQuest then {
					{
						props = {
							isDisabled = props.isDisabled,
							onActivated = props.cancelPurchaseActivated,
							text = t3.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isLoading = props.isLoading,
							isDisabled = props.isDisabled,
							isDelayedInput = props.isDelayedInput,
							enableInputDelayed = props.enableInputDelayed,
							delayInputSeconds = props.inputDelaySec,
							onActivated = props.buyItemActivated,
							text = if not props.enableInputDelayed then t3.BuyRobuxButton else t3.LoadingText,
							inputIcon = props.buyItemControllerIcon
						}
					}
				} else {{
					props = {
						isDisabled = props.isDisabled,
						onActivated = props.cancelPurchaseActivated,
						text = t3.ButtonCancel,
						inputIcon = props.cancelControllerIcon
					}
				}}
			}
		})
	end)
end
function v29.renderAlertNewProductDetails(t4: {[any]: any}, _: {[any]: any}) -- line: 450
	-- upvalues: withLocalization (copy), withStyle (copy), getEnableCondenseRobuxUpsell (copy), Constants (copy), Roact (copy), ProductDetailsNew (copy), ProductDetails (copy), InteractiveAlert (copy), FitFrameVertical (copy), ButtonType (copy)
	local props = t4.props
	local state = t4.state

	return withLocalization({
		InsufficientRobuxTitle = "IAPExperience.RobuxUpsell.Title.InsufficientRobux",
		AdditionalRobux = "IAPExperience.RobuxUpsell.Text.AdditionalRobux",
		WouldYouBuy = "IAPExperience.RobuxUpsell.Text.WouldYouBuy",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		PurchaseNotAvialableForQuest = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet",
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		BadgeText = "IAPExperience.RobuxUpsell.Text.PopularItem",
		DisclosureTermsURL = not t4.props.isVng and "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL" or "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL"
	})(function(t6: {[any]: any}) -- line: 468
		-- upvalues: withStyle (copy), getEnableCondenseRobuxUpsell (copy), state (copy), props (copy), Constants (copy), Roact (copy), ProductDetailsNew (copy), ProductDetails (copy), InteractiveAlert (copy), FitFrameVertical (copy), t4 (copy), ButtonType (copy)
		return withStyle(function(p7) -- line: 469
			-- upvalues: getEnableCondenseRobuxUpsell (copy), state (copy), props (copy), t6 (copy), Constants (copy), Roact (copy), ProductDetailsNew (copy), ProductDetails (copy), InteractiveAlert (copy), FitFrameVertical (copy), t4 (copy), ButtonType (copy)
			local Theme = p7.Theme
			local p7Font = p7.Font
			local u71 = p7Font.BaseSize * p7Font.Body.RelativeSize

			if getEnableCondenseRobuxUpsell() then
				u71 = state.isCondensed and u71 * 0.9 or u71
			end

			local v72 = props.itemRobuxCost - props.balanceAmount
			local v73 = t6.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v72))
			local color3 = Color3.new(math.round(Theme.TextEmphasis.Color.R * 255), math.round(Theme.TextEmphasis.Color.G * 255), (math.round(Theme.TextEmphasis.Color.B * 255)))
			local v75 = string.format("<font color=\"rgb(%s)\">%s%s</font>", tostring(color3), utf8.char(57346), (tostring(props.robuxPurchaseAmount)))
			local v76 = t6.WouldYouBuy:gsub("{robux}", v75)
			local parts = string.split(t6.DisclosureTermsURL, "{termsofuse}")
			local TermsOfUse = t6.TermsOfUse

			if props.termsOfUseActivated then
				TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
			end

			local v79 = if not game.GameId then nil else tostring(game.GameId)
			local v80 = if not props.itemProductId then nil else tostring(props.itemProductId)
			local t7 = {
				layoutOrder = 1,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				itemRobuxCost = props.itemRobuxCost,
				itemIconWidth = if not getEnableCondenseRobuxUpsell() then nil else state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil,
				itemIconHeight = if not getEnableCondenseRobuxUpsell() then nil else state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
			}
			local v82 = false
			local n1 = 0

			if v79 then
				if not v80 then
				end
			end

			local u85

			if v82 and n1 ~= 0 then
				local v84 = table.clone(t7)

				v84.isPopularItem = v82
				v84.catalogSize = nil
				v84.salesRank = nil
				v84.badgeText = t6.BadgeText
				v84.universeId = v79
				v84.itemProductId = v80
				v84.userVariant = n1
				u85 = Roact.createElement(ProductDetailsNew, v84)
			else
				u85 = Roact.createElement(ProductDetails, t7)
			end

			return Roact.createElement(InteractiveAlert, {
				screenSize = props.screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint,
				title = t6.NeedMoreRobux,
				middleContent = function() -- line: 570
					-- upvalues: Roact (copy), FitFrameVertical (copy), getEnableCondenseRobuxUpsell (copy), state (copy), Constants (copy), t4 (copy), u85 (ref), Theme (copy), p7Font (copy), v73 (copy), v76 (copy), u71 (ref), t6 (copy), parts (copy), TermsOfUse (ref), props (copy)
					return Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = if not getEnableCondenseRobuxUpsell() then UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING) else UDim.new(0, state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING),
						[Roact.Ref] = t4.contentRef,
						[Roact.Change.AbsoluteSize] = t4.changeContentSize
					}, {
						ProductDetails = u85,
						SimulateMargin = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(0, 12, 0, 12)
						}),
						Underline = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						AdditionalBuyText = Roact.createElement("TextLabel", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							RichText = true,
							TextWrapped = true,
							Size = UDim2.new(0, t4.state.contentSize.X, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Font = p7Font.Body.Font,
							Text = if not t4.props.isQuest then v73 .. " " .. v76 else v73,
							TextSize = u71,
							TextColor3 = Theme.TextDefault.Color,
							TextTransparency = Theme.TextDefault.Transparency
						}),
						Underline2 = Roact.createElement("Frame", {
							LayoutOrder = 4,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						DisclosureFrame = Roact.createElement(FitFrameVertical, {
							LayoutOrder = 5,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							DisclosurePayment = Roact.createElement("TextLabel", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								TextWrapped = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								Font = p7Font.Body.Font,
								Text = if not t4.props.isQuest then t6.DisclosurePayment else t6.PurchaseNotAvailableOnHeadSet,
								TextSize = u71,
								TextColor3 = Theme.TextDefault.Color,
								TextTransparency = Theme.TextDefault.Transparency
							}),
							DisclosureTermsFrame = if not t4.props.isQuest then Roact.createElement(FitFrameVertical, {
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
									Font = p7Font.Body.Font,
									Text = parts[1],
									TextSize = u71,
									TextColor3 = Theme.TextDefault.Color,
									TextTransparency = Theme.TextDefault.Transparency
								}),
								TermsOfUse = Roact.createElement("TextButton", {
									LayoutOrder = 1,
									BackgroundTransparency = 1,
									RichText = true,
									AutomaticSize = Enum.AutomaticSize.XY,
									Font = p7Font.Body.Font,
									Text = TermsOfUse,
									TextSize = u71,
									TextColor3 = Theme.TextDefault.Color,
									TextTransparency = Theme.TextDefault.Transparency,
									Selectable = props.termsOfUseActivated ~= nil,
									[Roact.Event.Activated] = props.termsOfUseActivated
								}),
								AfterDisclosureText = Roact.createElement("TextLabel", {
									LayoutOrder = 2,
									BackgroundTransparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY,
									Font = p7Font.Body.Font,
									Text = parts[2],
									TextSize = u71,
									TextColor3 = Theme.TextDefault.Color,
									TextTransparency = Theme.TextDefault.Transparency
								})
							}) else nil
						})
					})
				end,
				buttonStackInfo = {
					forcedFillDirection = Enum.FillDirection.Vertical,
					marginBetween = if not getEnableCondenseRobuxUpsell() then Constants.MODAL_NORMAL_BUTTON_MARGIN else state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN or Constants.MODAL_NORMAL_BUTTON_MARGIN,
					buttons = if not t4.props.isQuest then {
						{
							props = {
								isDisabled = props.isDisabled,
								onActivated = props.cancelPurchaseActivated,
								text = t6.ButtonCancel,
								inputIcon = props.cancelControllerIcon
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								isLoading = props.isLoading,
								isDisabled = props.isDisabled,
								isDelayedInput = props.isDelayedInput,
								enableInputDelayed = props.enableInputDelayed,
								delayInputSeconds = props.inputDelaySec,
								onActivated = props.buyItemActivated,
								text = if not props.enableInputDelayed then t6.BuyRobuxButton else t6.LoadingText,
								inputIcon = props.buyItemControllerIcon
							}
						}
					} else {{
						props = {
							isDisabled = props.isDisabled,
							onActivated = props.cancelPurchaseActivated,
							text = t6.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					}}
				}
			})
		end)
	end)
end
function v29.renderNewAlert(p8) -- line: 752
	-- upvalues: withLocalization (copy), withStyle (copy), getEnableCondenseRobuxUpsell (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), Constants (copy), ProductDetails (copy), ButtonType (copy)
	local props = p8.props
	local state = p8.state

	return withLocalization({
		InsufficientRobuxTitle = "IAPExperience.RobuxUpsell.Title.InsufficientRobux",
		AdditionalRobux = "IAPExperience.RobuxUpsell.Text.AdditionalRobux",
		WouldYouBuy = "IAPExperience.RobuxUpsell.Text.WouldYouBuy",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		PurchaseNotAvialableForQuest = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet",
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		BonusBannerV1 = "IAPExperience.RobuxUpsell.Text.BonusBannerV1",
		BonusBannerInfo = "IAPExperience.RobuxUpsell.Text.BonusBannerInfo",
		DisclosureTermsURL = not p8.props.isVng and "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL" or "IAPExperience.RobuxUpsell.Text.VNGDisclosureTermsURL"
	})(function(t8: {[any]: any}) -- line: 772
		-- upvalues: withStyle (copy), getEnableCondenseRobuxUpsell (copy), state (copy), props (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), Constants (copy), p8 (copy), ProductDetails (copy), ButtonType (copy)
		return withStyle(function(p9) -- line: 773
			-- upvalues: getEnableCondenseRobuxUpsell (copy), state (copy), props (copy), t8 (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), Constants (copy), p8 (copy), ProductDetails (copy), ButtonType (copy)
			local Theme = p9.Theme
			local p9Font = p9.Font
			local u89 = p9Font.BaseSize * p9Font.Body.RelativeSize

			if getEnableCondenseRobuxUpsell() then
				u89 = state.isCondensed and u89 * 0.9 or u89
			end

			local v90 = p9Font.BaseSize * p9Font.Footer.RelativeSize
			local v91 = props.itemRobuxCost - props.balanceAmount
			local v92 = t8.AdditionalRobux:gsub("{robux}", utf8.char(57346) .. tostring(v91))
			local color3 = Color3.new(math.round(Theme.TextEmphasis.Color.R * 255), math.round(Theme.TextEmphasis.Color.G * 255), (math.round(Theme.TextEmphasis.Color.B * 255)))
			local v94 = string.format("<font color=\"rgb(%s)\">%s%s</font>", tostring(color3), utf8.char(57346), (tostring(props.robuxPurchaseAmount)))
			local u95 = t8.WouldYouBuy:gsub("{robux}", v94)
			local parts = string.split(t8.DisclosureTermsURL, "{termsofuse}")
			local TermsOfUse = t8.TermsOfUse

			if props.termsOfUseActivated then
				TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
			end

			local s1 = ""

			if props.robuxPurchaseAmountBeforeBonus ~= nil then
				local str = tostring(props.robuxPurchaseAmountBeforeBonus)
				local str2 = tostring(props.robuxPurchaseAmount)
				local v101 = utf8.char(57346) .. "<s>" .. str .. "</s>" .. utf8.char(57346) .. str2

				u95 = t8.WouldYouBuy:gsub("{robux}", v101)

				local v102 = props.robuxPurchaseAmount - props.robuxPurchaseAmountBeforeBonus
				local v103 = utf8.char(57346) .. tostring(v102)

				s1 = t8.BonusBannerV1:gsub("{robux}", v103)
			end

			return Roact.createElement(InteractiveAlert, {
				screenSize = props.screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint,
				title = t8.NeedMoreRobux,
				middleContent = function() -- line: 830
					-- upvalues: Roact (copy), FitFrameVertical (copy), getEnableCondenseRobuxUpsell (copy), state (copy), Constants (copy), p8 (copy), ProductDetails (copy), props (copy), Theme (copy), p9Font (copy), v92 (copy), u95 (ref), u89 (ref), t8 (copy), v90 (copy), parts (copy), TermsOfUse (ref)
					return Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(0, 255, 0),
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = if not getEnableCondenseRobuxUpsell() then UDim.new(0, Constants.MODAL_NORMAL_CONTENT_PADDING) else UDim.new(0, state.isCondensed and Constants.MODAL_CONDENSED_CONTENT_PADDING or Constants.MODAL_NORMAL_CONTENT_PADDING),
						[Roact.Ref] = p8.contentRef,
						[Roact.Change.AbsoluteSize] = p8.changeContentSize
					}, {
						ProductDetails = Roact.createElement(ProductDetails, {
							layoutOrder = 1,
							model = props.model,
							itemIcon = props.itemIcon,
							itemName = props.itemName,
							itemRobuxCost = props.itemRobuxCost,
							itemIconWidth = if not getEnableCondenseRobuxUpsell() then nil else state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil,
							itemIconHeight = if not getEnableCondenseRobuxUpsell() then nil else state.isCondensed and Constants.CONDENSED_ICON_SIZE or nil
						}),
						Underline = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						AdditionalBuyText = Roact.createElement("TextLabel", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							RichText = true,
							TextWrapped = true,
							Size = UDim2.new(0, p8.state.contentSize.X, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Font = p9Font.Body.Font,
							Text = if not p8.props.isQuest then v92 .. " " .. u95 else v92,
							TextSize = u89,
							TextColor3 = Theme.TextDefault.Color,
							TextTransparency = Theme.TextDefault.Transparency
						}),
						Underline2 = Roact.createElement("Frame", {
							LayoutOrder = 4,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						DisclosureFrame = Roact.createElement(FitFrameVertical, {
							LayoutOrder = 5,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							DisclosurePayment = Roact.createElement("TextLabel", {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								TextWrapped = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								Font = p9Font.Body.Font,
								Text = if not p8.props.isQuest then t8.DisclosurePayment else t8.PurchaseNotAvailableOnHeadSet,
								TextSize = v90,
								TextColor3 = Theme.TextDefault.Color,
								TextTransparency = Theme.TextDefault.Transparency
							}),
							DisclosureTermsFrame = if not p8.props.isQuest then Roact.createElement(FitFrameVertical, {
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
									Font = p9Font.Body.Font,
									Text = parts[1],
									TextSize = v90,
									TextColor3 = Theme.TextDefault.Color,
									TextTransparency = Theme.TextDefault.Transparency
								}),
								TermsOfUse = Roact.createElement("TextButton", {
									LayoutOrder = 1,
									BackgroundTransparency = 1,
									RichText = true,
									AutomaticSize = Enum.AutomaticSize.XY,
									Font = p9Font.Body.Font,
									Text = TermsOfUse,
									TextSize = v90,
									TextColor3 = Theme.TextDefault.Color,
									TextTransparency = Theme.TextDefault.Transparency,
									Selectable = props.termsOfUseActivated ~= nil,
									[Roact.Event.Activated] = props.termsOfUseActivated
								}),
								AfterDisclosureText = Roact.createElement("TextLabel", {
									LayoutOrder = 2,
									BackgroundTransparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY,
									Font = p9Font.Body.Font,
									Text = parts[2],
									TextSize = v90,
									TextColor3 = Theme.TextDefault.Color,
									TextTransparency = Theme.TextDefault.Transparency
								})
							}) else nil
						})
					})
				end,
				buttonStackInfo = {
					forcedFillDirection = Enum.FillDirection.Vertical,
					marginBetween = if not getEnableCondenseRobuxUpsell() then Constants.MODAL_NORMAL_BUTTON_MARGIN else state.isCondensed and Constants.MODAL_CONDENSED_BUTTON_MARGIN or Constants.MODAL_NORMAL_BUTTON_MARGIN,
					buttons = if not p8.props.isQuest then {
						{
							props = {
								isDisabled = props.isDisabled,
								onActivated = props.cancelPurchaseActivated,
								text = t8.ButtonCancel,
								inputIcon = props.cancelControllerIcon
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								isLoading = props.isLoading,
								isDisabled = props.isDisabled,
								isDelayedInput = props.isDelayedInput,
								enableInputDelayed = props.enableInputDelayed,
								delayInputSeconds = props.inputDelaySec,
								onActivated = props.buyItemActivated,
								text = if not props.enableInputDelayed then t8.BuyRobuxButton else t8.LoadingText,
								inputIcon = props.buyItemControllerIcon
							}
						}
					} else {{
						props = {
							isDisabled = props.isDisabled,
							onActivated = props.cancelPurchaseActivated,
							text = t8.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					}}
				},
				footerContent = function() -- line: 1007
					-- upvalues: p8 (copy), p9 (copy), s1 (ref), t8 (copy)
					return p8:renderFooterExperiment(p9, s1, t8.BonusBannerInfo)
				end
			})
		end)
	end)
end
function v29.renderFooterExperiment(p10, p11, p12, p13) -- line: 1015
	-- upvalues: Colors (copy), Roact (copy), FitFrameVertical (copy), FFlagLowCogsBannerInfoIcon (copy), InfoIconWithTooltip (copy)
	local p11Font = p11.Font
	local Flint = Colors.Flint

	if p12 == "" then
		return nil
	end

	return Roact.createElement(FitFrameVertical, {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = {
			top = 0,
			bottom = -24,
			left = -24,
			right = -24
		},
		[Roact.Ref] = p10.footerRef,
		[Roact.Change.AbsoluteSize] = p10.changeFooterSize
	}, {
		Banner = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
			ImageColor3 = Color3.fromRGB(239, 215, 140),
			Size = UDim2.new(1, 0, 0, 40),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 0, 24, 16),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			BannerContent = Roact.createElement(FitFrameVertical, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				margin = {
					top = 12,
					bottom = 0,
					left = 0,
					right = 0
				},
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}, {
				BonusBefore = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					RichText = true,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = p11Font.Footer.Font,
					Text = p12,
					TextSize = p11Font.BaseSize * p11Font.Footer.RelativeSize,
					TextColor3 = Flint
				}),
				InfoIcon = if not FFlagLowCogsBannerInfoIcon then nil else InfoIconWithTooltip({
					layoutOrder = 2,
					text = p13,
					color = Flint,
					eventActivated = p10.bonusBannerInfoIconStateChange
				})
			})
		})
	})
end

return v29
