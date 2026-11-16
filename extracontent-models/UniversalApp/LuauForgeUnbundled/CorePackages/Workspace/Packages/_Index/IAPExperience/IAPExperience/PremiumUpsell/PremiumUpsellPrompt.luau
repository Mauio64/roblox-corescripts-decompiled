local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local fitFrameVertical = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame").FitFrameVertical

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

		local createElement = Roact.createElement
		local v6 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v7 = {
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
			PremiumInfoContainer = 0
		}

		local createElement2 = Roact.createElement
		local v9 = {
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
		local v11 = {
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

		local v12 = if not foundationFontFaceMigration then font.Header2.Font else nil
		v11.Font = v12

		local v13 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
		v11.FontFace = v13

		v11.Text = data.headerLocalizedText
		v11.TextSize = font.BaseSize * font.Header2.RelativeSize
		v11.TextColor3 = theme.TextEmphasis.Color
		v11.TextTransparency = theme.TextDefault.Transparency
		children.PremiumHeader = createElement3("TextLabel", v11)

		local createElement4 = Roact.createElement
		local v15 = {
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

		local v16 = if not foundationFontFaceMigration then font.Body.Font else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v15.FontFace = v17

		v15.Text = data.priceLocalizedText
		v15.TextSize = font.BaseSize
		v15.TextColor3 = theme.TextEmphasis.Color
		v15.TextTransparency = theme.TextDefault.Transparency
		children.CostPerMonth = createElement4("TextLabel", v15)

		local createElement5 = Roact.createElement
		local v19 = {
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

		local v20 = if not foundationFontFaceMigration then font.Body.Font else nil
		v19.Font = v20

		local v21 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v19.FontFace = v21

		v19.Text = data.policyLocalizedText
		v19.TextSize = font.BaseSize
		v19.TextColor3 = theme.TextDefault.Color
		v19.TextTransparency = theme.TextDefault.Transparency
		children.RenewAndCancelText = createElement5("TextLabel", v19)
		v7.PremiumInfoContainer = createElement2("Frame", v9, children)
		return createElement("Frame", v6, v7)
	end)
end

function extended:renderBulletInfo(data)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(self.props.screenSize.X)

		local createElement = Roact.createElement
		local v6 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children = {
			Padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12)
			}),
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			BulletListText = 0,
			BulletList = 0
		}

		local createElement2 = Roact.createElement
		local v8 = {
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
		local v9 = if not foundationFontFaceMigration then font.Body.Font else nil
		v8.Font = v9

		local v10 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v8.FontFace = v10

		v8.Text = data.descLocalizedText
		v8.TextSize = font.BaseSize * font.Body.RelativeSize
		v8.TextColor3 = theme.TextDefault.Color
		v8.TextTransparency = theme.TextDefault.Transparency
		children.BulletListText = createElement2("TextLabel", v8)

		children.BulletList = Roact.createElement(
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
		return createElement("Frame", v6, children)
	end)
end

function extended:renderDisclosure(p3)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local createElement = Roact.createElement
		local v6 = {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v7 = {
			Padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12)
			}),
			Disclosure = 0
		}

		local createElement2 = Roact.createElement
		local v9 = {
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

		local v10 = if not foundationFontFaceMigration then font.Body.Font else nil
		v9.Font = v10

		local v11 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v9.FontFace = v11

		v9.Text = p3.shortDisclosure
		v9.TextSize = font.BaseSize * font.Body.RelativeSize
		v9.TextColor3 = theme.TextDefault.Color
		v9.TextTransparency = theme.TextDefault.Transparency
		v7.Disclosure = createElement2("TextLabel", v9)
		return createElement("Frame", v6, v7)
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

		local createElement = Roact.createElement
		local v6 = {
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
		}

		local createElement2 = Roact.createElement
		local v9 = {
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 12),
			margin = { top = 12, bottom = 12 },
			[Roact.Change.AbsoluteSize] = function(p2)
				if self.contentSize.X ~= p2.AbsoluteSize.X or self.contentSize.Y ~= p2.AbsoluteSize.Y then
					self.updateContentSizes(self.props.screenSize, p2.AbsoluteSize)
				end
			end
		}
		local children = {
			Icon = Roact.createElement(imageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = self.state.iconSize,
				ScaleType = Enum.ScaleType.Fit,
				Image = images["icons/graphic/premium_large"]
			}),
			PremiumInfoContainer = 0,
			BulletListText = 0,
			BulletList = 0,
			Disclosure = 0
		}

		local createElement3 = Roact.createElement
		local v11 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children2 = {
			Padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12)
			}),
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
		local v13 = {
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
		local v14 = if not foundationFontFaceMigration then font.Header2.Font else nil
		v13.Font = v14

		local v15 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
		v13.FontFace = v15

		v13.Text = data.headerLocalizedText
		v13.TextSize = font.BaseSize * font.Header2.RelativeSize
		v13.TextColor3 = theme.TextEmphasis.Color
		v13.TextTransparency = theme.TextDefault.Transparency
		children2.PremiumHeader = createElement4("TextLabel", v13)

		local createElement5 = Roact.createElement
		local v17 = {
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
		local v18 = if not foundationFontFaceMigration then font.Body.Font else nil
		v17.Font = v18

		local v19 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v17.FontFace = v19

		v17.Text = data.priceLocalizedText
		v17.TextSize = font.BaseSize
		v17.TextColor3 = theme.TextEmphasis.Color
		v17.TextTransparency = theme.TextDefault.Transparency
		children2.CostPerMonth = createElement5("TextLabel", v17)

		local createElement6 = Roact.createElement
		local v21 = {
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
		local v22 = if not foundationFontFaceMigration then font.Body.Font else nil
		v21.Font = v22

		local v23 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v21.FontFace = v23

		v21.Text = data.policyLocalizedText
		v21.TextSize = font.BaseSize
		v21.TextColor3 = theme.TextDefault.Color
		v21.TextTransparency = theme.TextDefault.Transparency
		children2.CancelText = createElement6("TextLabel", v21)
		children.PremiumInfoContainer = createElement3("Frame", v11, children2)

		local createElement7 = Roact.createElement
		local v25 = {
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
		local v26 = if not foundationFontFaceMigration then font.Body.Font else nil
		v25.Font = v26

		local v27 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v25.FontFace = v27

		v25.Text = data.descLocalizedText
		v25.TextSize = font.BaseSize * font.Body.RelativeSize
		v25.TextColor3 = theme.TextDefault.Color
		v25.TextTransparency = theme.TextDefault.Transparency
		children.BulletListText = createElement7("TextLabel", v25)

		children.BulletList = Roact.createElement(
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
		)

		children.Disclosure = self:renderDisclosure(data)
		return createElement(partialPageModal, v6, { createElement2(fitFrameVertical, v9, children) })
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
