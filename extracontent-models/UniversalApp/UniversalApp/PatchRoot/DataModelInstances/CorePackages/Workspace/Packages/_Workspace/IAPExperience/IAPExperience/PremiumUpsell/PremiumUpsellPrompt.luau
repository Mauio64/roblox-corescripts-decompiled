local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local FitFrameVertical = require(scriptParentParentParent.RoactFitComponents).FitFrameVertical
local UIBlox = require(scriptParentParentParent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local BulletPoint = require(scriptParent.BulletPoint)
local v15 = Roact.Component:extend(script.Name)

function v15.init(p1) -- line: 47
	p1.isCondensed = false
	p1.contentSize = Vector2.new(0, 0)
	p1.state = {
		padding = UDim.new(0, 24),
		iconSize = UDim2.new(1, 0, 0, 80)
	}

	function p1.updateContentSizes(vector2: Vector2, vector2_2: Vector2) -- line: 56
		-- upvalues: p1 (copy)
		if vector2_2.X < 200 or vector2_2.Y > 1000 then
			return
		end

		local contentSize = p1.contentSize

		p1.contentSize = vector2_2

		if vector2_2.X == 0 and vector2_2.Y == 0 then
			return
		end

		if vector2.X == 0 and vector2.Y == 0 then
			return
		end

		if vector2_2 == contentSize and vector2 == p1.props.screenSize then
			return
		end

		local v42 = if not p1.isCondensed then vector2.Y < vector2_2.Y + 120 else vector2.Y < vector2_2.Y + 120 + 80 - 48 + 24

		p1.isCondensed = v42
		p1:setState({
			padding = UDim.new(0, not v42 and 24 or 12),
			iconSize = UDim2.new(1, 0, 0, not v42 and 80 or 48)
		})
	end
end
function v15.willUpdate(p2, p3) -- line: 98
	if p2.props.screenSize ~= p3.screenSize then
		p2.updateContentSizes(p3.screenSize, p2.contentSize)
	end
end
function v15.render(p4) -- line: 104
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	local props = p4.props

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
			bulletPoint3Text = if not props.isCatalog then {
				key = "IAPExperience.PremiumUpsell.Body.RobuxDiscount"
			} else {
				key = "IAPExperience.PremiumUpsell.Label.AvatarShopBenefits"
			},
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
		render = function(p5) -- line: 158
			-- upvalues: p4 (copy)
			return p4:renderPrompt(p5)
		end
	})
end
function v15.renderCondensedPremiumInfo(_: {[any]: any}, t2: {[any]: any}) -- line: 164
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), Images (copy)
	return withStyle(function(p6) -- line: 165
		-- upvalues: Roact (copy), ImageSetLabel (copy), Images (copy), t2 (copy)
		local Theme = p6.Theme
		local p6Font = p6.Font

		return Roact.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
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
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					ScaleType = Enum.ScaleType.Fit,
					Image = Images["icons/graphic/premium_large"]
				})
			}),
			PremiumInfoContainer = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -80, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
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
					TextWrapped = true,
					RichText = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = p6Font.Header2.Font,
					Text = t2.headerLocalizedText,
					TextSize = p6Font.BaseSize * p6Font.Header2.RelativeSize,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency
				}),
				CostPerMonth = Roact.createElement("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					TextWrapped = true,
					RichText = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = p6Font.Body.Font,
					Text = t2.priceLocalizedText,
					TextSize = p6Font.BaseSize,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency
				}),
				RenewAndCancelText = Roact.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = p6Font.Body.Font,
					Text = t2.policyLocalizedText,
					TextSize = p6Font.BaseSize,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				})
			})
		})
	end)
