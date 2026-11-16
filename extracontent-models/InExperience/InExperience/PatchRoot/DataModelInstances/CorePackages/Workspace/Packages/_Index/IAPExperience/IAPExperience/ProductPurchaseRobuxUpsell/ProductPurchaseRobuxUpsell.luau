local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent3.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent3.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Localization3 = require(parent3.Localization)
local withLocalization = Localization3.withLocalization

local RoactFitComponents = require(parent3.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel

local UIBlox = require(parent3.UIBlox)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle

local Style = require(parent3.Style)
local Colors = Style.Colors

local FFlagLowCogsBannerInfoIcon = require(parent2.Flags.FFlagLowCogsBannerInfoIcon)
local InfoIconWithTooltip = require(parent2.Generic.InfoIconWithTooltip)

local SharedFlags = require(parent3.SharedFlags)

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)

local ProductDetails = require(parent.ProductDetails)

local iconscommonrobux = Images["icons/common/robux"]

local extended = Roact.Component:extend(script.Name)

local FFlagIntroduceMetricsLegacyUpsell = require(parent2.Flags.FFlagIntroduceMetricsLegacyUpsell)
local LoggingProtocol = require(parent3.LoggingProtocol)
local default = LoggingProtocol.default
local LegacyUpsellCounter = require(parent2.Generic.Events.LegacyUpsellCounter)
local logger = require(parent2.Utility.logger)

