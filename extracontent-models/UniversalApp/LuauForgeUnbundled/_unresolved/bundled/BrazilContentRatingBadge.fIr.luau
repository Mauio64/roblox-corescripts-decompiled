local module = require("@luauforge/bundled/fHU")
local useLocalization = require("@luauforge/bundled/fHZ").Hooks.useLocalization

local fIntScaleBrazilContentRatingBadge = require("@luauforge/bundled/fHR").FIntScaleBrazilContentRatingBadge

local defineFastFlag = game:DefineFastFlag("BrazilBadgeDisableTextScaling", false)
local defineFastFlag2 = game:DefineFastFlag("BrazilBadgeDoNotCapitalizeHeader", false)
local defineFastFlag3 = game:DefineFastFlag("BrazilBadgeUseRobotoCondensedFont", false)

local defineFastFlag4 = game:DefineFastFlag("BrazilBadgeHideInappropriateAndUse16Image", false)

local v5 = 2.82 * fIntScaleBrazilContentRatingBadge
local udim = UDim.new(0, 0.08 * fIntScaleBrazilContentRatingBadge)
local v6 = 0.6 * fIntScaleBrazilContentRatingBadge
local v7 = (defineFastFlag3 and 0.13 or 0.08) * fIntScaleBrazilContentRatingBadge

local color = Color3.fromRGB(0, 0, 0)
local color2 = Color3.fromRGB(255, 255, 255)
local rbxassetfontsfamiliesRobotoCondensedjson

if defineFastFlag3 then
	rbxassetfontsfamiliesRobotoCondensedjson = Font.new("rbxasset://fonts/families/RobotoCondensed.json")
else
	rbxassetfontsfamiliesRobotoCondensedjson = nil
end