end
function v15.renderBulletInfo(t3: {[any]: any}, t4: {[any]: any}) -- line: 261
	-- upvalues: withStyle (copy), getPartialPageModalMiddleContentWidth (copy), Roact (copy), FitFrameVertical (copy), BulletPoint (copy)
	return withStyle(function(p7) -- line: 262
		-- upvalues: getPartialPageModalMiddleContentWidth (copy), t3 (copy), Roact (copy), t4 (copy), FitFrameVertical (copy), BulletPoint (copy)
		local Theme = p7.Theme
		local p7Font = p7.Font
		local v50 = getPartialPageModalMiddleContentWidth(t3.props.screenSize.X)

		return Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
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
				Size = UDim2.new(0, v50, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = p7Font.Body.Font,
				Text = t4.descLocalizedText,
				TextSize = p7Font.BaseSize * p7Font.Body.RelativeSize,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			}),
			BulletList = Roact.createElement(FitFrameVertical, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12)
			}, {
				BulletText1 = Roact.createElement(BulletPoint, {
					layoutOrder = 1,
					text = t4.bulletPoint1Text,
					width = v50
				}),
				BulletText2 = Roact.createElement(BulletPoint, {
					layoutOrder = 2,
					text = t4.bulletPoint2Text,
					width = v50
				}),
				BulletText3 = Roact.createElement(BulletPoint, {
					layoutOrder = 3,
					text = t4.bulletPoint3Text,
					width = v50
				})
			})
		})
	end)
end
function v15.renderDisclosure(_: {[any]: any}, t6: {[any]: any}) -- line: 321
	-- upvalues: withStyle (copy), Roact (copy)
	return withStyle(function(p8) -- line: 322
		-- upvalues: Roact (copy), t6 (copy)
		local Theme = p8.Theme
		local p8Font = p8.Font

		return Roact.createElement("Frame", {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12)
			}),
			Disclosure = Roact.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				RichText = true,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = p8Font.Body.Font,
				Text = t6.shortDisclosure,
				TextSize = p8Font.BaseSize * p8Font.Body.RelativeSize,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			})
		})
	end)
end
function v15.renderLandscapePrompt(t7: {[any]: any}, t8: {[any]: any}) -- line: 352
	-- upvalues: withStyle (copy), Roact (copy), PartialPageModal (copy), ButtonType (copy)
	local props = t7.props

	return withStyle(function(_) -- line: 355
		-- upvalues: Roact (copy), PartialPageModal (copy), t8 (copy), props (copy), ButtonType (copy), t7 (copy)
		return Roact.createElement(PartialPageModal, {
			title = t8.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttonHeight = 48,
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.purchasePremiumActivated,
						text = t8.monthlyLocalizedText,
						inputIcon = props.acceptControllerIcon
					}
				}}
			},
			onCloseClicked = props.cancelPurchaseActivated
		}, { Roact.createElement("ScrollingFrame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			ScrollingEnabled = true,
			ScrollBarThickness = 5,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, props.screenSize.Y / 2),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.new(1, 0, 0, (math.min(props.screenSize.Y / 2 + 96 + 12, 450)))
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			IconAndPremiumInfoContainer = t7:renderCondensedPremiumInfo(t8),
			BulletList = t7:renderBulletInfo(t8),
			Disclosure = t7:renderDisclosure(t8)
		}) })
	end)
end
function v15.renderPortraitPrompt(t9: {[any]: any}, t10: {[any]: any}) -- line: 403
	-- upvalues: withStyle (copy), Roact (copy), PartialPageModal (copy), ButtonType (copy)
	local props = t9.props

	return withStyle(function(_) -- line: 406
		-- upvalues: Roact (copy), PartialPageModal (copy), t10 (copy), props (copy), ButtonType (copy), t9 (copy)
		return Roact.createElement(PartialPageModal, {
			title = t10.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttonHeight = 48,
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.purchasePremiumActivated,
						text = t10.monthlyLocalizedText,
						inputIcon = props.acceptControllerIcon
					}
				}}
			},
			onCloseClicked = props.cancelPurchaseActivated
		}, { Roact.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			IconAndPremiumInfoContainer = t9:renderCondensedPremiumInfo(t10),
			BulletList = t9:renderBulletInfo(t10),
			Disclosure = t9:renderDisclosure(t10)
		}) })
	end)
