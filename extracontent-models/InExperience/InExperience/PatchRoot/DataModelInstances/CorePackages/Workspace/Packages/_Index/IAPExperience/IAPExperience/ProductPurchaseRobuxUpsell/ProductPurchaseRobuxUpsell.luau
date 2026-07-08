local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local t = require(scriptParentParentParent.t)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(scriptParentParentParent.AppLocales).Localization
local LocalizationProvider = require(scriptParentParentParent.Localization).LocalizationProvider
local withLocalization = require(scriptParentParentParent.Localization).withLocalization
local RoactFitComponents = require(scriptParentParentParent.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local UIBlox = require(scriptParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle
local Colors = require(scriptParentParentParent.Style).Colors
local FFlagLowCogsBannerInfoIcon = require(scriptParentParent.Flags.FFlagLowCogsBannerInfoIcon)
local InfoIconWithTooltip = require(scriptParentParent.Generic.InfoIconWithTooltip)
local SharedFlags = require(scriptParentParentParent.SharedFlags)
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local ProductDetails = require(scriptParent.ProductDetails)
local v26 = Images["icons/common/robux"]
local v27 = Roact.Component:extend(script.Name)
local getEnableFixRobuxUpsellPriceCrash = require(scriptParentParent.Flags.getEnableFixRobuxUpsellPriceCrash)
local FFlagIntroduceMetricsLegacyUpsell = require(scriptParentParent.Flags.FFlagIntroduceMetricsLegacyUpsell)
local default = require(scriptParentParentParent.LoggingProtocol).default
local LegacyUpsellCounter = require(scriptParentParent.Generic.Events.LegacyUpsellCounter)
local logger = require(scriptParentParent.Utility.logger)

v27.validateProps = t.strictInterface({
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
v27.defaultProps = {
	isLoading = false,
	isDisabled = false,
	isDelayedInput = false,
	enableInputDelayed = false,
	isLuobu = false,
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v27.init(p1) -- line: 91
	-- upvalues: Roact (copy)
	p1.contentRef = Roact.createRef()
	p1.footerRef = Roact.createRef()
	p1.state = {
		contentSize = Vector2.new(0, 0),
		footerSize = Vector2.new(0, 0)
	}

	function p1.changeContentSize(p2) -- line: 99
		-- upvalues: p1 (copy)
		if p1.state.contentSize ~= p2.AbsoluteSize then
			p1:setState({
				contentSize = p2.AbsoluteSize
			})
		end
	end
	function p1.changeFooterSize(p3) -- line: 107
		-- upvalues: p1 (copy)
		if p1.state.footerSize ~= p3.AbsoluteSize then
			p1:setState({
				footerSize = p3.AbsoluteSize
			})
		end
	end
end
function v27.didMount(_) -- line: 116
	-- upvalues: FFlagIntroduceMetricsLegacyUpsell (copy), logger (copy), default (copy), LegacyUpsellCounter (copy)
	if FFlagIntroduceMetricsLegacyUpsell then
		logger.debug({
			message = "Legacy Upsell Modal Shown"
		})
		default:logRobloxTelemetryCounter(LegacyUpsellCounter.LegacyUpsellShownCounter, 1, {})
	end
end
function v27.render(p5) -- line: 125
	-- upvalues: SharedFlags (copy), Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), MultiTextLocalizer (copy)
	local v36 = not p5.props.isLuobu and "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestion" or "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestionWithWarning"
	local v37 = not p5.props.isVng and "IAPExperience.RobuxUpsell.Text.DisclosureTerms" or "IAPExperience.RobuxUpsell.Text.VNGDisclosureTerms"

	if SharedFlags.FFlagLowCogsBannerExperiment then
		return Roact.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			Alert = p5:renderNewAlert()
		})
	end

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientFundsTitle = {
				key = "IAPExperience.RobuxUpsell.Title.InsufficientFunds"
			},
			BuyRobuxQuestion = {
				key = v36
			},
			DisclosurePayment = {
				key = "IAPExperience.RobuxUpsell.Text.DisclosurePayment"
			},
			DisclosureTerms = {
				key = v37
			},
			RemainingBalance = {
				key = "IAPExperience.RobuxUpsell.Text.RemainingBalance"
			},
			BuyRobuxButton = {
				key = "IAPExperience.RobuxUpsell.Action.BuyRobux"
			},
			ButtonCancel = {
				key = "IAPExperience.RobuxUpsell.Action.Cancel"
			},
			LoadingText = {
				key = "IAPExperience.RobuxUpsell.Text.Loading"
			}
		},
		render = function(p6) -- line: 170
			-- upvalues: p5 (copy)
			return p5:renderAlert(p6)
		end
	})
