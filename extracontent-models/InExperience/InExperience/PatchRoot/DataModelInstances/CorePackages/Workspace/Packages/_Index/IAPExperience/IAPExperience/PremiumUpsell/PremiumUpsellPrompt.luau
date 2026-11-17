local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local RoactFitComponents = require(parent3.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical

local UIBlox = require(parent3.UIBlox)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)

local BulletPoint = require(parent.BulletPoint)

local extended = Roact.Component:extend(script.Name)

function extended:init()
	self.isCondensed = false
	self.contentSize = Vector2.new(0, 0)

	self.state = { padding = UDim.new(0, 24), iconSize = UDim2.new(1, 0, 0, 80) }

	function self.updateContentSizes(vector2: Vector2, contentSize: Vector2)
		if contentSize.X < 200 or contentSize.Y > 1000 then
			return
		end

		local contentSize2 = self.contentSize
		self.contentSize = contentSize

		if
			contentSize.X == 0 and contentSize.Y == 0
			or vector2.X == 0 and vector2.Y == 0
			or contentSize == contentSize2 and vector2 == self.props.screenSize
		then
			return
		end

		local isCondensed

		if self.isCondensed then
			isCondensed = vector2.Y < contentSize.Y + 120 + 80 - 48 + 24
		else
			isCondensed = vector2.Y < contentSize.Y + 120
		end

		self.isCondensed = isCondensed

		self:setState({
			padding = UDim.new(0, isCondensed and 12 or 24),
			iconSize = UDim2.new(1, 0, 0, isCondensed and 48 or 80)
		})
	end
end

function extended.willUpdate(data, p)
	if data.props.screenSize ~= p.screenSize then
		data.updateContentSizes(p.screenSize, data.contentSize)
	end
end

function extended:render()
	local props = self.props

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			titleLocalizedText = {
				key = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription"
			},
			monthlyLocalizedText = { key = "IAPExperience.PremiumUpsell.Action.Subscribe" },
			descLocalizedText = { key = "IAPExperience.PremiumUpsell.Label.PremiumBenefitListDesc" },
			bulletPoint1Text = {
				key = "IAPExperience.PremiumUpsell.Label.RobuxPerMonth",
				params = {
					robux = utf8.char(57346) .. tostring(props.robuxAmount)
				}
			},
			bulletPoint2Text = { key = "IAPExperience.PremiumUpsell.Label.PremiumOnlyBenefits" },
			bulletPoint3Text = props.isCatalog and {
				key = "IAPExperience.PremiumUpsell.Label.AvatarShopBenefits"
			} or { key = "IAPExperience.PremiumUpsell.Body.RobuxDiscount" },
			disclosure = {
				key = "IAPExperience.PremiumUpsell.Label.Disclosure",
				params = {
					currencySymbol = props.currencySymbol,
					price = tostring(props.robuxPrice)
				}
			},
			shortDisclosure = { key = "IAPExperience.PremiumUpsell.Label.ShortDisclosure" },
			priceLocalizedText = {
				key = "IAPExperience.PremiumUpsell.Label.PremiumPrice",
				params = {
					currencySymbol = props.currencySymbol,
					price = tostring(props.robuxPrice)
				}
			},
			headerLocalizedText = { key = "IAPExperience.PremiumUpsell.Label.RobloxPremium" },
			policyLocalizedText = { key = "IAPExperience.PremiumUpsell.Label.PremiumPolicy" }
		},
		render = function(p)
			return self:renderPrompt(p)
		end
	})
end

function extended:renderCondensedPremiumInfo(data)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		return Roact.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12)
				}),
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				IconContainer = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 96, 0, 96),
					AutomaticSize = Enum.AutomaticSize.Y,
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0, 0, 0, 0)
				}, {
					Padding = Roact.createElement("UIPadding", { PaddingRight = UDim.new(0, 12) }),
					Icon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ScaleType = Enum.ScaleType.Fit,
						Image = Images["icons/graphic/premium_large"]
					})
				}),
				PremiumInfoContainer = Roact.createElement(
					"Frame",
					{
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -80, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 6) }),
						ListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12)
						}),
						PremiumHeader = Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = true,
							FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
							RichText = true,
							Text = data.headerLocalizedText,
							TextSize = font.BaseSize * font.Header2.RelativeSize,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextDefault.Transparency
						}),
						CostPerMonth = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = true,
							FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
							RichText = true,
							Text = data.priceLocalizedText,
							TextSize = font.BaseSize,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextDefault.Transparency
						}),
						RenewAndCancelText = Roact.createElement("TextLabel", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = true,
							FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
							Text = data.policyLocalizedText,
							TextSize = font.BaseSize,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency
						})
					}
				)
			}
		)
	end)
end

function extended:renderBulletInfo(data)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(self.props.screenSize.X)

		return Roact.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 12) }),
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				}),
				BulletListText = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					Text = data.descLocalizedText,
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.Transparency
				}),
				BulletList = Roact.createElement(
					FitFrameVertical,
					{
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						contentPadding = UDim.new(0, 12)
					},
					{
						BulletText1 = Roact.createElement(BulletPoint, {
							text = data.bulletPoint1Text,
							width = partialPageModalMiddleContentWidth,
							layoutOrder = 1
						}),
						BulletText2 = Roact.createElement(BulletPoint, {
							text = data.bulletPoint2Text,
							width = partialPageModalMiddleContentWidth,
							layoutOrder = 2
						}),
						BulletText3 = Roact.createElement(BulletPoint, {
							text = data.bulletPoint3Text,
							width = partialPageModalMiddleContentWidth,
							layoutOrder = 3
						})
					}
				)
			}
		)
	end)
