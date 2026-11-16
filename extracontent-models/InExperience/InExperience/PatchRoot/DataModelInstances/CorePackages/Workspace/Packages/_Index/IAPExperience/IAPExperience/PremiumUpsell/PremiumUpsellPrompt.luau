local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local RoactFitComponents = require(parent3.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical

local UIBlox = require(parent3.UIBlox)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v2 = {
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
			PremiumInfoContainer = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -80, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children = {
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 6) }),
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			PremiumHeader = 0,
			CostPerMonth = 0,
			RenewAndCancelText = 0
		}

		local createElement3 = Roact.createElement
		local v4 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			RichText = true,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Header2.Font
		end

		v4.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
		end

		v4.FontFace = fontFace

		v4.Text = data.headerLocalizedText
		v4.TextSize = font.BaseSize * font.Header2.RelativeSize
		v4.TextColor3 = theme.TextEmphasis.Color
		v4.TextTransparency = theme.TextDefault.Transparency
		children.PremiumHeader = createElement3("TextLabel", v4)

		local createElement4 = Roact.createElement
		local v5 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			RichText = true,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = font.Body.Font
		end

		v5.Font = font3
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v5.FontFace = fontFace2

		v5.Text = data.priceLocalizedText
		v5.TextSize = font.BaseSize
		v5.TextColor3 = theme.TextEmphasis.Color
		v5.TextTransparency = theme.TextDefault.Transparency
		children.CostPerMonth = createElement4("TextLabel", v5)

		local createElement5 = Roact.createElement
		local v6 = {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font4

		if not FoundationFontFaceMigration then
			font4 = font.Body.Font
		end

		v6.Font = font4
		local fontFace3

		if FoundationFontFaceMigration then
			fontFace3 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v6.FontFace = fontFace3

		v6.Text = data.policyLocalizedText
		v6.TextSize = font.BaseSize
		v6.TextColor3 = theme.TextDefault.Color
		v6.TextTransparency = theme.TextDefault.Transparency
		children.RenewAndCancelText = createElement5("TextLabel", v6)
		v2.PremiumInfoContainer = createElement2("Frame", v3, children)
		return createElement("Frame", v, v2)
	end)
end

function extended:renderBulletInfo(data)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(self.props.screenSize.X)

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children = {
			Padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 12) }),
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			BulletListText = 0,
			BulletList = 0
		}

		local createElement2 = Roact.createElement
		local v2 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Body.Font
		end

		v2.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v2.FontFace = fontFace

		v2.Text = data.descLocalizedText
		v2.TextSize = font.BaseSize * font.Body.RelativeSize
		v2.TextColor3 = theme.TextDefault.Color
		v2.TextTransparency = theme.TextDefault.Transparency
		children.BulletListText = createElement2("TextLabel", v2)

		children.BulletList = Roact.createElement(
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
		return createElement("Frame", v, children)
	end)
end

function extended:renderDisclosure(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v2 = {
			Padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 12) }),
			Disclosure = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Body.Font
		end

		v3.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v3.FontFace = fontFace

		v3.Text = p.shortDisclosure
		v3.TextSize = font.BaseSize * font.Body.RelativeSize
		v3.TextColor3 = theme.TextDefault.Color
		v3.TextTransparency = theme.TextDefault.Transparency
		v2.Disclosure = createElement2("TextLabel", v3)
		return createElement("Frame", v, v2)
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

		local createElement = Roact.createElement
		local v = {
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
		}

		local createElement2 = Roact.createElement
		local v2 = {
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 12),
			margin = { top = 12, bottom = 12 },
			[Roact.Change.AbsoluteSize] = function(p)
				if self.contentSize.X ~= p.AbsoluteSize.X or self.contentSize.Y ~= p.AbsoluteSize.Y then
					self.updateContentSizes(self.props.screenSize, p.AbsoluteSize)
				end
			end
		}
		local children = {
			Icon = Roact.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = self.state.iconSize,
				ScaleType = Enum.ScaleType.Fit,
				Image = Images["icons/graphic/premium_large"]
			}),
			PremiumInfoContainer = 0,
			BulletListText = 0,
			BulletList = 0,
			Disclosure = 0
		}

		local createElement3 = Roact.createElement
		local v3 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children2 = {
			Padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 12) }),
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			PremiumHeader = 0,
			CostPerMonth = 0,
			CancelText = 0
		}

		local createElement4 = Roact.createElement
		local v4 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = 0,
			FontFace = 0,
			RichText = true,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Header2.Font
		end

		v4.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font)
		end

		v4.FontFace = fontFace

		v4.Text = data.headerLocalizedText
		v4.TextSize = font.BaseSize * font.Header2.RelativeSize
		v4.TextColor3 = theme.TextEmphasis.Color
		v4.TextTransparency = theme.TextDefault.Transparency
		children2.PremiumHeader = createElement4("TextLabel", v4)

		local createElement5 = Roact.createElement
		local v5 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = 0,
			FontFace = 0,
			RichText = true,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = font.Body.Font
		end

		v5.Font = font3
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font)
		end

		v5.FontFace = fontFace2

		v5.Text = data.priceLocalizedText
		v5.TextSize = font.BaseSize
		v5.TextColor3 = theme.TextEmphasis.Color
		v5.TextTransparency = theme.TextDefault.Transparency
		children2.CostPerMonth = createElement5("TextLabel", v5)

		local createElement6 = Roact.createElement
		local v6 = {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font4

		if not FoundationFontFaceMigration then
			font4 = font.Body.Font
		end

		v6.Font = font4
		local fontFace3

		if FoundationFontFaceMigration then
			fontFace3 = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font)
		end

		v6.FontFace = fontFace3

		v6.Text = data.policyLocalizedText
		v6.TextSize = font.BaseSize
		v6.TextColor3 = theme.TextDefault.Color
		v6.TextTransparency = theme.TextDefault.Transparency
		children2.CancelText = createElement6("TextLabel", v6)
		children.PremiumInfoContainer = createElement3("Frame", v3, children2)

		local createElement7 = Roact.createElement
		local v7 = {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font5

		if not FoundationFontFaceMigration then
			font5 = font.Body.Font
		end

		v7.Font = font5
		local fontFace4

		if FoundationFontFaceMigration then
			fontFace4 = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font)
		end

		v7.FontFace = fontFace4

		v7.Text = data.descLocalizedText
		v7.TextSize = font.BaseSize * font.Body.RelativeSize
		v7.TextColor3 = theme.TextDefault.Color
		v7.TextTransparency = theme.TextDefault.Transparency
		children.BulletListText = createElement7("TextLabel", v7)

		children.BulletList = Roact.createElement(
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
		)

		children.Disclosure = self:renderDisclosure(data)
		return createElement(PartialPageModal, v, { createElement2(FitFrameVertical, v2, children) })
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