extended.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	screenSize = t.Vector2,
	isLoading = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	isDelayedInput = t.optional(t.boolean),
	enableInputDelayed = t.optional(t.boolean),
	model = t.optional(t.table),
	itemIcon = t.table,
	itemName = t.string,
	itemRobuxCost = t.number,
	robuxPurchaseAmount = t.number,
	robuxPurchaseAmountBeforeBonus = t.optional(t.number),
	balanceAmount = t.number,
	buyItemControllerIcon = t.optional(t.table),
	cancelControllerIcon = t.optional(t.table),
	buyItemActivated = t.callback,
	cancelPurchaseActivated = t.callback,
	isLuobu = t.optional(t.boolean),
	isVng = t.optional(t.boolean)
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0),
	isLoading = false,
	isDisabled = false,
	isDelayedInput = false,
	enableInputDelayed = false,
	isLuobu = false
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.footerRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0), footerSize = Vector2.new(0, 0) }

	function self.changeContentSize(p)
		if self.state.contentSize ~= p.AbsoluteSize then
			self:setState({ contentSize = p.AbsoluteSize })
		end
	end

	function self.changeFooterSize(p)
		if self.state.footerSize ~= p.AbsoluteSize then
			self:setState({ footerSize = p.AbsoluteSize })
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
	local v = self.props.isLuobu and "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestionWithWarning"
		or "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestion"

	local v2 = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTerms"
		or "IAPExperience.RobuxUpsell.Text.DisclosureTerms"

	if SharedFlags.FFlagLowCogsBannerExperiment then
		return Roact.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{ Alert = self:renderNewAlert() }
		)
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientFundsTitle = { key = "IAPExperience.RobuxUpsell.Title.InsufficientFunds" },
			BuyRobuxQuestion = { key = v },
			DisclosurePayment = { key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment" },
			DisclosureTerms = { key = v2 },
			RemainingBalance = { key = "IAPExperience.RobuxUpsell.Text.RemainingBalance" },
			BuyRobuxButton = { key = "IAPExperience.RobuxUpsell.Action.BuyRobux" },
			ButtonCancel = { key = "IAPExperience.RobuxUpsell.Action.Cancel" },
			LoadingText = { key = "IAPExperience.RobuxUpsell.Text.Loading" }
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(data)
	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local balanceAmount = self.props.balanceAmount or 0
		local robuxPurchaseAmount = self.props.robuxPurchaseAmount or 0
		local itemRobuxCost = self.props.itemRobuxCost or 0

		local text = balanceAmount + robuxPurchaseAmount - itemRobuxCost

		return Roact.createElement(InteractiveAlert, {
			screenSize = self.props.screenSize,
			position = self.props.position,
			anchorPoint = self.props.anchorPoint,
			title = data.InsufficientFundsTitle,
			middleContent = function()
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 15),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}, {
					ItemDetails = Roact.createElement(ProductDetails, {
						layoutOrder = 1,
						model = self.props.model,
						itemIcon = self.props.itemIcon,
						itemName = self.props.itemName,
						itemRobuxCost = self.props.itemRobuxCost
					}),
					Underline = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					}),
					ConfirmationFrame = Roact.createElement(FitFrameVertical, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}, {
						WouldYouLikeText = Roact.createElement(FitTextLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							TextWrapped = true,
							maximumWidth = self.state.contentSize.X * 0.8,
							Font = font.Body.Font,
							Text = data.BuyRobuxQuestion,
							TextSize = font.BaseSize * font.Body.RelativeSize,
							TextColor3 = theme.TextDefault.Color
						}),
						RobuxIcon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0, 5),
							Size = UDim2.new(0, 24, 0, 24),
							ScaleType = Enum.ScaleType.Stretch,
							Image = iconscommonrobux,
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = theme.IconEmphasis.Transparency
						}),
						RemainingRobux = Roact.createElement(FitTextLabel, {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							Font = font.Body.Font,
							Text = tostring(self.props.robuxPurchaseAmount),
							TextSize = font.BaseSize * font.Body.RelativeSize,
							TextColor3 = theme.TextEmphasis.Color
						})
					}),
					DisclosureFrame = Roact.createElement(FitFrameVertical, {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}, {
						DisclosurePayment = Roact.createElement(FitTextLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							Font = font.Footer.Font,
							Text = data.DisclosurePayment,
							TextSize = font.BaseSize * font.Footer.RelativeSize,
							TextColor3 = theme.TextDefault.Color,
							TextWrapped = true
						}),
						DisclosureTerms = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							Font = font.Footer.Font,
							Text = data.DisclosureTerms,
							TextSize = font.BaseSize * font.Footer.RelativeSize,
							TextColor3 = theme.TextDefault.Color
						})
					})
				})
			end,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							isDisabled = self.props.isDisabled,
							onActivated = self.props.cancelPurchaseActivated,
							text = data.ButtonCancel,
							inputIcon = self.props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isLoading = self.props.isLoading,
							isDisabled = self.props.isDisabled,
							isDelayedInput = self.props.isDelayedInput,
							enableInputDelayed = self.props.enableInputDelayed,
							delayInputSeconds = 3,
							onActivated = self.props.buyItemActivated,
							text = data.BuyRobuxButton,
							inputIcon = self.props.buyItemControllerIcon
						}
					}
				}
			},
			footerContent = function()
				local v = string.split(data.RemainingBalance, " {robux} ")
				local text2 = v[1]
				local text3 = v[2]
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 1),
					[Roact.Ref] = self.footerRef,
					[Roact.Change.AbsoluteSize] = self.changeFooterSize
				}, {
					RemainingBalanceBefore = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = text2,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					}),
					RobuxIcon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
						ScaleType = Enum.ScaleType.Stretch,
						Image = iconscommonrobux,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = theme.IconEmphasis.Transparency
					}),
					RemainingRobux = Roact.createElement(FitTextLabel, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = text,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					}),
					RemainingBalanceAfter = Roact.createElement(FitTextLabel, {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = text3,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end
		})
	end)
end