local function BrazilContentRatingBadge(p2)
	local v8 = useLocalization({
		ratingTitle = "Feature.Landing.Label.BrazilContentRatingLogoTitle",
		ratingTitleSixteen = "Feature.Landing.Label.BrazilContentRatingLogoTitleSixteen",
		violenceText = "Feature.Landing.Label.BrazilContentDescriptorViolence",
		inappropriateLanguageText = "Feature.Landing.Label.BrazilContentDescriptorInappropriateLanguage",
		usersInteractText = "Feature.Landing.Label.BrazilInteractiveElementDescriptorUsersInteract",
		inGamePurchasesText = "Feature.Landing.Label.BrazilInteractiveElementDescriptorInGamePurchases"
	})

	local v9 = if defineFastFlag4 then v8.ratingTitleSixteen else v8.ratingTitle

	if not defineFastFlag2 then
		v9 = string.upper(v9)
	end

	local createElement = module.createElement
	local v11 = {
		Size = UDim2.new(0, v5, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		LayoutOrder = p2.LayoutOrder
	}
	local children = {
		UICorner = module.createElement("UICorner", { CornerRadius = udim }),
		UIPadding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge),
			PaddingRight = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge),
			PaddingBottom = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge)
		}),
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Header = 0,
		Content = 0,
		Footer = 0
	}

	local createElement2 = module.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 0, 0.28 * fIntScaleBrazilContentRatingBadge),
		BackgroundTransparency = 1,
		Text = v9,
		TextColor3 = color2,
		TextSize = v7,
		FontFace = rbxassetfontsfamiliesRobotoCondensedjson,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		LayoutOrder = 1
	}

	local v15 = if defineFastFlag then module.createElement("UITextSizeConstraint", {
		MaxTextSize = v7
	}) else nil
	children.Header = createElement2("TextLabel", v13, { UITextSizeConstraint = v15 })

	local createElement3 = module.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 0, v6 + 0.04 * fIntScaleBrazilContentRatingBadge),
		BackgroundColor3 = color2,
		BorderSizePixel = 0,
		LayoutOrder = 2
	}

	local v18 = {
		UICorner = module.createElement("UICorner", {
			CornerRadius = UDim.new(0, 0.06 * fIntScaleBrazilContentRatingBadge)
		}),
		UIPadding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge),
			PaddingRight = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge),
			PaddingTop = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge),
			PaddingBottom = UDim.new(0, 0.02 * fIntScaleBrazilContentRatingBadge)
		}),
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0.04 * fIntScaleBrazilContentRatingBadge)
		}),
		Icon = module.createElement("ImageLabel", {
			Size = UDim2.new(0, v6, 0, v6),
			BackgroundTransparency = 1,
			Image = defineFastFlag4 and "rbxasset://textures/ui/LuaApp/graphic/Auth/classind_16.png" or "rbxasset://textures/ui/LuaApp/graphic/Auth/classind_12.png",
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1
		}),
		TextContainer = 0
	}

	local createElement4 = module.createElement
	local v20 = {
		Size = UDim2.new(1, -(v6 + 0.04 * fIntScaleBrazilContentRatingBadge), 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v21 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		ViolenceText = 0,
		InappropriateLanguageText = 0
	}

	local createElement5 = module.createElement
	local v23 = {
		Size = UDim2.new(1, 0, 0, 0.16 * fIntScaleBrazilContentRatingBadge),
		BackgroundTransparency = 1,
		Text = v8.violenceText,
		TextColor3 = color,
		TextSize = v7,
		FontFace = rbxassetfontsfamiliesRobotoCondensedjson,
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = 1
	}

	local v25 = if defineFastFlag then module.createElement("UITextSizeConstraint", {
		MaxTextSize = v7
	}) else nil
	v21.ViolenceText = createElement5("TextLabel", v23, { UITextSizeConstraint = v25 })
	local v26

	if not defineFastFlag4 then
		local createElement6 = module.createElement
		local v28 = {
			Size = UDim2.new(1, 0, 0, 0.16 * fIntScaleBrazilContentRatingBadge),
			BackgroundTransparency = 1,
			Text = v8.inappropriateLanguageText,
			TextColor3 = color,
			TextSize = v7,
			FontFace = rbxassetfontsfamiliesRobotoCondensedjson,
			TextXAlignment = Enum.TextXAlignment.Center,
			LayoutOrder = 2
		}

		local v30 = if defineFastFlag then module.createElement("UITextSizeConstraint", {
			MaxTextSize = v7
		}) else nil
		v26 = createElement6("TextLabel", v28, { UITextSizeConstraint = v30 })
	end

	v21.InappropriateLanguageText = v26
	v18.TextContainer = createElement4("Frame", v20, v21)
	children.Content = createElement3("Frame", v17, v18)

	local createElement6 = module.createElement
	local v28 = {
		Size = UDim2.new(1, 0, 0, 0.36 * fIntScaleBrazilContentRatingBadge),
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}

	local children2 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UsersInteractText = 0,
		InGamePurchasesText = 0
	}

	local createElement7 = module.createElement
	local v30 = {
		Size = UDim2.new(1, 0, 0, 0.14 * fIntScaleBrazilContentRatingBadge),
		BackgroundTransparency = 1,
		Text = v8.usersInteractText,
		TextColor3 = color2,
		TextSize = v7,
		FontFace = rbxassetfontsfamiliesRobotoCondensedjson,
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = 1
	}

	local v32 = if defineFastFlag then module.createElement("UITextSizeConstraint", {
		MaxTextSize = v7
	}) else nil
	children2.UsersInteractText = createElement7("TextLabel", v30, {
		UITextSizeConstraint = v32
	})

	local createElement8 = module.createElement
	local v34 = {
		Size = UDim2.new(1, 0, 0, 0.14 * fIntScaleBrazilContentRatingBadge),
		BackgroundTransparency = 1,
		Text = v8.inGamePurchasesText,
		TextColor3 = color2,
		TextSize = v7,
		FontFace = rbxassetfontsfamiliesRobotoCondensedjson,
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = 2
	}

	local v36 = if defineFastFlag then module.createElement("UITextSizeConstraint", {
		MaxTextSize = v7
	}) else nil
	children2.InGamePurchasesText = createElement8("TextLabel", v34, {
		UITextSizeConstraint = v36
	})
	children.Footer = createElement6("Frame", v28, children2)
	return createElement("Frame", v11, children)
end

return BrazilContentRatingBadge
