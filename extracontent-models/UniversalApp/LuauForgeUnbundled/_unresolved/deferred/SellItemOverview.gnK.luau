local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local module = require("@luauforge/bundled/dRQ")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/fTi")

local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local controlState = UIBlox.Core.Control.Enum.ControlState
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local module3 = require("@luauforge/deferred/gnL")

local iconscommonrobux = images["icons/common/robux"]
local iconsactionsinfo_small = images["icons/actions/info_small"]

local function getRobloxCommissionAmount(p2, marketplaceFee)
	if not p2 or p2 <= 0 then
		return 0, 0
	end

	local taxRate = marketplaceFee.taxRate
	local minimumFee = marketplaceFee.minimumFee

	if not module3() then
		return math.max(module.Round(taxRate * p2), minimumFee), 0
	end

	local bankersRounding = module.bankersRounding(p2 * (1 - taxRate))
	local v5 = p2 - bankersRounding

	if v5 < minimumFee then
		return minimumFee, p2 - minimumFee
	end

	return v5, bankersRounding
end

local function SellItemOverview(props)
	local v5 = module2({
		overviewLabel = "Feature.Catalog.Heading.Overview",
		robloxFeeText = "Feature.Catalog.Label.Fee",
		sellCutText = "Feature.Catalog.Label.SellCut"
	})

	local v6 = useStyle()

	local theme = v6.Theme
	local font = v6.Font
	local subHeader1 = font.SubHeader1
	local body = font.Body
	local relativeSize = subHeader1.RelativeSize
	local relativeSize2 = body.RelativeSize
	local baseSize = font.BaseSize

	local v7 = relativeSize * baseSize
	local v8 = relativeSize2 * baseSize

	local v9 = props.marketplaceFee.taxRate * 100
	local v10 = v5.robloxFeeText:gsub("({feePercentage})", v9)

	local v11 = tonumber((not props.priceInRobux or props.priceInRobux == "") and 0 or props.priceInRobux)
	local v12, v13

	if module3() then
		v12, v13 = getRobloxCommissionAmount(v11, props.marketplaceFee)
	else
		v12 = getRobloxCommissionAmount(v11, props.marketplaceFee)
		v13 = module.Round(v11 - v12)
	end

	local localize = numberLocalization.localize(v12, LocalizationService.RobloxLocaleId)
	local v14 = string.format("%.0f", v13)
	local localize2 = numberLocalization.localize(v14, LocalizationService.RobloxLocaleId)

	local v15 = useNavigation()

	local function onStateChanged(p2, p3)
		if p3 == controlState.Pressed or p3 == controlState.SelectedPressed then
			v15.navigate(avatarScreen.ResaleFeePolicyPrompt, {
				yourSharePercent = 100 - v9,
				robloxFeePercent = v9
			})
		end
	end

	local createElement = React.createElement
	local v17 = {
		LayoutOrder = props.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		}),
		OverviewFrameContainer = 0,
		CommissionContainer = 0,
		YouEarnContainer = 0
	}

	local createElement2 = React.createElement
	local v19 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local children2 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		OverviewSubHeader = 0,
		OverviewInfoButton = 0
	}

	local createElement3 = React.createElement
	local v21 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = v5.overviewLabel,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}
	local v22 = if not foundationFontFaceMigration then subHeader1.Font else nil
	v21.Font = v22

	local v23 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font) else nil
	v21.FontFace = v23

	v21.TextSize = v7
	v21.TextXAlignment = Enum.TextXAlignment.Left
	v21.TextColor3 = theme.TextEmphasis.Color
	v21.TextTransparency = theme.TextEmphasis.Transparency
	children2.OverviewSubHeader = createElement3("TextLabel", v21)

	children2.OverviewInfoButton = React.createElement(iconButton, {
		layoutOrder = 2,
		icon = iconsactionsinfo_small,
		iconSize = iconSize.Small,
		onStateChanged = onStateChanged,
		iconColor3 = theme.IconEmphasis.Color,
		iconTransparency = theme.IconEmphasis.Transparency,
		backgroundTransparency = 1
	})
	children.OverviewFrameContainer = createElement2("Frame", v19, children2)

	local createElement4 = React.createElement
	local v25 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local createElement5 = React.createElement
	local v27 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = v10,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}

	local v28 = if not foundationFontFaceMigration then body.Font else nil
	v27.Font = v28

	local v29 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v27.FontFace = v29

	v27.TextSize = v8
	v27.TextXAlignment = Enum.TextXAlignment.Left
	v27.TextColor3 = theme.TextDefault.Color
	v27.TextTransparency = theme.TextDefault.Transparency
	local children3 = {
		CommissionLabel = createElement5("TextLabel", v27),
		CommissionAmountContainer = 0
	}

	local createElement6 = React.createElement
	local v31 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1
	}

	local children4 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		CommissionMinusText = 0,
		CommissionRobuxImage = 0,
		CommissionAmountText = 0
	}

	local createElement7 = React.createElement
	local v33 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = "-",
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}

	local v34 = if not foundationFontFaceMigration then body.Font else nil
	v33.Font = v34

	local v35 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v33.FontFace = v35

	v33.TextSize = v8
	v33.TextXAlignment = Enum.TextXAlignment.Right
	v33.TextColor3 = theme.TextDefault.Color
	v33.TextTransparency = theme.TextDefault.Transparency
	children4.CommissionMinusText = createElement7("TextLabel", v33)

	children4.CommissionRobuxImage = React.createElement(imageSetLabel, {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Image = iconscommonrobux,
		Size = UDim2.fromOffset(v8, v8),
		ImageColor3 = theme.TextDefault.Color,
		ImageTransparency = theme.TextDefault.Transparency,
		BackgroundTransparency = 1
	})

	local createElement8 = React.createElement
	local v37 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = localize,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}

	local v38 = if not foundationFontFaceMigration then body.Font else nil
	v37.Font = v38

	local v39 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v37.FontFace = v39

	v37.TextSize = v8
	v37.TextXAlignment = Enum.TextXAlignment.Right
	v37.TextColor3 = theme.TextDefault.Color
	v37.TextTransparency = theme.TextDefault.Transparency
	children4.CommissionAmountText = createElement8("TextLabel", v37)
	children3.CommissionAmountContainer = createElement6("Frame", v31, children4)
	children.CommissionContainer = createElement4("Frame", v25, children3)

	local createElement9 = React.createElement
	local v41 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local createElement10 = React.createElement
	local v43 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = v5.sellCutText,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}
	local v44 = if not foundationFontFaceMigration then body.Font else nil
	v43.Font = v44

	local v45 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v43.FontFace = v45

	v43.TextSize = v8
	v43.TextXAlignment = Enum.TextXAlignment.Left
	v43.TextColor3 = theme.TextDefault.Color
	v43.TextTransparency = theme.TextDefault.Transparency
	local children5 = {
		YouEarnLabel = createElement10("TextLabel", v43),
		YouEarnAmountRobuxContainer = 0
	}

	local createElement11 = React.createElement
	local v47 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1
	}

	local v48 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		YouEarnRobuxImage = React.createElement(imageSetLabel, {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Image = iconscommonrobux,
			Size = UDim2.fromOffset(v8, v8),
			ImageColor3 = theme.TextDefault.Color,
			ImageTransparency = theme.TextDefault.Transparency,
			BackgroundTransparency = 1
		}),
		YouEarnAmountText = 0
	}

	local createElement12 = React.createElement
	local v50 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = localize2,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}

	local v51 = if not foundationFontFaceMigration then body.Font else nil
	v50.Font = v51

	local v52 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v50.FontFace = v52

	v50.TextSize = v8
	v50.TextXAlignment = Enum.TextXAlignment.Right
	v50.TextColor3 = theme.TextDefault.Color
	v50.TextTransparency = theme.TextDefault.Transparency
	v48.YouEarnAmountText = createElement12("TextLabel", v50)
	children5.YouEarnAmountRobuxContainer = createElement11("Frame", v47, v48)
	children.YouEarnContainer = createElement9("Frame", v41, children5)
	return createElement("Frame", v17, children)
end

return SellItemOverview