function extended:renderNewAlert()
	return withLocalization({
		InsufficientFundsTitle = "IAPExperience.RobuxUpsell.Title.InsufficientFunds",
		BuyRobuxQuestion = self.props.isLuobu and "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestionWithWarning" or "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestion",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTerms = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTerms" or "IAPExperience.RobuxUpsell.Text.DisclosureTerms",
		RemainingBalance = "IAPExperience.RobuxUpsell.Text.RemainingBalance",
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobux",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		BonusBannerV1 = "IAPExperience.RobuxUpsell.Text.BonusBannerV1",
		BonusBannerInfo = "IAPExperience.RobuxUpsell.Text.BonusBannerInfo"
	})(function(data)
		return withStyle(function(p)
			local theme = p.Theme
			local font = p.Font

			local text = data.BuyRobuxQuestion .. " " .. utf8.char(57346) .. tostring(self.props.robuxPurchaseAmount)
			local v

			if self.props.robuxPurchaseAmountBeforeBonus == nil then
				v = ""
			else
				local v2 = (utf8.char(57346) .. "<s>" .. tostring(self.props.robuxPurchaseAmountBeforeBonus) .. "</s>") .. " " .. utf8.char(57346) .. tostring(self.props.robuxPurchaseAmount)
				text = data.BuyRobuxQuestion .. " " .. v2

				local v3 = self.props.robuxPurchaseAmount - self.props.robuxPurchaseAmountBeforeBonus
				local v4 = utf8.char(57346) .. tostring(v3)
				v = data.BonusBannerV1:gsub("{robux}", v4)
			end

			return Roact.createElement(InteractiveAlert, {
				screenSize = self.props.screenSize,
				position = self.props.position,
				anchorPoint = self.props.anchorPoint,
				title = data.NeedMoreRobux,
				middleContent = function()
					return Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 15),
						[Roact.Ref] = self.contentRef,
						[Roact.Change.AbsoluteSize] = self.changeContentSize
					}, {
						ItemDetails = Roact.createElement(ProductDetails, {
							layoutOrder = 1,
							model = self.props.model,
							itemIcon = self.props.itemIcon,
							itemName = self.props.itemName,
							itemRobuxCost = self.props.itemRobuxCost
						}),
						Underline = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							BackgroundColor3 = theme.Divider.Color,
							BackgroundTransparency = theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						ConfirmationFrame = Roact.createElement(FitFrameVertical, {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							WouldYouLikeText = Roact.createElement(FitTextLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								width = FitTextLabel.Width.FitToText,
								TextWrapped = true,
								maximumWidth = self.state.contentSize.X * 0.8,
								RichText = true,
								Font = font.Body.Font,
								Text = text,
								TextSize = font.BaseSize * font.Body.RelativeSize,
								TextColor3 = theme.TextDefault.Color
							})
						}),
						DisclosureFrame = Roact.createElement(FitFrameVertical, {
							LayoutOrder = 4,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							DisclosurePayment = Roact.createElement(FitTextLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								width = FitTextLabel.Width.FitToText,
								Font = font.Footer.Font,
								Text = data.DisclosurePayment,
								TextSize = font.BaseSize * font.Footer.RelativeSize,
								TextColor3 = theme.TextDefault.Color,
								TextWrapped = true
							}),
							DisclosureTerms = Roact.createElement(FitTextLabel, {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								width = FitTextLabel.Width.FitToText,
								Font = font.Footer.Font,
								Text = data.DisclosureTerms,
								TextSize = font.BaseSize * font.Footer.RelativeSize,
								TextColor3 = theme.TextDefault.Color
							})
						})
					})
				end,
				buttonStackInfo = {
					buttons = {
						{
							props = {
								isDisabled = self.props.isDisabled,
								onActivated = self.props.cancelPurchaseActivated,
								text = data.ButtonCancel,
								inputIcon = self.props.cancelControllerIcon
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								isLoading = self.props.isLoading,
								isDisabled = self.props.isDisabled,
								isDelayedInput = self.props.isDelayedInput,
								enableInputDelayed = self.props.enableInputDelayed,
								delayInputSeconds = 3,
								onActivated = self.props.buyItemActivated,
								text = data.BuyRobuxButton,
								inputIcon = self.props.buyItemControllerIcon
							}
						}
					}
				},
				footerContent = function()
					return self:renderFooterExperiment(p, v, data.BonusBannerInfo)
				end
			})
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
	local v = {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = { top = 0, bottom = -24, left = -24, right = -24 },
		[Roact.Ref] = self.footerRef,
		[Roact.Change.AbsoluteSize] = self.changeFooterSize
	}

	local createElement2 = Roact.createElement
	local v2 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
		ImageColor3 = Color3.fromRGB(239, 215, 140),
		Size = UDim2.new(1, 0, 0, 40),
		AutomaticSize = Enum.AutomaticSize.Y,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 0, 24, 16)
	}

	local createElement3 = Roact.createElement
	local v3 = {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		margin = { top = 12, bottom = 0, left = 0, right = 0 },
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}

	local createElement4 = Roact.createElement
	local v4 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		RichText = true,
		Font = 0,
		FontFace = 0,
		Text = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextWrap = true
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Footer.Font
	end

	v4.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(p.Tokens.Typography.CaptionSmall.Font)
	end

	v4.FontFace = fontFace

	v4.Text = text
	v4.TextSize = font.BaseSize * font.Footer.RelativeSize
	v4.TextColor3 = flint
	local v5 = {
		BonusBefore = createElement4("TextLabel", v4),
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
	return createElement(FitFrameVertical, v, {
		Banner = createElement2("ImageLabel", v2, {
			BannerContent = createElement3(FitFrameVertical, v3, v5)
		})
	})
end

return extended
