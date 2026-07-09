local Parent = script:FindFirstAncestor("LandingPage").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FIntScaleBrazilContentRatingBadge = require(Parent.SharedFlags).FIntScaleBrazilContentRatingBadge
local v5 = game:DefineFastFlag("BrazilBadgeDisableTextScaling", false)
local v6 = game:DefineFastFlag("BrazilBadgeDoNotCapitalizeHeader", false)
local v7 = game:DefineFastFlag("BrazilBadgeUseRobotoCondensedFont", false)
local v8 = game:DefineFastFlag("BrazilBadgeHideInappropriateAndUse16Image", false)
local v9 = 2.82 * FIntScaleBrazilContentRatingBadge
local uDim = UDim.new(0, 0.08 * FIntScaleBrazilContentRatingBadge)
local v11 = 0.6 * FIntScaleBrazilContentRatingBadge
local v12 = (not v7 and 0.08 or 0.13) * FIntScaleBrazilContentRatingBadge
local color3 = Color3.fromRGB(0, 0, 0)
local color3_2 = Color3.fromRGB(255, 255, 255)
local v15 = if not v7 then nil else Font.new("rbxasset://fonts/families/RobotoCondensed.json")

local function BrazilContentRatingBadge(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), v8 (copy), v6 (copy), React (copy), v9 (copy), color3 (copy), uDim (copy), FIntScaleBrazilContentRatingBadge (copy), color3_2 (copy), v12 (copy), v15 (copy), v5 (copy), v11 (copy)
	local v18 = useLocalization({
		ratingTitle = "Feature.Landing.Label.BrazilContentRatingLogoTitle",
		ratingTitleSixteen = "Feature.Landing.Label.BrazilContentRatingLogoTitleSixteen",
		violenceText = "Feature.Landing.Label.BrazilContentDescriptorViolence",
		inappropriateLanguageText = "Feature.Landing.Label.BrazilContentDescriptorInappropriateLanguage",
		usersInteractText = "Feature.Landing.Label.BrazilInteractiveElementDescriptorUsersInteract",
		inGamePurchasesText = "Feature.Landing.Label.BrazilInteractiveElementDescriptorInGamePurchases"
	})
	local v19 = if not v8 then v18.ratingTitle else v18.ratingTitleSixteen
	local v20 = if not v6 then string.upper(v19) else v19

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, v9, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = color3,
		LayoutOrder = t1.LayoutOrder
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge),
			PaddingRight = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge),
			PaddingBottom = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Header = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0.28 * FIntScaleBrazilContentRatingBadge),
			Text = v20,
			TextColor3 = color3_2,
			TextSize = v12,
			FontFace = v15,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}, {
			UITextSizeConstraint = if not v5 then nil else React.createElement("UITextSizeConstraint", {
				MaxTextSize = v12
			})
		}),
		Content = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v11 + 0.04 * FIntScaleBrazilContentRatingBadge),
			BackgroundColor3 = color3_2
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 0.06 * FIntScaleBrazilContentRatingBadge)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge),
				PaddingRight = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge),
				PaddingTop = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge),
				PaddingBottom = UDim.new(0, 0.02 * FIntScaleBrazilContentRatingBadge)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 0.04 * FIntScaleBrazilContentRatingBadge)
			}),
			Icon = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, v11, 0, v11),
				Image = not v8 and "rbxasset://textures/ui/LuaApp/graphic/Auth/classind_12.png" or "rbxasset://textures/ui/LuaApp/graphic/Auth/classind_16.png",
				ScaleType = Enum.ScaleType.Fit
			}),
			TextContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, -(v11 + 0.04 * FIntScaleBrazilContentRatingBadge), 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				ViolenceText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0.16 * FIntScaleBrazilContentRatingBadge),
					Text = v18.violenceText,
					TextColor3 = color3,
					TextSize = v12,
					FontFace = v15,
					TextXAlignment = Enum.TextXAlignment.Center
				}, {
					UITextSizeConstraint = if not v5 then nil else React.createElement("UITextSizeConstraint", {
						MaxTextSize = v12
					})
				}),
				InappropriateLanguageText = if v8 then nil else React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0.16 * FIntScaleBrazilContentRatingBadge),
					Text = v18.inappropriateLanguageText,
					TextColor3 = color3,
					TextSize = v12,
					FontFace = v15,
					TextXAlignment = Enum.TextXAlignment.Center
				}, {
					UITextSizeConstraint = if not v5 then nil else React.createElement("UITextSizeConstraint", {
						MaxTextSize = v12
					})
				})
			})
		}),
		Footer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0.36 * FIntScaleBrazilContentRatingBadge)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			UsersInteractText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0.14 * FIntScaleBrazilContentRatingBadge),
				Text = v18.usersInteractText,
				TextColor3 = color3_2,
				TextSize = v12,
				FontFace = v15,
				TextXAlignment = Enum.TextXAlignment.Center
			}, {
				UITextSizeConstraint = if not v5 then nil else React.createElement("UITextSizeConstraint", {
					MaxTextSize = v12
				})
			}),
			InGamePurchasesText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0.14 * FIntScaleBrazilContentRatingBadge),
				Text = v18.inGamePurchasesText,
				TextColor3 = color3_2,
				TextSize = v12,
				FontFace = v15,
				TextXAlignment = Enum.TextXAlignment.Center
			}, {
				UITextSizeConstraint = if not v5 then nil else React.createElement("UITextSizeConstraint", {
					MaxTextSize = v12
				})
			})
		})
	})
end

return BrazilContentRatingBadge
