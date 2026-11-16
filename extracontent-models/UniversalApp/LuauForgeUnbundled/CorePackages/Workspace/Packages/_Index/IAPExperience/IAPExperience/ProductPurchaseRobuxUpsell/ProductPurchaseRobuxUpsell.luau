local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/t")

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").LocalizationProvider
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").withLocalization

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameVertical = FitFrame.FitFrameVertical
local fitTextLabel = FitFrame.FitTextLabel

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle

local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Style").Colors

local FFlagLowCogsBannerInfoIcon = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagLowCogsBannerInfoIcon")
local InfoIconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/InfoIconWithTooltip")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags")

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local ProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/ProductDetails")

local iconscommonrobux = images["icons/common/robux"]

local extended = Roact.Component:extend("ProductPurchaseRobuxUpsell")

local FFlagIntroduceMetricsLegacyUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagIntroduceMetricsLegacyUpsell")
local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local LegacyUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/LegacyUpsellCounter")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")

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

	function self.changeContentSize(p2)
		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end

	function self.changeFooterSize(p2)
		if self.state.footerSize ~= p2.AbsoluteSize then
			self:setState({ footerSize = p2.AbsoluteSize })
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
	local v5 = self.props.isLuobu and "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestionWithWarning"
		or "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestion"

	local v6 = self.props.isVng and "IAPExperience.RobuxUpsell.Text.VNGDisclosureTerms"
		or "IAPExperience.RobuxUpsell.Text.DisclosureTerms"

	if SharedFlags.FFlagLowCogsBannerExperiment then
		return Roact.createElement(
			localizationProvider,
			{
				localization = localization.new(LocalizationService.RobloxLocaleId)
			},
			{ Alert = self:renderNewAlert() }
		)
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientFundsTitle = {
				key = "IAPExperience.RobuxUpsell.Title.InsufficientFunds"
			},
			BuyRobuxQuestion = { key = v5 },
			DisclosurePayment = {
				key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment"
			},
			DisclosureTerms = { key = v6 },
			RemainingBalance = {
				key = "IAPExperience.RobuxUpsell.Text.RemainingBalance"
			},
			BuyRobuxButton = { key = "IAPExperience.RobuxUpsell.Action.BuyRobux" },
			ButtonCancel = { key = "IAPExperience.RobuxUpsell.Action.Cancel" },
			LoadingText = { key = "IAPExperience.RobuxUpsell.Text.Loading" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(data2)
	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local balanceAmount = self.props.balanceAmount or 0
		local robuxPurchaseAmount = self.props.robuxPurchaseAmount or 0
		local itemRobuxCost = self.props.itemRobuxCost or 0

		local v5 = balanceAmount + robuxPurchaseAmount - itemRobuxCost

		return Roact.createElement(interactiveAlert, {
			screenSize = self.props.screenSize,
			position = self.props.position,
			anchorPoint = self.props.anchorPoint,
			title = data2.InsufficientFundsTitle,
			middleContent = function()
				return Roact.createElement(fitFrameVertical, {
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
					ConfirmationFrame = Roact.createElement(fitFrameVertical, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}, {
						WouldYouLikeText = Roact.createElement(fitTextLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							width = fitTextLabel.Width.FitToText,
							TextWrapped = true,
							maximumWidth = self.state.contentSize.X * 0.8,
							Font = font.Body.Font,
							Text = data2.BuyRobuxQuestion,
							TextSize = font.BaseSize * font.Body.RelativeSize,
							TextColor3 = theme.TextDefault.Color
						}),
						RobuxIcon = Roact.createElement(imageSetLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0, 5),
							Size = UDim2.new(0, 24, 0, 24),
							ScaleType = Enum.ScaleType.Stretch,
							Image = iconscommonrobux,
							ImageColor3 = theme.IconEmphasis.Color,
							ImageTransparency = theme.IconEmphasis.Transparency
						}),
						RemainingRobux = Roact.createElement(fitTextLabel, {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							width = fitTextLabel.Width.FitToText,
							Font = font.Body.Font,
							Text = tostring(self.props.robuxPurchaseAmount),
							TextSize = font.BaseSize * font.Body.RelativeSize,
							TextColor3 = theme.TextEmphasis.Color
						})
					}),
					DisclosureFrame = Roact.createElement(fitFrameVertical, {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 1)
					}, {
						DisclosurePayment = Roact.createElement(fitTextLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							width = fitTextLabel.Width.FitToText,
							Font = font.Footer.Font,
							Text = data2.DisclosurePayment,
							TextSize = font.BaseSize * font.Footer.RelativeSize,
							TextColor3 = theme.TextDefault.Color,
							TextWrapped = true
						}),
						DisclosureTerms = Roact.createElement(fitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = fitTextLabel.Width.FitToText,
							Font = font.Footer.Font,
							Text = data2.DisclosureTerms,
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
							text = data2.ButtonCancel,
							inputIcon = self.props.cancelControllerIcon
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							isLoading = self.props.isLoading,
							isDisabled = self.props.isDisabled,
							isDelayedInput = self.props.isDelayedInput,
							enableInputDelayed = self.props.enableInputDelayed,
							delayInputSeconds = 3,
							onActivated = self.props.buyItemActivated,
							text = data2.BuyRobuxButton,
							inputIcon = self.props.buyItemControllerIcon
						}
					}
				}
			},
			footerContent = function()
				local v6 = string.split(data2.RemainingBalance, " {robux} ")
				local v7 = v6[1]
				local v8 = v6[2]
				return Roact.createElement(fitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 1),
					[Roact.Ref] = self.footerRef,
					[Roact.Change.AbsoluteSize] = self.changeFooterSize
				}, {
					RemainingBalanceBefore = Roact.createElement(fitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						width = fitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = v7,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					}),
					RobuxIcon = Roact.createElement(imageSetLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
						ScaleType = Enum.ScaleType.Stretch,
						Image = iconscommonrobux,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = theme.IconEmphasis.Transparency
					}),
					RemainingRobux = Roact.createElement(fitTextLabel, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						width = fitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = v5,
						TextSize = font.BaseSize * font.Footer.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					}),
					RemainingBalanceAfter = Roact.createElement(fitTextLabel, {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						width = fitTextLabel.Width.FitToText,
						Font = font.Footer.Font,
						Text = v8,
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
		return withStyle(function(p2)
			local theme = p2.Theme
			local font = p2.Font

			local v7 = data.BuyRobuxQuestion .. " " .. utf8.char(57346) .. tostring(self.props.robuxPurchaseAmount)
			local v8

			if self.props.robuxPurchaseAmountBeforeBonus == nil then
				v8 = ""
			else
				local v9 = (utf8.char(57346) .. "<s>" .. tostring(self.props.robuxPurchaseAmountBeforeBonus) .. "</s>") .. " " .. utf8.char(57346) .. tostring(self.props.robuxPurchaseAmount)
				v7 = data.BuyRobuxQuestion .. " " .. v9

				local v10 = self.props.robuxPurchaseAmount - self.props.robuxPurchaseAmountBeforeBonus
				local v11 = utf8.char(57346) .. tostring(v10)
				v8 = data.BonusBannerV1:gsub("{robux}", v11)
			end

			return Roact.createElement(interactiveAlert, {
				screenSize = self.props.screenSize,
				position = self.props.position,
				anchorPoint = self.props.anchorPoint,
				title = data.NeedMoreRobux,
				middleContent = function()
					return Roact.createElement(fitFrameVertical, {
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
						ConfirmationFrame = Roact.createElement(fitFrameVertical, {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							WouldYouLikeText = Roact.createElement(fitTextLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								width = fitTextLabel.Width.FitToText,
								TextWrapped = true,
								maximumWidth = self.state.contentSize.X * 0.8,
								RichText = true,
								Font = font.Body.Font,
								Text = v7,
								TextSize = font.BaseSize * font.Body.RelativeSize,
								TextColor3 = theme.TextDefault.Color
							})
						}),
						DisclosureFrame = Roact.createElement(fitFrameVertical, {
							LayoutOrder = 4,
							BackgroundTransparency = 1,
							width = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							contentPadding = UDim.new(0, 1)
						}, {
							DisclosurePayment = Roact.createElement(fitTextLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								width = fitTextLabel.Width.FitToText,
								Font = font.Footer.Font,
								Text = data.DisclosurePayment,
								TextSize = font.BaseSize * font.Footer.RelativeSize,
								TextColor3 = theme.TextDefault.Color,
								TextWrapped = true
							}),
							DisclosureTerms = Roact.createElement(fitTextLabel, {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								width = fitTextLabel.Width.FitToText,
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
							buttonType = buttonType.PrimarySystem,
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
					return self:renderFooterExperiment(p2, v8, data.BonusBannerInfo)
				end
			})
		end)
	end)
end

function extended:renderFooterExperiment(p2, text, p3)
	local font = p2.Font
	local flint = colors.Flint

	if text == "" then
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
		AutomaticSize = Enum.AutomaticSize.Y,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 0, 24, 16)
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

	local createElement4 = Roact.createElement
	local v15 = {
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

	local v16 = if not foundationFontFaceMigration then font.Footer.Font else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(p2.Tokens.Typography.CaptionSmall.Font) else nil
	v15.FontFace = v17

	v15.Text = text
	v15.TextSize = font.BaseSize * font.Footer.RelativeSize
	v15.TextColor3 = flint
	local v13 = {
		BonusBefore = createElement4("TextLabel", v15),
		InfoIcon = 0
	}

	local v18 = if FFlagLowCogsBannerInfoIcon then InfoIconWithTooltip({
		text = p3,
		layoutOrder = 2,
		color = flint,
		eventActivated = self.bonusBannerInfoIconStateChange
	}) else nil
	v13.InfoIcon = v18
	return createElement(fitFrameVertical, v6, {
		Banner = createElement2("ImageLabel", v9, {
			BannerContent = createElement3(fitFrameVertical, v12, v13)
		})
	})
end

return extended