end
function v15.renderUpdatedPrompt(t11: {[any]: any}, t12: {[any]: any}) -- line: 443
	-- upvalues: withStyle (copy), getPartialPageModalMiddleContentWidth (copy), Roact (copy), PartialPageModal (copy), ButtonType (copy), FitFrameVertical (copy), ImageSetLabel (copy), Images (copy), BulletPoint (copy)
	local props = t11.props

	return withStyle(function(p11) -- line: 446
		-- upvalues: getPartialPageModalMiddleContentWidth (copy), t11 (copy), Roact (copy), PartialPageModal (copy), t12 (copy), props (copy), ButtonType (copy), FitFrameVertical (copy), ImageSetLabel (copy), Images (copy), BulletPoint (copy)
		local Theme = p11.Theme
		local p11Font = p11.Font
		local v59 = getPartialPageModalMiddleContentWidth(t11.props.screenSize.X)

		return Roact.createElement(PartialPageModal, {
			title = t12.titleLocalizedText,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttonHeight = 48,
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.purchasePremiumActivated,
						text = t12.monthlyLocalizedText,
						inputIcon = props.acceptControllerIcon
					}
				}}
			},
			onCloseClicked = props.cancelPurchaseActivated
		}, { Roact.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 12),
			margin = {
				top = 12,
				bottom = 12
			},
			[Roact.Change.AbsoluteSize] = function(p12) -- line: 479
				-- upvalues: t11 (copy)
				if t11.contentSize.X ~= p12.AbsoluteSize.X or t11.contentSize.Y ~= p12.AbsoluteSize.Y then
					t11.updateContentSizes(t11.props.screenSize, p12.AbsoluteSize)
				end
			end
		}, {
			Icon = Roact.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = t11.state.iconSize,
				ScaleType = Enum.ScaleType.Fit,
				Image = Images["icons/graphic/premium_large"]
			}),
			PremiumInfoContainer = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
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
					RichText = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Center,
					Font = p11Font.Header2.Font,
					Text = t12.headerLocalizedText,
					TextSize = p11Font.BaseSize * p11Font.Header2.RelativeSize,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency
				}),
				CostPerMonth = Roact.createElement("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					RichText = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Center,
					Font = p11Font.Body.Font,
					Text = t12.priceLocalizedText,
					TextSize = p11Font.BaseSize,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextDefault.Transparency
				}),
				CancelText = Roact.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Center,
					Font = p11Font.Body.Font,
					Text = t12.policyLocalizedText,
					TextSize = p11Font.BaseSize,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				})
			}),
			BulletListText = Roact.createElement("TextLabel", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v59, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = p11Font.Body.Font,
				Text = t12.descLocalizedText,
				TextSize = p11Font.BaseSize * p11Font.Body.RelativeSize,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			}),
			BulletList = Roact.createElement(FitFrameVertical, {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12)
			}, {
				BulletText1 = Roact.createElement(BulletPoint, {
					layoutOrder = 1,
					text = t12.bulletPoint1Text,
					width = v59
				}),
				BulletText2 = Roact.createElement(BulletPoint, {
					layoutOrder = 2,
					text = t12.bulletPoint2Text,
					width = v59
				}),
				BulletText3 = Roact.createElement(BulletPoint, {
					layoutOrder = 3,
					text = t12.bulletPoint3Text,
					width = v59
				})
			}),
			Disclosure = t11:renderDisclosure(t12)
		}) })
	end)
end
function v15.renderPrompt(t13: {[any]: any}, t14: {[any]: any}) -- line: 585
	local props = t13.props

	if props.screenSize.Y < 450 then
		return t13:renderLandscapePrompt(t14)
	end

	if props.screenSize.X < 450 then
		return t13:renderPortraitPrompt(t14)
	end

	return t13:renderUpdatedPrompt(t14)
end

return v15