end
function v27.renderAlert(p7, p8) -- line: 176
	-- upvalues: withStyle (copy), getEnableFixRobuxUpsellPriceCrash (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ProductDetails (copy), FitTextLabel (copy), ImageSetLabel (copy), v26 (copy), ButtonType (copy), IconSize (copy)
	return withStyle(function(p9) -- line: 177
		-- upvalues: getEnableFixRobuxUpsellPriceCrash (copy), p7 (copy), Roact (copy), InteractiveAlert (copy), p8 (copy), FitFrameVertical (copy), ProductDetails (copy), FitTextLabel (copy), ImageSetLabel (copy), v26 (copy), ButtonType (copy), IconSize (copy)
		local Theme = p9.Theme
		local p9Font = p9.Font
		local u58

		if getEnableFixRobuxUpsellPriceCrash() then
			local v55 = p7.props.balanceAmount or 0
			local v56 = p7.props.robuxPurchaseAmount or 0
			local v57 = p7.props.itemRobuxCost or 0

			u58 = v55 + v56 - v57
		else
			u58 = p7.props.balanceAmount + p7.props.robuxPurchaseAmount - p7.props.itemRobuxCost
		end

		return Roact.createElement(InteractiveAlert, {
			screenSize = p7.props.screenSize,
			position = p7.props.position,
			anchorPoint = p7.props.anchorPoint,
			title = p8.InsufficientFundsTitle,
			middleContent = function() -- line: 198
				-- upvalues: Roact (copy), FitFrameVertical (copy), p7 (copy), ProductDetails (copy), Theme (copy), FitTextLabel (copy), p9Font (copy), p8 (copy), ImageSetLabel (copy), v26 (copy)
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 15),
					[Roact.Ref] = p7.contentRef,
					[Roact.Change.AbsoluteSize] = p7.changeContentSize
				}, {
					ItemDetails = Roact.createElement(ProductDetails, {
						layoutOrder = 1,
						model = p7.props.model,
						itemIcon = p7.props.itemIcon,
						itemName = p7.props.itemName,
						itemRobuxCost = p7.props.itemRobuxCost
					}),
					Underline = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency,
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
							TextWrapped = true,
							width = FitTextLabel.Width.FitToText,
							maximumWidth = p7.state.contentSize.X * 0.8,
							Font = p9Font.Body.Font,
							Text = p8.BuyRobuxQuestion,
							TextSize = p9Font.BaseSize * p9Font.Body.RelativeSize,
							TextColor3 = Theme.TextDefault.Color
						}),
						RobuxIcon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0, 5),
							Size = UDim2.new(0, 24, 0, 24),
							ScaleType = Enum.ScaleType.Stretch,
							Image = v26,
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = Theme.IconEmphasis.Transparency
						}),
						RemainingRobux = Roact.createElement(FitTextLabel, {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							Font = p9Font.Body.Font,
							Text = tostring(p7.props.robuxPurchaseAmount),
							TextSize = p9Font.BaseSize * p9Font.Body.RelativeSize,
							TextColor3 = Theme.TextEmphasis.Color
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
							TextWrapped = true,
							width = FitTextLabel.Width.FitToText,
							Font = p9Font.Footer.Font,
							Text = p8.DisclosurePayment,
							TextSize = p9Font.BaseSize * p9Font.Footer.RelativeSize,
							TextColor3 = Theme.TextDefault.Color
						}),
						DisclosureTerms = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							Font = p9Font.Footer.Font,
							Text = p8.DisclosureTerms,
							TextSize = p9Font.BaseSize * p9Font.Footer.RelativeSize,
							TextColor3 = Theme.TextDefault.Color
						})
					})
				})
			end,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							isDisabled = p7.props.isDisabled,
							onActivated = p7.props.cancelPurchaseActivated,
							text = p8.ButtonCancel,
							inputIcon = p7.props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							delayInputSeconds = 3,
							isLoading = p7.props.isLoading,
							isDisabled = p7.props.isDisabled,
							isDelayedInput = p7.props.isDelayedInput,
							enableInputDelayed = p7.props.enableInputDelayed,
							onActivated = p7.props.buyItemActivated,
							text = p8.BuyRobuxButton,
							inputIcon = p7.props.buyItemControllerIcon
						}
					}
				}
			},
			footerContent = function() -- line: 329
				-- upvalues: p8 (copy), Roact (copy), FitFrameVertical (copy), p7 (copy), FitTextLabel (copy), p9Font (copy), Theme (copy), ImageSetLabel (copy), IconSize (copy), v26 (copy), u58 (ref)
				local parts = string.split(p8.RemainingBalance, " {robux} ")
				local v61 = parts[1]
				local v62 = parts[2]

				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 1),
					[Roact.Ref] = p7.footerRef,
					[Roact.Change.AbsoluteSize] = p7.changeFooterSize
				}, {
					RemainingBalanceBefore = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = p9Font.Footer.Font,
						Text = v61,
						TextSize = p9Font.BaseSize * p9Font.Footer.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					}),
					RobuxIcon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
						ScaleType = Enum.ScaleType.Stretch,
						Image = v26,
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency
					}),
					RemainingRobux = Roact.createElement(FitTextLabel, {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = p9Font.Footer.Font,
						Text = u58,
						TextSize = p9Font.BaseSize * p9Font.Footer.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					}),
					RemainingBalanceAfter = Roact.createElement(FitTextLabel, {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = p9Font.Footer.Font,
						Text = v62,
						TextSize = p9Font.BaseSize * p9Font.Footer.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					})
				})
			end
		})
	end)
