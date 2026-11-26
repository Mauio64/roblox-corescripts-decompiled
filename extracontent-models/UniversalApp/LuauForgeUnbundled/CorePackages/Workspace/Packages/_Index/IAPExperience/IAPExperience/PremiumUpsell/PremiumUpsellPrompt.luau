local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local fitFrameVertical = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame").FitFrameVertical

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Utility.normalizeFontFace
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local BulletPoint = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PremiumUpsell/BulletPoint")

local extended = Roact.Component:extend("PremiumUpsellPrompt")

function extended:init()
	self.isCondensed = false
	self.contentSize = Vector2.new(0, 0)

	self.state = { padding = UDim.new(0, 24), iconSize = UDim2.new(1, 0, 0, 80) }

	function self.updateContentSizes(p2, contentSize)
		if contentSize.X < 200 or contentSize.Y > 1000 then
			return
		end

		local contentSize2 = self.contentSize
		self.contentSize = contentSize

		if
			contentSize.X == 0 and contentSize.Y == 0
			or p2.X == 0 and p2.Y == 0
			or contentSize == contentSize2 and p2 == self.props.screenSize
		then
			return
		end

		local v5

		if self.isCondensed then
			v5 = p2.Y < contentSize.Y + 120 + 80 - 48 + 24
		else
			v5 = p2.Y < contentSize.Y + 120
		end

		self.isCondensed = v5

		self:setState({
			padding = UDim.new(0, v5 and 12 or 24),
			iconSize = UDim2.new(1, 0, 0, v5 and 48 or 80)
		})
	end
end

function extended.willUpdate(data, p2)
	if data.props.screenSize ~= p2.screenSize then
		data.updateContentSizes(p2.screenSize, data.contentSize)
	end
end

function extended:render()
	local props = self.props

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			titleLocalizedText = {
				key = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription"
			},
			monthlyLocalizedText = {
				key = "IAPExperience.PremiumUpsell.Action.Subscribe"
			},
			descLocalizedText = {
				key = "IAPExperience.PremiumUpsell.Label.PremiumBenefitListDesc"
			},
			bulletPoint1Text = {
				key = "IAPExperience.PremiumUpsell.Label.RobuxPerMonth",
				params = {
					robux = utf8.char(57346) .. tostring(props.robuxAmount)
				}
			},
			bulletPoint2Text = {
				key = "IAPExperience.PremiumUpsell.Label.PremiumOnlyBenefits"
			},
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
			shortDisclosure = {
				key = "IAPExperience.PremiumUpsell.Label.ShortDisclosure"
			},
			priceLocalizedText = {
				key = "IAPExperience.PremiumUpsell.Label.PremiumPrice",
				params = {
					currencySymbol = props.currencySymbol,
					price = tostring(props.robuxPrice)
				}
			},
			headerLocalizedText = {
				key = "IAPExperience.PremiumUpsell.Label.RobloxPremium"
			},
			policyLocalizedText = {
				key = "IAPExperience.PremiumUpsell.Label.PremiumPolicy"
			}
		},
		render = function(p2)
			return self:renderPrompt(p2)
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
					Padding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, 12)
					}),
					Icon = Roact.createElement(imageSetLabel, {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ScaleType = Enum.ScaleType.Fit,
						Image = images["icons/graphic/premium_large"]
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
						Padding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 6)
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
				Padding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 12)
				}),
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
					fitFrameVertical,
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

function extended:renderDisclosure(p3)
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
				Padding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 12)
				}),
				Disclosure = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Left,
					RichText = true,
					TextWrapped = true,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					Text = p3.shortDisclosure,
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.Transparency
				})
			}
		)
	end)
end

function extended:renderLandscapePrompt(p2)
	local props = self.props

	return withStyle(function(p3)
		return Roact.createElement(partialPageModal, {
			title = p2.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.purchasePremiumActivated,
							text = p2.monthlyLocalizedText,
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
				IconAndPremiumInfoContainer = self:renderCondensedPremiumInfo(p2),
				BulletList = self:renderBulletInfo(p2),
				Disclosure = self:renderDisclosure(p2)
			}) })
	end)
end

function extended:renderPortraitPrompt(p2)
	local props = self.props

	return withStyle(function(p3)
		return Roact.createElement(partialPageModal, {
			title = p2.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.purchasePremiumActivated,
							text = p2.monthlyLocalizedText,
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
					IconAndPremiumInfoContainer = self:renderCondensedPremiumInfo(p2),
					BulletList = self:renderBulletInfo(p2),
					Disclosure = self:renderDisclosure(p2)
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

		return Roact.createElement(partialPageModal, {
			title = data.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
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
		}, { Roact.createElement(fitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12),
				margin = { top = 12, bottom = 12 },
				[Roact.Change.AbsoluteSize] = function(p2)
					if
						self.contentSize.X ~= p2.AbsoluteSize.X
						or self.contentSize.Y ~= p2.AbsoluteSize.Y
					then
						self.updateContentSizes(self.props.screenSize, p2.AbsoluteSize)
					end
				end
			}, {
				Icon = Roact.createElement(imageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = self.state.iconSize,
					ScaleType = Enum.ScaleType.Fit,
					Image = images["icons/graphic/premium_large"]
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
					fitFrameVertical,
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

function extended:renderPrompt(p2)
	local props = self.props

	if props.screenSize.Y < 450 then
		return self:renderLandscapePrompt(p2)
	end

	if props.screenSize.X < 450 then
		return self:renderPortraitPrompt(p2)
	end

	return self:renderUpdatedPrompt(p2)
end

return extended