end

function extended:renderDisclosure(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		return Roact.createElement(
			"Frame",
			{
				LayoutOrder = 5,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 12) }),
				Disclosure = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Left,
					RichText = true,
					TextWrapped = true,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					Text = p.shortDisclosure,
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.Transparency
				})
			}
		)
	end)
end

function extended:renderLandscapePrompt(p)
	local props = self.props

	return withStyle(function(_)
		return Roact.createElement(PartialPageModal, {
			title = p.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.purchasePremiumActivated,
							text = p.monthlyLocalizedText,
							inputIcon = props.acceptControllerIcon
						}
					}
				},
				buttonHeight = 48
			},
			onCloseClicked = props.cancelPurchaseActivated
		}, { Roact.createElement("ScrollingFrame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, props.screenSize.Y / 2),
				BorderSizePixel = 0,
				ZIndex = 2,
				ScrollingEnabled = true,
				ScrollBarThickness = 5,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Selectable = false,
				CanvasSize = UDim2.new(1, 0, 0, (math.min(props.screenSize.Y / 2 + 96 + 12, 450)))
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				IconAndPremiumInfoContainer = self:renderCondensedPremiumInfo(p),
				BulletList = self:renderBulletInfo(p),
				Disclosure = self:renderDisclosure(p)
			}) })
	end)
end

function extended:renderPortraitPrompt(p)
	local props = self.props

	return withStyle(function(_)
		return Roact.createElement(PartialPageModal, {
			title = p.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.purchasePremiumActivated,
							text = p.monthlyLocalizedText,
							inputIcon = props.acceptControllerIcon
						}
					}
				},
				buttonHeight = 48
			},
			onCloseClicked = props.cancelPurchaseActivated
		}, { Roact.createElement(
				"Frame",
				{
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					IconAndPremiumInfoContainer = self:renderCondensedPremiumInfo(p),
					BulletList = self:renderBulletInfo(p),
					Disclosure = self:renderDisclosure(p)
				}
			) })
	end)
end

function extended:renderUpdatedPrompt(data)
	local props = self.props

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font

		local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(self.props.screenSize.X)

		return Roact.createElement(PartialPageModal, {
			title = data.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.purchasePremiumActivated,
							text = data.monthlyLocalizedText,
							inputIcon = props.acceptControllerIcon
						}
					}
				},
				buttonHeight = 48
			},
			onCloseClicked = props.cancelPurchaseActivated
		}, { Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12),
				margin = { top = 12, bottom = 12 },
				[Roact.Change.AbsoluteSize] = function(p)
					if self.contentSize.X ~= p.AbsoluteSize.X or self.contentSize.Y ~= p.AbsoluteSize.Y then
						self.updateContentSizes(self.props.screenSize, p.AbsoluteSize)
					end
				end
			}, {
				Icon = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = self.state.iconSize,
					ScaleType = Enum.ScaleType.Fit,
					Image = Images["icons/graphic/premium_large"]
				}),
				PremiumInfoContainer = Roact.createElement(
					"Frame",
					{
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						Padding = Roact.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, 12)
						}),
						ListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12)
						}),
						PremiumHeader = Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							TextXAlignment = Enum.TextXAlignment.Center,
							FontFace = normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font),
							RichText = true,
							Text = data.headerLocalizedText,
							TextSize = font.BaseSize * font.Header2.RelativeSize,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextDefault.Transparency
						}),
						CostPerMonth = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							TextXAlignment = Enum.TextXAlignment.Center,
							FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
							RichText = true,
							Text = data.priceLocalizedText,
							TextSize = font.BaseSize,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextDefault.Transparency
						}),
						CancelText = Roact.createElement("TextLabel", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							TextXAlignment = Enum.TextXAlignment.Center,
							FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
							Text = data.policyLocalizedText,
							TextSize = font.BaseSize,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency
						})
					}
				),
				BulletListText = Roact.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
					Text = data.descLocalizedText,
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.Transparency
				}),
				BulletList = Roact.createElement(
					FitFrameVertical,
					{
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						contentPadding = UDim.new(0, 12)
					},
					{
						BulletText1 = Roact.createElement(BulletPoint, {
							text = data.bulletPoint1Text,
							width = partialPageModalMiddleContentWidth,
							layoutOrder = 1
						}),
						BulletText2 = Roact.createElement(BulletPoint, {
							text = data.bulletPoint2Text,
							width = partialPageModalMiddleContentWidth,
							layoutOrder = 2
						}),
						BulletText3 = Roact.createElement(BulletPoint, {
							text = data.bulletPoint3Text,
							width = partialPageModalMiddleContentWidth,
							layoutOrder = 3
						})
					}
				),
				Disclosure = self:renderDisclosure(data)
			}) })
	end)
end

function extended:renderPrompt(p)
	local props = self.props

	if props.screenSize.Y < 450 then
		return self:renderLandscapePrompt(p)
	end

	if props.screenSize.X < 450 then
		return self:renderPortraitPrompt(p)
	end

	return self:renderUpdatedPrompt(p)
end

return extended