end
function v27.renderNewAlert(p10) -- line: 401
	-- upvalues: withLocalization (copy), withStyle (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ProductDetails (copy), FitTextLabel (copy), ButtonType (copy)
	local v41 = not p10.props.isLuobu and "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestion" or "IAPExperience.RobuxUpsell.Text.BuyRobuxQuestionWithWarning"
	local v42 = not p10.props.isVng and "IAPExperience.RobuxUpsell.Text.DisclosureTerms" or "IAPExperience.RobuxUpsell.Text.VNGDisclosureTerms"

	return withLocalization({
		InsufficientFundsTitle = "IAPExperience.RobuxUpsell.Title.InsufficientFunds",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		RemainingBalance = "IAPExperience.RobuxUpsell.Text.RemainingBalance",
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobux",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading",
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		BonusBannerV1 = "IAPExperience.RobuxUpsell.Text.BonusBannerV1",
		BonusBannerInfo = "IAPExperience.RobuxUpsell.Text.BonusBannerInfo",
		BuyRobuxQuestion = v41,
		DisclosureTerms = v42
	})(function(t1: {[any]: any}) -- line: 419
		-- upvalues: withStyle (copy), p10 (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ProductDetails (copy), FitTextLabel (copy), ButtonType (copy)
		return withStyle(function(p11) -- line: 420
			-- upvalues: t1 (copy), p10 (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ProductDetails (copy), FitTextLabel (copy), ButtonType (copy)
			local Theme = p11.Theme
			local p11Font = p11.Font
			local u66 = t1.BuyRobuxQuestion .. " " .. utf8.char(57346) .. tostring(p10.props.robuxPurchaseAmount)
			local s1 = ""

			if p10.props.robuxPurchaseAmountBeforeBonus ~= nil then
				local v68 = (utf8.char(57346) .. "<s>" .. tostring(p10.props.robuxPurchaseAmountBeforeBonus) .. "</s>") .. " " .. utf8.char(57346) .. tostring(p10.props.robuxPurchaseAmount)

				u66 = t1.BuyRobuxQuestion .. " " .. v68

				local v69 = p10.props.robuxPurchaseAmount - p10.props.robuxPurchaseAmountBeforeBonus
				local v70 = utf8.char(57346) .. tostring(v69)

				s1 = t1.BonusBannerV1:gsub("{robux}", v70)
			end

			return Roact.createElement(InteractiveAlert, {
				screenSize = p10.props.screenSize,
				position = p10.props.position,
				anchorPoint = p10.props.anchorPoint,
				title = t1.NeedMoreRobux,
				middleContent = function() -- line: 450
					-- upvalues: Roact (copy), FitFrameVertical (copy), p10 (copy), ProductDetails (copy), Theme (copy), FitTextLabel (copy), p11Font (copy), u66 (ref), t1 (copy)
					return Roact.createElement(FitFrameVertical, {
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						contentPadding = UDim.new(0, 15),
						[Roact.Ref] = p10.contentRef,
						[Roact.Change.AbsoluteSize] = p10.changeContentSize
					}, {
						ItemDetails = Roact.createElement(ProductDetails, {
							layoutOrder = 1,
							model = p10.props.model,
							itemIcon = p10.props.itemIcon,
							itemName = p10.props.itemName,
							itemRobuxCost = p10.props.itemRobuxCost
						}),
						Underline = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
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
								TextWrapped = true,
								RichText = true,
								width = FitTextLabel.Width.FitToText,
								maximumWidth = p10.state.contentSize.X * 0.8,
								Font = p11Font.Body.Font,
								Text = u66,
								TextSize = p11Font.BaseSize * p11Font.Body.RelativeSize,
								TextColor3 = Theme.TextDefault.Color
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
								TextWrapped = true,
								width = FitTextLabel.Width.FitToText,
								Font = p11Font.Footer.Font,
								Text = t1.DisclosurePayment,
								TextSize = p11Font.BaseSize * p11Font.Footer.RelativeSize,
								TextColor3 = Theme.TextDefault.Color
							}),
							DisclosureTerms = Roact.createElement(FitTextLabel, {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								width = FitTextLabel.Width.FitToText,
								Font = p11Font.Footer.Font,
								Text = t1.DisclosureTerms,
								TextSize = p11Font.BaseSize * p11Font.Footer.RelativeSize,
								TextColor3 = Theme.TextDefault.Color
							})
						})
					})
				end,
				buttonStackInfo = {
					buttons = {
						{
							props = {
								isDisabled = p10.props.isDisabled,
								onActivated = p10.props.cancelPurchaseActivated,
								text = t1.ButtonCancel,
								inputIcon = p10.props.cancelControllerIcon
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								delayInputSeconds = 3,
								isLoading = p10.props.isLoading,
								isDisabled = p10.props.isDisabled,
								isDelayedInput = p10.props.isDelayedInput,
								enableInputDelayed = p10.props.enableInputDelayed,
								onActivated = p10.props.buyItemActivated,
								text = t1.BuyRobuxButton,
								inputIcon = p10.props.buyItemControllerIcon
							}
						}
					}
				},
				footerContent = function() -- line: 560
					-- upvalues: p10 (copy), p11 (copy), s1 (ref), t1 (copy)
					return p10:renderFooterExperiment(p11, s1, t1.BonusBannerInfo)
				end
			})
		end)
	end)
end
function v27.renderFooterExperiment(p12, p13, p14, p15) -- line: 568
	-- upvalues: Colors (copy), Roact (copy), FitFrameVertical (copy), FFlagLowCogsBannerInfoIcon (copy), InfoIconWithTooltip (copy)
	local p13Font = p13.Font
	local Flint = Colors.Flint

	if p14 == "" then
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
		[Roact.Ref] = p12.footerRef,
		[Roact.Change.AbsoluteSize] = p12.changeFooterSize
	}, {
		Banner = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
			ImageColor3 = Color3.fromRGB(239, 215, 140),
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.Y,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 0, 24, 16)
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
					TextWrap = true,
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = p13Font.Footer.Font,
					Text = p14,
					TextSize = p13Font.BaseSize * p13Font.Footer.RelativeSize,
					TextColor3 = Flint
				}),
				InfoIcon = if not FFlagLowCogsBannerInfoIcon then nil else InfoIconWithTooltip({
					layoutOrder = 2,
					text = p15,
					color = Flint,
					eventActivated = p12.bonusBannerInfoIconStateChange
				})
			})
		})
	})
end

return v27
